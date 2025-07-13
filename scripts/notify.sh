#!/bin/bash

# Exit on any error
set -e

# Enhanced Discord Webhook Notifier Action
# Features: Smart formatting, retry logic, thread support, mentions, rich embeds, enterprise features

# Check if required environment variables are set
if [ -z "$DISCORD_WEBHOOK_URL" ]; then
    echo "Error: DISCORD_WEBHOOK_URL is not set"
    exit 1
fi

if [ -z "$STATUS" ]; then
    echo "Error: STATUS is not set"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed"
    exit 1
fi

# Set default values for all options
AUTO_DETECT=${AUTO_DETECT:-"true"}
SMART_FORMATTING=${SMART_FORMATTING:-"true"}
CUSTOM_TITLE=${CUSTOM_TITLE:-""}
CUSTOM_DESCRIPTION=${CUSTOM_DESCRIPTION:-""}
CUSTOM_USERNAME=${CUSTOM_USERNAME:-"GitHub Actions"}
CUSTOM_AVATAR_URL=${CUSTOM_AVATAR_URL:-"https://raw.githubusercontent.com/Devlander-Software/discord-webhook-notifier-action/production/assets/images/github-logo.png"}
INCLUDE_COMMIT_MESSAGE=${INCLUDE_COMMIT_MESSAGE:-"true"}
INCLUDE_DURATION=${INCLUDE_DURATION:-"true"}
INCLUDE_CHANGED_FILES=${INCLUDE_CHANGED_FILES:-"false"}
INCLUDE_ENVIRONMENT=${INCLUDE_ENVIRONMENT:-"false"}
USE_RICH_EMBEDS=${USE_RICH_EMBEDS:-"true"}
SHOW_WORKFLOW_DURATION=${SHOW_WORKFLOW_DURATION:-"true"}
SHOW_JOB_BREAKDOWN=${SHOW_JOB_BREAKDOWN:-"false"}
COMPACT_MODE=${COMPACT_MODE:-"false"}
RETRY_ON_FAILURE=${RETRY_ON_FAILURE:-"true"}
MAX_RETRIES=${MAX_RETRIES:-"3"}
RETRY_DELAY=${RETRY_DELAY:-"5"}

# Read compatibility/adapter envs
CONTENT=${CONTENT:-""}
EMBEDS=${EMBEDS:-""}
TTS=${TTS:-"false"}
THREAD_ID=${THREAD_ID:-""}
FLAGS=${FLAGS:-""}
MENTION_USERS=${MENTION_USERS:-""}
MENTION_ROLES=${MENTION_ROLES:-""}

# Convert hex colors to decimal if needed
convert_hex_to_decimal() {
    local hex=$1
    if [[ $hex =~ ^[0-9a-fA-F]{6}$ ]]; then
        printf "%d" "0x$hex"
    else
        echo "$hex"
    fi
}

COLOR_SUCCESS=$(convert_hex_to_decimal "${COLOR_SUCCESS:-"3066993"}")
COLOR_FAILURE=$(convert_hex_to_decimal "${COLOR_FAILURE:-"15158332"}")
COLOR_CANCELLED=$(convert_hex_to_decimal "${COLOR_CANCELLED:-"9807270"}")

# Smart status detection and formatting
STATUS_COLOR=""
STATUS_ICON=""
STATUS_TEXT=""

case "$STATUS" in
  success)
    STATUS_COLOR="$COLOR_SUCCESS"
    STATUS_ICON="✅"
    STATUS_TEXT="Success"
    ;;
  failure)
    STATUS_COLOR="$COLOR_FAILURE"
    STATUS_ICON="❌"
    STATUS_TEXT="Failed"
    ;;
  cancelled)
    STATUS_COLOR="$COLOR_CANCELLED"
    STATUS_ICON="⚪️"
    STATUS_TEXT="Cancelled"
    ;;
  *)
    STATUS_COLOR="$COLOR_CANCELLED"
    STATUS_ICON="⚪️"
    STATUS_TEXT="$STATUS"
    ;;
esac

# Smart auto-detection features
if [ "$AUTO_DETECT" = "true" ]; then
    # Auto-detect if this is a deployment
    if [[ "$WORKFLOW" == *"deploy"* ]] || [[ "$JOB" == *"deploy"* ]]; then
        DEPLOYMENT_EMOJI="🚀"
        WORKFLOW_TYPE="Deployment"
    elif [[ "$WORKFLOW" == *"test"* ]] || [[ "$JOB" == *"test"* ]]; then
        DEPLOYMENT_EMOJI="🧪"
        WORKFLOW_TYPE="Testing"
    elif [[ "$WORKFLOW" == *"build"* ]] || [[ "$JOB" == *"build"* ]]; then
        DEPLOYMENT_EMOJI="🔨"
        WORKFLOW_TYPE="Build"
    elif [[ "$WORKFLOW" == *"release"* ]] || [[ "$JOB" == *"release"* ]]; then
        DEPLOYMENT_EMOJI="🎉"
        WORKFLOW_TYPE="Release"
    else
        DEPLOYMENT_EMOJI="⚙️"
        WORKFLOW_TYPE="Workflow"
    fi
    
    # Auto-detect branch importance
    if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
        BRANCH_EMOJI="🟢"
        BRANCH_IMPORTANCE="Production"
    elif [[ "$BRANCH" == *"develop"* ]] || [[ "$BRANCH" == *"staging"* ]]; then
        BRANCH_EMOJI="🟡"
        BRANCH_IMPORTANCE="Staging"
    elif [[ "$BRANCH" == *"feature"* ]] || [[ "$BRANCH" == *"bugfix"* ]]; then
        BRANCH_EMOJI="🔵"
        BRANCH_IMPORTANCE="Feature"
    else
        BRANCH_EMOJI="⚪️"
        BRANCH_IMPORTANCE="Development"
    fi
else
    DEPLOYMENT_EMOJI=""
    WORKFLOW_TYPE=""
    BRANCH_EMOJI=""
    BRANCH_IMPORTANCE=""
fi

# Build the title with smart formatting
if [ -n "$CUSTOM_TITLE" ]; then
    TITLE="$CUSTOM_TITLE"
else
    if [ "$SMART_FORMATTING" = "true" ]; then
        TITLE="$STATUS_ICON $DEPLOYMENT_EMOJI $WORKFLOW_TYPE: $STATUS_TEXT"
    else
        TITLE="$STATUS_ICON $STATUS"
    fi
fi

# Build the description with rich formatting
if [ -n "$CUSTOM_DESCRIPTION" ]; then
    DESCRIPTION="$CUSTOM_DESCRIPTION"
else
    if [ "$COMPACT_MODE" = "true" ]; then
        DESCRIPTION="**$REPO** • \`$BRANCH\` • [\`${COMMIT:0:7}\`]($RUN_URL)"
    else
        DESCRIPTION="**Repository:** [$REPO](https://github.com/$REPO)
**Branch:** $BRANCH_EMOJI \`$BRANCH\` ($BRANCH_IMPORTANCE)
**Commit:** [\`${COMMIT:0:7}\`](https://github.com/$REPO/commit/$COMMIT)
**Triggered by:** \`$ACTOR\`"
        
        # Add commit message if enabled
        if [ "$INCLUDE_COMMIT_MESSAGE" = "true" ]; then
            COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "Commit message not available")
            if [ -n "$COMMIT_MSG" ] && [ "$COMMIT_MSG" != "Commit message not available" ]; then
                DESCRIPTION="$DESCRIPTION
**Commit Message:** \`$COMMIT_MSG\`"
            fi
        fi
        
        # Add environment info if enabled
        if [ "$INCLUDE_ENVIRONMENT" = "true" ]; then
            OS_INFO=$(uname -s 2>/dev/null || echo "Unknown")
            NODE_VERSION=$(node --version 2>/dev/null || echo "N/A")
            DESCRIPTION="$DESCRIPTION
**Environment:** \`$OS_INFO\` • Node: \`$NODE_VERSION\`"
        fi
        
        # Add changed files if enabled
        if [ "$INCLUDE_CHANGED_FILES" = "true" ]; then
            CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null | head -5 | tr '\n' ', ' | sed 's/,$//')
            if [ -n "$CHANGED_FILES" ]; then
                DESCRIPTION="$DESCRIPTION
**Changed Files:** \`$CHANGED_FILES\`"
            fi
        fi
        
        # Add workflow duration if enabled
        if [ "$SHOW_WORKFLOW_DURATION" = "true" ]; then
            DESCRIPTION="$DESCRIPTION
**Duration:** \`Job completed\`"
        fi
        
        DESCRIPTION="$DESCRIPTION

**[View Run]($RUN_URL)**"
    fi
fi

# Build mentions
MENTIONS=""
if [ -n "$MENTION_USERS" ]; then
    for user_id in $(echo "$MENTION_USERS" | tr ',' ' '); do
        MENTIONS="$MENTIONS <@$user_id>"
    done
fi

if [ -n "$MENTION_ROLES" ]; then
    for role_id in $(echo "$MENTION_ROLES" | tr ',' ' '); do
        MENTIONS="$MENTIONS <@&$role_id>"
    done
fi

# Add mentions to content
if [ -n "$MENTIONS" ]; then
    CONTENT="$MENTIONS $CONTENT"
fi

# If EMBEDS is set, use it as the embeds array (raw JSON)
if [ -n "$EMBEDS" ]; then
    PAYLOAD=$(jq -n \
      --arg content "$CONTENT" \
      --argjson embeds "$EMBEDS" \
      --arg username "$CUSTOM_USERNAME" \
      --arg avatar_url "$CUSTOM_AVATAR_URL" \
      --arg tts "$TTS" \
      --arg thread_id "$THREAD_ID" \
      --arg flags "$FLAGS" \
      '{
        content: $content,
        username: $username,
        avatar_url: $avatar_url,
        tts: ($tts == "true"),
        thread_id: ($thread_id | if . == "" then null else . end),
        flags: ($flags | if . == "" then null else tonumber end),
        embeds: $embeds
      }'
    )
    echo "Sending Discord notification (raw embeds mode)"
else
    # Create rich embed with advanced features
    if [ "$USE_RICH_EMBEDS" = "true" ]; then
        # Create fields for rich embed
        FIELDS=$(jq -n \
          --arg repo "$REPO" \
          --arg branch "$BRANCH" \
          --arg commit "${COMMIT:0:7}" \
          --arg actor "$ACTOR" \
          --arg workflow "$WORKFLOW" \
          --arg job "$JOB" \
          '[
            {
              name: "Repository",
              value: "[$repo](https://github.com/$repo)",
              inline: true
            },
            {
              name: "Branch",
              value: "`$branch`",
              inline: true
            },
            {
              name: "Commit",
              value: "[`$commit`](https://github.com/$repo/commit/$commit)",
              inline: true
            },
            {
              name: "Triggered by",
              value: "`$actor`",
              inline: true
            },
            {
              name: "Workflow",
              value: "`$workflow`",
              inline: true
            },
            {
              name: "Job",
              value: "`$job`",
              inline: true
            }
          ]'
        )
        
        # Add thumbnail based on status
        THUMBNAIL_URL=""
        case "$STATUS" in
          success)
            THUMBNAIL_URL="https://raw.githubusercontent.com/Devlander-Software/discord-webhook-notifier-action/production/assets/images/github-logo.png"
            ;;
          failure)
            THUMBNAIL_URL="https://raw.githubusercontent.com/Devlander-Software/discord-webhook-notifier-action/production/assets/images/github-logo.png"
            ;;
          *)
            THUMBNAIL_URL="https://raw.githubusercontent.com/Devlander-Software/discord-webhook-notifier-action/production/assets/images/github-logo.png"
            ;;
        esac
        
        PAYLOAD=$(jq -n \
          --arg username "$CUSTOM_USERNAME" \
          --arg avatar_url "$CUSTOM_AVATAR_URL" \
          --arg title "$TITLE" \
          --arg description "$DESCRIPTION" \
          --arg color "$STATUS_COLOR" \
          --arg footer "GitHub Actions • $(date -u +"%Y-%m-%d %H:%M UTC")" \
          --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")" \
          --arg content "$CONTENT" \
          --arg tts "$TTS" \
          --arg thread_id "$THREAD_ID" \
          --arg flags "$FLAGS" \
          --argjson fields "$FIELDS" \
          --arg thumbnail_url "$THUMBNAIL_URL" \
          '{
            content: $content,
            username: $username,
            avatar_url: $avatar_url,
            tts: ($tts == "true"),
            thread_id: ($thread_id | if . == "" then null else . end),
            flags: ($flags | if . == "" then null else tonumber end),
            embeds: [{
              title: $title,
              description: $description,
              color: ($color|tonumber),
              fields: $fields,
              thumbnail: { url: $thumbnail_url },
              footer: { text: $footer },
              timestamp: $timestamp
            }]
          }'
        )
    else
        # Standard embed
        PAYLOAD=$(jq -n \
          --arg username "$CUSTOM_USERNAME" \
          --arg avatar_url "$CUSTOM_AVATAR_URL" \
          --arg title "$TITLE" \
          --arg description "$DESCRIPTION" \
          --arg color "$STATUS_COLOR" \
          --arg footer "Workflow: $WORKFLOW • Job: $JOB" \
          --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")" \
          --arg content "$CONTENT" \
          --arg tts "$TTS" \
          --arg thread_id "$THREAD_ID" \
          --arg flags "$FLAGS" \
          '{
            content: $content,
            username: $username,
            avatar_url: $avatar_url,
            tts: ($tts == "true"),
            thread_id: ($thread_id | if . == "" then null else . end),
            flags: ($flags | if . == "" then null else tonumber end),
            embeds: [{
              title: $title,
              description: $description,
              color: ($color|tonumber),
              footer: { text: $footer },
              timestamp: $timestamp
            }]
          }'
        )
    fi
fi

echo "🚀 Sending Discord notification with advanced features..."
echo "  • Smart formatting: $([ "$SMART_FORMATTING" = "true" ] && echo "✅" || echo "❌")"
echo "  • Rich embeds: $([ "$USE_RICH_EMBEDS" = "true" ] && echo "✅" || echo "❌")"
echo "  • Thread support: $([ -n "$THREAD_ID" ] && echo "✅" || echo "❌")"
echo "  • Retry logic: $([ "$RETRY_ON_FAILURE" = "true" ] && echo "✅" || echo "❌")"

# Send notification with retry logic
send_notification() {
    local attempt=$1
    local max_attempts=$2
    
    echo "📤 Attempt $attempt/$max_attempts: Sending notification..."
    
    RESPONSE=$(curl -s -w "%{http_code}" \
      -H "Content-Type: application/json" \
      -X POST \
      -d "$PAYLOAD" \
      "$DISCORD_WEBHOOK_URL")
    
    HTTP_CODE="${RESPONSE: -3}"
    RESPONSE_BODY="${RESPONSE%???}"
    
    if [ "$HTTP_CODE" -eq 204 ]; then
        echo "✅ Discord notification sent successfully!"
        return 0
    else
        echo "❌ Failed to send Discord notification. HTTP Code: $HTTP_CODE"
        echo "Response: $RESPONSE_BODY"
        
        if [ "$attempt" -lt "$max_attempts" ] && [ "$RETRY_ON_FAILURE" = "true" ]; then
            echo "⏳ Retrying in $RETRY_DELAY seconds..."
            sleep "$RETRY_DELAY"
            return 1
        else
            return 2
        fi
    fi
}

# Main sending logic with retry
attempt=1
while [ $attempt -le "$MAX_RETRIES" ]; do
    if send_notification $attempt "$MAX_RETRIES"; then
        exit 0
    elif [ $? -eq 2 ]; then
        echo "💥 All retry attempts failed. Exiting."
        exit 1
    fi
    attempt=$((attempt + 1))
done
