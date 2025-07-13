#!/bin/bash

# Test script for customization options
set -e

if [ -z "$1" ]; then
    echo "Usage: ./test-custom.sh <webhook_url>"
    echo "Example: ./test-custom.sh https://discord.com/api/webhooks/..."
    exit 1
fi

WEBHOOK_URL="$1"

echo "🧪 Testing Discord Webhook Notifier Action Customization Options"
echo "====================================================="

# Test 1: Custom title and description
echo "Test 1: Custom title and description..."
export DISCORD_WEBHOOK_URL="$WEBHOOK_URL"
export STATUS="success"
export WORKFLOW="Custom Test"
export JOB="Custom Job"
export REPO="Devlander-Software/discord-webhook-notifier-action"
export BRANCH="production"
export COMMIT="abc1234567890abcdef1234567890abcdef1234"
export ACTOR="landon"
export RUN_URL="https://github.com/Devlander-Software/discord-webhook-notifier-action/actions/runs/123456789"
export CUSTOM_TITLE="🚀 Custom Test Notification"
export CUSTOM_DESCRIPTION="This is a **custom test** with **markdown** formatting!\n\nTesting the Discord Webhook Notifier Action customization features."
export CUSTOM_USERNAME="Test Bot"
export CUSTOM_AVATAR_URL="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
export INCLUDE_COMMIT_MESSAGE="true"
export INCLUDE_DURATION="true"
export COLOR_SUCCESS="00ff00"
export COLOR_FAILURE="ff0000"
export COLOR_CANCELLED="808080"

if bash notify.sh; then
    echo "✅ Custom title/description test passed!"
else
    echo "❌ Custom title/description test failed!"
    exit 1
fi

echo ""
echo "Test 2: Custom colors..."
export STATUS="failure"
export CUSTOM_TITLE=""
export CUSTOM_DESCRIPTION=""

if bash notify.sh; then
    echo "✅ Custom colors test passed!"
else
    echo "❌ Custom colors test failed!"
    exit 1
fi

echo ""
echo "Test 3: Minimal notification..."
export STATUS="success"
export INCLUDE_COMMIT_MESSAGE="false"
export INCLUDE_DURATION="false"
export CUSTOM_TITLE="Minimal Test"

if bash notify.sh; then
    echo "✅ Minimal notification test passed!"
else
    echo "❌ Minimal notification test failed!"
    exit 1
fi

echo ""
echo "🎉 All customization tests completed successfully!"
echo "Check your Discord channel for the test notifications." 