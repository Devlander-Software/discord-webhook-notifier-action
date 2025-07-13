#!/bin/bash

# Test script using environment variables
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Discord Webhook Notifier Action - Environment Test${NC}"
echo "=============================================="

# Your Discord webhook URL
WEBHOOK_URL="https://discord.com/api/webhooks/1393707630081478829/D2Yjxwp_GiGmFedjToW7fWbITZZ11Ir4hmIAQO4Bws_tNbYnZsQWyjgpGVALEDihZAUd"

echo -e "${GREEN}Using webhook: ${WEBHOOK_URL:0:50}...${NC}"
echo ""

# Test 1: Basic success notification
echo -e "${YELLOW}Test 1: Basic Success Notification${NC}"
echo "----------------------------------------"
export DISCORD_WEBHOOK_URL="$WEBHOOK_URL"
export STATUS="success"
export WORKFLOW="Local Test Workflow"
export JOB="Local Test Job"
export REPO="Devlander-Software/discord-webhook-notifier-action"
export BRANCH="production"
export COMMIT="abc1234567890abcdef1234567890abcdef1234"
export ACTOR="landon"
export RUN_URL="https://github.com/Devlander-Software/discord-webhook-notifier-action/actions/runs/123456789"
export CUSTOM_TITLE=""
export CUSTOM_DESCRIPTION=""
export CUSTOM_USERNAME="GitHub Actions"
export CUSTOM_AVATAR_URL="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
export INCLUDE_COMMIT_MESSAGE="true"
export INCLUDE_DURATION="true"
export COLOR_SUCCESS="3066993"
export COLOR_FAILURE="15158332"
export COLOR_CANCELLED="9807270"

if bash notify.sh; then
    echo -e "${GREEN}✅ Success notification test passed!${NC}"
else
    echo -e "${RED}❌ Success notification test failed!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Test 2: Failure Notification${NC}"
echo "--------------------------------"
export STATUS="failure"

if bash notify.sh; then
    echo -e "${GREEN}✅ Failure notification test passed!${NC}"
else
    echo -e "${RED}❌ Failure notification test failed!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Test 3: Custom Title and Description${NC}"
echo "----------------------------------------"
export STATUS="success"
export CUSTOM_TITLE="🚀 Custom Test Notification"
export CUSTOM_DESCRIPTION="This is a **custom test** with **markdown** formatting!\n\nTesting the Discord Webhook Notifier Action customization features."
export CUSTOM_USERNAME="Test Bot"

if bash notify.sh; then
    echo -e "${GREEN}✅ Custom title/description test passed!${NC}"
else
    echo -e "${RED}❌ Custom title/description test failed!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Test 4: Custom Colors${NC}"
echo "------------------------"
export STATUS="failure"
export CUSTOM_TITLE=""
export CUSTOM_DESCRIPTION=""
export COLOR_SUCCESS="00ff00"
export COLOR_FAILURE="ff0000"
export COLOR_CANCELLED="808080"

if bash notify.sh; then
    echo -e "${GREEN}✅ Custom colors test passed!${NC}"
else
    echo -e "${RED}❌ Custom colors test failed!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Test 5: Minimal Notification${NC}"
echo "----------------------------"
export STATUS="success"
export INCLUDE_COMMIT_MESSAGE="false"
export INCLUDE_DURATION="false"
export CUSTOM_TITLE="Minimal Test"
export COLOR_SUCCESS="3066993"
export COLOR_FAILURE="15158332"
export COLOR_CANCELLED="9807270"

if bash notify.sh; then
    echo -e "${GREEN}✅ Minimal notification test passed!${NC}"
else
    echo -e "${RED}❌ Minimal notification test failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 All tests completed successfully!${NC}"
echo -e "${BLUE}Check your Discord channel for the test notifications.${NC}"
echo ""
echo -e "${YELLOW}You should see 5 different notifications:${NC}"
echo "1. ✅ Basic success notification"
echo "2. ❌ Failure notification"
echo "3. 🚀 Custom title/description"
echo "4. ❌ Custom colors (bright red)"
echo "5. ✅ Minimal notification" 