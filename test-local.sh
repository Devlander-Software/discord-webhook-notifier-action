#!/bin/bash

# Local testing script for Discord Notify Action
# This script allows you to test the notification functionality locally

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Discord Notify Action - Local Testing${NC}"
echo "=============================================="

# Check if webhook URL is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide your Discord webhook URL as the first argument${NC}"
    echo "Usage: ./test-local.sh <webhook_url> [status]"
    echo "Example: ./test-local.sh https://discord.com/api/webhooks/... success"
    exit 1
fi

WEBHOOK_URL="$1"
STATUS="${2:-success}"

# Validate status
if [[ ! "$STATUS" =~ ^(success|failure|cancelled)$ ]]; then
    echo -e "${RED}Error: Status must be one of: success, failure, cancelled${NC}"
    exit 1
fi

echo -e "${GREEN}Testing with status: $STATUS${NC}"
echo "Webhook URL: ${WEBHOOK_URL:0:50}..."

# Set up test environment variables
export DISCORD_WEBHOOK_URL="$WEBHOOK_URL"
export STATUS="$STATUS"
export WORKFLOW="Test Workflow"
export JOB="Test Job"
export REPO="test-owner/test-repo"
export BRANCH="main"
export COMMIT="abc1234567890abcdef1234567890abcdef1234"
export ACTOR="test-user"
export RUN_URL="https://github.com/test-owner/test-repo/actions/runs/123456789"

# Test customization options
export CUSTOM_TITLE=""
export CUSTOM_DESCRIPTION=""
export CUSTOM_USERNAME="GitHub Actions"
export CUSTOM_AVATAR_URL="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
export INCLUDE_COMMIT_MESSAGE="true"
export INCLUDE_DURATION="true"
export COLOR_SUCCESS="3066993"
export COLOR_FAILURE="15158332"
export COLOR_CANCELLED="9807270"

echo -e "${YELLOW}Running notification script...${NC}"
echo "----------------------------------------"

# Run the notification script
if bash notify.sh; then
    echo -e "${GREEN}✅ Test completed successfully!${NC}"
    echo "Check your Discord channel for the notification."
else
    echo -e "${RED}❌ Test failed!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Testing Customization Options${NC}"
echo "====================================="

# Test with custom title
echo -e "${YELLOW}Testing with custom title...${NC}"
export CUSTOM_TITLE="🚀 Custom Test Notification"
export CUSTOM_DESCRIPTION="This is a custom description for testing purposes."
export CUSTOM_USERNAME="Test Bot"
export CUSTOM_AVATAR_URL="https://cdn.discordapp.com/emojis/1234567890.png"

if bash notify.sh; then
    echo -e "${GREEN}✅ Custom title test completed!${NC}"
else
    echo -e "${RED}❌ Custom title test failed!${NC}"
fi

echo ""
echo -e "${GREEN}All tests completed!${NC}"
echo "Check your Discord channel for both notifications." 