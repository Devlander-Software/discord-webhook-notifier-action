#!/bin/bash

# Exit on any error
set -e

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

# Set default values for customization options
CUSTOM_TITLE=${CUSTOM_TITLE:-""}
CUSTOM_DESCRIPTION=${CUSTOM_DESCRIPTION:-""}
CUSTOM_USERNAME=${CUSTOM_USERNAME:-"GitHub Actions"}
CUSTOM_AVATAR_URL=${CUSTOM_AVATAR_URL:-"https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"}
INCLUDE_COMMIT_MESSAGE=${INCLUDE_COMMIT_MESSAGE:-"true"}
INCLUDE_DURATION=${INCLUDE_DURATION:-"true"}

# Convert hex colors to decimal if needed
convert_hex_to_decimal() {
    local hex=$1
    if [[ $hex =~ ^[0-9a-fA-F]{6}$ ]]; then
        # Convert hex to decimal
        printf "%d" "0x$hex"
    else
        # Already decimal, return as is
        echo "$hex"
    fi
}

COLOR_SUCCESS=$(convert_hex_to_decimal "${COLOR_SUCCESS:-"3066993"}")
COLOR_FAILURE=$(convert_hex_to_decimal "${COLOR_FAILURE:-"15158332"}")
COLOR_CANCELLED=$(convert_hex_to_decimal "${COLOR_CANCELLED:-"9807270"}")

STATUS_COLOR=""
STATUS_ICON=""

case "$STATUS" in
  success)
    STATUS_COLOR="$COLOR_SUCCESS"
    STATUS_ICON="✅"
    ;;
  failure)
    STATUS_COLOR="$COLOR_FAILURE"
    STATUS_ICON="❌"
    ;;
  cancelled)
    STATUS_COLOR="$COLOR_CANCELLED"
    STATUS_ICON="⚪️"
    ;;
  *)
    STATUS_COLOR="$COLOR_CANCELLED"
    STATUS_ICON="⚪️"
    ;;
esac

# Build the title
if [ -n "$CUSTOM_TITLE" ]; then
    TITLE="$CUSTOM_TITLE"
else
    TITLE="$STATUS_ICON $STATUS"
fi

# Build the description
if [ -n "$CUSTOM_DESCRIPTION" ]; then
    DESCRIPTION="$CUSTOM_DESCRIPTION"
else
    DESCRIPTION="**Repository:** [$REPO](https://github.com/$REPO)
**Branch:** \`$BRANCH\`
**Commit:** [\`${COMMIT:0:7}\`](https://github.com/$REPO/commit/$COMMIT)
**Triggered by:** \`$ACTOR\`"
    
    # Add commit message if enabled
    if [ "$INCLUDE_COMMIT_MESSAGE" = "true" ]; then
        # Try to get commit message (this might not work in all contexts)
        COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "Commit message not available")
        if [ -n "$COMMIT_MSG" ] && [ "$COMMIT_MSG" != "Commit message not available" ]; then
            DESCRIPTION="$DESCRIPTION
**Commit Message:** \`$COMMIT_MSG\`"
        fi
    fi
    
    # Add duration if enabled (this is a placeholder - actual duration would need to be passed as input)
    if [ "$INCLUDE_DURATION" = "true" ]; then
        DESCRIPTION="$DESCRIPTION
**Duration:** \`Job completed\`"
    fi
    
    DESCRIPTION="$DESCRIPTION

**[View Run]($RUN_URL)**"
fi

# Read compatibility/adapter envs
CONTENT=${CONTENT:-""}
EMBEDS=${EMBEDS:-""}
TTS=${TTS:-"false"}

# If EMBEDS is set, use it as the embeds array (raw JSON)
if [ -n "$EMBEDS" ]; then
    PAYLOAD=$(jq -n \
      --arg content "$CONTENT" \
      --argjson embeds "$EMBEDS" \
      --arg username "$CUSTOM_USERNAME" \
      --arg avatar_url "$CUSTOM_AVATAR_URL" \
      --arg tts "$TTS" \
      '{
        content: $content,
        username: $username,
        avatar_url: $avatar_url,
        tts: ($tts == "true"),
        embeds: $embeds
      }'
    )
    echo "Sending Discord notification (raw embeds mode)"
else
# Create the JSON payload with proper escaping
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
  '{
    content: $content,
    username: $username,
    avatar_url: $avatar_url,
    tts: ($tts == "true"),
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

echo "Using custom title: $([ -n "$CUSTOM_TITLE" ] && echo "Yes" || echo "No")"
echo "Using custom description: $([ -n "$CUSTOM_DESCRIPTION" ] && echo "Yes" || echo "No")"

# Send the notification
RESPONSE=$(curl -s -w "%{http_code}" \
  -H "Content-Type: application/json" \
  -X POST \
  -d "$PAYLOAD" \
  "$DISCORD_WEBHOOK_URL")

HTTP_CODE="${RESPONSE: -3}"
RESPONSE_BODY="${RESPONSE%???}"

if [ "$HTTP_CODE" -eq 204 ]; then
    echo "✅ Discord notification sent successfully"
else
    echo "❌ Failed to send Discord notification. HTTP Code: $HTTP_CODE"
    echo "Response: $RESPONSE_BODY"
    exit 1
fi
