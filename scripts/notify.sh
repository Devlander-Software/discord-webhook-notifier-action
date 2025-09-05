#!/bin/bash

# Exit on any error
set -e

# Enhanced Discord Webhook Notifier Action
# Features: Smart formatting, retry logic, thread support, mentions, rich embeds, enterprise features
# Security: Input validation, sanitization, and secure practices

# Security configuration
MAX_INPUT_LENGTH=2000
MAX_TITLE_LENGTH=256
MAX_DESCRIPTION_LENGTH=4096
MAX_USERNAME_LENGTH=80
MAX_CONTENT_LENGTH=2000
ALLOWED_URL_DOMAINS="github.com|github.githubassets.com|raw.githubusercontent.com|cdn.discordapp.com|discord.com"

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

# Security functions
sanitize_input() {
    local input="$1"
    local max_length="${2:-$MAX_INPUT_LENGTH}"
    
    # Remove null bytes and control characters
    input=$(printf '%s' "$input" | tr -d '\0' | tr -d '\001'-\'\037' | tr -d '\177'-\'\377')
    
    # Limit length
    if [ ${#input} -gt $max_length ]; then
        input="${input:0:$max_length}"
    fi
    
    # Escape special characters for shell safety
    printf '%s' "$input" | sed 's/[[\\*^$()+?{|]/\\&/g'
}

validate_url() {
    local url="$1"
    local allowed_domains="$2"
    
    # Check if URL starts with https://
    if [[ ! "$url" =~ ^https:// ]]; then
        return 1
    fi
    
    # Extract domain and check against allowlist
    local domain=$(echo "$url" | sed -n 's|^https://\([^/]*\).*|\1|p')
    if [[ ! "$domain" =~ ^($allowed_domains)$ ]]; then
        return 1
    fi
    
    return 0
}

validate_webhook_url() {
    local url="$1"
    
    # Discord webhook URL pattern
    if [[ ! "$url" =~ ^https://discord\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+$ ]]; then
        return 1
    fi
    
    return 0
}

sanitize_json_string() {
    local input="$1"
    
    # Escape JSON special characters
    printf '%s' "$input" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g; s/\r/\\r/g; s/\n/\\n/g'
}

validate_status() {
    local status="$1"
    case "$status" in
        success|failure|cancelled)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Validate critical inputs
if ! validate_webhook_url "$DISCORD_WEBHOOK_URL"; then
    echo "Error: Invalid Discord webhook URL format"
    exit 1
fi

if ! validate_status "$STATUS"; then
    echo "Error: STATUS must be one of: success, failure, cancelled"
    exit 1
fi

# Set default values for all options and sanitize inputs
AUTO_DETECT=$(sanitize_input "${AUTO_DETECT:-true}" 10)
SMART_FORMATTING=$(sanitize_input "${SMART_FORMATTING:-true}" 10)
CUSTOM_TITLE=$(sanitize_input "${CUSTOM_TITLE:-}" $MAX_TITLE_LENGTH)
CUSTOM_DESCRIPTION=$(sanitize_input "${CUSTOM_DESCRIPTION:-}" $MAX_DESCRIPTION_LENGTH)
CUSTOM_USERNAME=$(sanitize_input "${CUSTOM_USERNAME:-GitHub Actions}" $MAX_USERNAME_LENGTH)
CUSTOM_AVATAR_URL="${CUSTOM_AVATAR_URL:-https://raw.githubusercontent.com/Devlander-Software/discord-webhook-notifier-action/production/assets/images/github-logo.png}"
INCLUDE_COMMIT_MESSAGE=$(sanitize_input "${INCLUDE_COMMIT_MESSAGE:-true}" 10)
INCLUDE_DURATION=$(sanitize_input "${INCLUDE_DURATION:-true}" 10)
INCLUDE_CHANGED_FILES=$(sanitize_input "${INCLUDE_CHANGED_FILES:-false}" 10)
INCLUDE_ENVIRONMENT=$(sanitize_input "${INCLUDE_ENVIRONMENT:-false}" 10)
USE_RICH_EMBEDS=$(sanitize_input "${USE_RICH_EMBEDS:-true}" 10)
SHOW_WORKFLOW_DURATION=$(sanitize_input "${SHOW_WORKFLOW_DURATION:-true}" 10)
SHOW_JOB_BREAKDOWN=$(sanitize_input "${SHOW_JOB_BREAKDOWN:-false}" 10)
COMPACT_MODE=$(sanitize_input "${COMPACT_MODE:-false}" 10)
RETRY_ON_FAILURE=$(sanitize_input "${RETRY_ON_FAILURE:-true}" 10)
MAX_RETRIES=$(sanitize_input "${MAX_RETRIES:-3}" 10)
RETRY_DELAY=$(sanitize_input "${RETRY_DELAY:-5}" 10)

# Read compatibility/adapter envs and sanitize
CONTENT=$(sanitize_input "${CONTENT:-}" $MAX_CONTENT_LENGTH)
EMBEDS=$(sanitize_input "${EMBEDS:-}" 10000)  # Allow larger JSON
TTS=$(sanitize_input "${TTS:-false}" 10)
THREAD_ID=$(sanitize_input "${THREAD_ID:-}" 50)
FLAGS=$(sanitize_input "${FLAGS:-}" 50)
MENTION_USERS=$(sanitize_input "${MENTION_USERS:-}" 500)
MENTION_ROLES=$(sanitize_input "${MENTION_ROLES:-}" 500)

# Validate and sanitize URLs
if ! validate_url "$CUSTOM_AVATAR_URL" "$ALLOWED_URL_DOMAINS"; then
    echo "Warning: Invalid avatar URL, using default"
    CUSTOM_AVATAR_URL="https://raw.githubusercontent.com/Devlander-Software/discord-webhook-notifier-action/production/assets/images/github-logo.png"
fi

# Sanitize repository and branch names to prevent injection
REPO=$(sanitize_input "${REPO:-}" 200)
BRANCH=$(sanitize_input "${BRANCH:-}" 100)
COMMIT=$(sanitize_input "${COMMIT:-}" 50)
ACTOR=$(sanitize_input "${ACTOR:-}" 100)
WORKFLOW=$(sanitize_input "${WORKFLOW:-}" 100)
JOB=$(sanitize_input "${JOB:-}" 100)
RUN_URL=$(sanitize_input "${RUN_URL:-}" 500)

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
            # Use GitHub API to get commit message safely
            COMMIT_MSG=""
            if [ -n "$COMMIT" ] && [ -n "$REPO" ]; then
                # Extract owner and repo from REPO variable
                REPO_OWNER=$(echo "$REPO" | cut -d'/' -f1)
                REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)
                
                # Use GitHub API to get commit message (safer than git command)
                COMMIT_MSG=$(curl -s -H "Accept: application/vnd.github.v3+json" \
                    "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/commits/$COMMIT" \
                    2>/dev/null | jq -r '.commit.message // empty' 2>/dev/null || echo "")
                
                # Sanitize commit message
                COMMIT_MSG=$(sanitize_input "$COMMIT_MSG" 200)
            fi
            
            if [ -n "$COMMIT_MSG" ]; then
                DESCRIPTION="$DESCRIPTION
**Commit Message:** \`$COMMIT_MSG\`"
            fi
        fi
        
        # Add environment info if enabled
        if [ "$INCLUDE_ENVIRONMENT" = "true" ]; then
            # Use safe methods to get system info
            OS_INFO="Linux"  # GitHub Actions runs on Linux
            NODE_VERSION=""
            
            # Try to get Node version safely
            if command -v node >/dev/null 2>&1; then
                NODE_VERSION=$(node --version 2>/dev/null | head -1 || echo "N/A")
                NODE_VERSION=$(sanitize_input "$NODE_VERSION" 20)
            else
                NODE_VERSION="N/A"
            fi
            
            DESCRIPTION="$DESCRIPTION
**Environment:** \`$OS_INFO\` • Node: \`$NODE_VERSION\`"
        fi
        
        # Add changed files if enabled
        if [ "$INCLUDE_CHANGED_FILES" = "true" ]; then
            # Use GitHub API to get changed files safely
            CHANGED_FILES=""
            if [ -n "$COMMIT" ] && [ -n "$REPO" ]; then
                REPO_OWNER=$(echo "$REPO" | cut -d'/' -f1)
                REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)
                
                # Get changed files from GitHub API
                CHANGED_FILES=$(curl -s -H "Accept: application/vnd.github.v3+json" \
                    "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/commits/$COMMIT" \
                    2>/dev/null | jq -r '.files[].filename' 2>/dev/null | head -5 | tr '\n' ', ' | sed 's/,$//' || echo "")
                
                # Sanitize changed files
                CHANGED_FILES=$(sanitize_input "$CHANGED_FILES" 500)
            fi
            
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
    # Validate that EMBEDS is valid JSON
    if echo "$EMBEDS" | jq empty 2>/dev/null; then
        PAYLOAD=$(jq -n \
          --arg content "$(sanitize_json_string "$CONTENT")" \
          --argjson embeds "$EMBEDS" \
          --arg username "$(sanitize_json_string "$CUSTOM_USERNAME")" \
          --arg avatar_url "$(sanitize_json_string "$CUSTOM_AVATAR_URL")" \
          --arg tts "$TTS" \
          --arg thread_id "$(sanitize_json_string "$THREAD_ID")" \
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
        echo "Error: Invalid JSON in EMBEDS parameter"
        exit 1
    fi
else
    # Create rich embed with advanced features
    if [ "$USE_RICH_EMBEDS" = "true" ]; then
        # Create fields for rich embed with sanitized inputs
        FIELDS=$(jq -n \
          --arg repo "$(sanitize_json_string "$REPO")" \
          --arg branch "$(sanitize_json_string "$BRANCH")" \
          --arg commit "$(sanitize_json_string "${COMMIT:0:7}")" \
          --arg actor "$(sanitize_json_string "$ACTOR")" \
          --arg workflow "$(sanitize_json_string "$WORKFLOW")" \
          --arg job "$(sanitize_json_string "$JOB")" \
          '[
            {
              name: "Repository",
              value: "[\($repo)](https://github.com/\($repo))",
              inline: true
            },
            {
              name: "Branch",
              value: "`\($branch)`",
              inline: true
            },
            {
              name: "Commit",
              value: "[`\($commit)`](https://github.com/\($repo)/commit/\($commit))",
              inline: true
            },
            {
              name: "Triggered by",
              value: "`\($actor)`",
              inline: true
            },
            {
              name: "Workflow",
              value: "`\($workflow)`",
              inline: true
            },
            {
              name: "Job",
              value: "`\($job)`",
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
          --arg username "$(sanitize_json_string "$CUSTOM_USERNAME")" \
          --arg avatar_url "$(sanitize_json_string "$CUSTOM_AVATAR_URL")" \
          --arg title "$(sanitize_json_string "$TITLE")" \
          --arg description "$(sanitize_json_string "$DESCRIPTION")" \
          --arg color "$STATUS_COLOR" \
          --arg footer "GitHub Actions • $(date -u +"%Y-%m-%d %H:%M UTC")" \
          --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")" \
          --arg content "$(sanitize_json_string "$CONTENT")" \
          --arg tts "$TTS" \
          --arg thread_id "$(sanitize_json_string "$THREAD_ID")" \
          --arg flags "$FLAGS" \
          --argjson fields "$FIELDS" \
          --arg thumbnail_url "$(sanitize_json_string "$THUMBNAIL_URL")" \
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
        FOOTER_TEXT="Workflow: $(sanitize_json_string "$WORKFLOW") • Job: $(sanitize_json_string "$JOB")"
        PAYLOAD=$(jq -n \
          --arg username "$(sanitize_json_string "$CUSTOM_USERNAME")" \
          --arg avatar_url "$(sanitize_json_string "$CUSTOM_AVATAR_URL")" \
          --arg title "$(sanitize_json_string "$TITLE")" \
          --arg description "$(sanitize_json_string "$DESCRIPTION")" \
          --arg color "$STATUS_COLOR" \
          --arg footer "$FOOTER_TEXT" \
          --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")" \
          --arg content "$(sanitize_json_string "$CONTENT")" \
          --arg tts "$TTS" \
          --arg thread_id "$(sanitize_json_string "$THREAD_ID")" \
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
        
        # Sanitize error response to prevent information disclosure
        if [ -n "$RESPONSE_BODY" ]; then
            # Only show safe error information
            SANITIZED_RESPONSE=$(echo "$RESPONSE_BODY" | head -c 200 | sed "s/[^a-zA-Z0-9 .,!?\-]//g")
            if [ ${#SANITIZED_RESPONSE} -gt 0 ]; then
                echo "Error details: $SANITIZED_RESPONSE"
            fi
        fi
        
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
