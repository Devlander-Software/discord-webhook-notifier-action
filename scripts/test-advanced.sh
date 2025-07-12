#!/bin/bash

# Advanced Discord Notify Action Test Script
# Tests all the new features: smart formatting, retry logic, threads, mentions, etc.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

# Check if webhook URL is provided
if [ $# -lt 1 ]; then
    print_error "Usage: $0 <webhook_url> [test_type]"
    print_error "Test types: smart, rich, enterprise, compact, all"
    exit 1
fi

WEBHOOK_URL="$1"
TEST_TYPE="${2:-all}"

print_header "🚀 Advanced Discord Notify Action Test Suite"
print_status "Testing webhook: ${WEBHOOK_URL:0:50}..."
print_status "Test type: $TEST_TYPE"

# Test 1: Smart Auto-Detection Features
test_smart_detection() {
    print_header "🧠 Testing Smart Auto-Detection"
    
    # Test deployment detection
    print_status "Testing deployment workflow detection..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="deploy-to-production" \
    JOB="deploy" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="abc1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/123" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    USE_RICH_EMBEDS="true" \
    bash scripts/notify.sh
    
    print_success "Deployment detection test completed"
    
    # Test test workflow detection
    print_status "Testing test workflow detection..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="run-tests" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="feature/new-feature" \
    COMMIT="def5678" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/124" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    USE_RICH_EMBEDS="true" \
    bash scripts/notify.sh
    
    print_success "Test workflow detection completed"
}

# Test 2: Rich Embed Features
test_rich_embeds() {
    print_header "🎨 Testing Rich Embed Features"
    
    print_status "Testing rich embeds with fields and thumbnails..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="build-and-deploy" \
    JOB="build" \
    REPO="devlander/awesome-app" \
    BRANCH="develop" \
    COMMIT="ghi9012" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/125" \
    USE_RICH_EMBEDS="true" \
    INCLUDE_ENVIRONMENT="true" \
    INCLUDE_CHANGED_FILES="true" \
    bash scripts/notify.sh
    
    print_success "Rich embeds test completed"
}

# Test 3: Enterprise Features
test_enterprise_features() {
    print_header "🏢 Testing Enterprise Features"
    
    print_status "Testing retry logic and thread support..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="failure" \
    WORKFLOW="production-deploy" \
    JOB="deploy" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="jkl3456" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/126" \
    RETRY_ON_FAILURE="true" \
    MAX_RETRIES="2" \
    RETRY_DELAY="3" \
    THREAD_ID="1234567890123456789" \
    MENTION_USERS="123456789012345678" \
    MENTION_ROLES="1234567890123456789" \
    bash scripts/notify.sh
    
    print_success "Enterprise features test completed"
}

# Test 4: Compact Mode
test_compact_mode() {
    print_header "📱 Testing Compact Mode"
    
    print_status "Testing compact mode for busy channels..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="quick-test" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="feature/quick-fix" \
    COMMIT="mno7890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/127" \
    COMPACT_MODE="true" \
    SMART_FORMATTING="true" \
    bash scripts/notify.sh
    
    print_success "Compact mode test completed"
}

# Test 5: Raw JSON Embeds (Compatibility)
test_raw_embeds() {
    print_header "🔌 Testing Raw JSON Embeds (Compatibility)"
    
    print_status "Testing raw JSON embed support..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    CONTENT="Custom message with raw embeds" \
    EMBEDS='[{"title":"Custom Embed","description":"This is a custom embed","color":16711680,"fields":[{"name":"Field 1","value":"Value 1","inline":true},{"name":"Field 2","value":"Value 2","inline":true}]}]' \
    USERNAME="Custom Bot" \
    AVATAR_URL="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" \
    TTS="false" \
    bash scripts/notify.sh
    
    print_success "Raw JSON embeds test completed"
}

# Test 6: Different Status Types
test_status_types() {
    print_header "🎯 Testing Different Status Types"
    
    # Test success
    print_status "Testing success status..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="test-success" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="pqr1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/128" \
    bash scripts/notify.sh
    
    sleep 2
    
    # Test failure
    print_status "Testing failure status..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="failure" \
    WORKFLOW="test-failure" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="stu5678" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/129" \
    bash scripts/notify.sh
    
    sleep 2
    
    # Test cancelled
    print_status "Testing cancelled status..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="cancelled" \
    WORKFLOW="test-cancelled" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="vwx9012" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/130" \
    bash scripts/notify.sh
    
    print_success "Status types test completed"
}

# Test 7: Branch Importance Detection
test_branch_importance() {
    print_header "🌿 Testing Branch Importance Detection"
    
    # Test production branch
    print_status "Testing production branch (main)..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="deploy" \
    JOB="deploy" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="yza3456" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/131" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    bash scripts/notify.sh
    
    sleep 2
    
    # Test staging branch
    print_status "Testing staging branch (develop)..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="deploy" \
    JOB="deploy" \
    REPO="devlander/awesome-app" \
    BRANCH="develop" \
    COMMIT="bcd7890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/132" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    bash scripts/notify.sh
    
    sleep 2
    
    # Test feature branch
    print_status "Testing feature branch..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="test" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="feature/new-feature" \
    COMMIT="efg1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/133" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    bash scripts/notify.sh
    
    print_success "Branch importance test completed"
}

# Main test execution
case "$TEST_TYPE" in
    "smart")
        test_smart_detection
        ;;
    "rich")
        test_rich_embeds
        ;;
    "enterprise")
        test_enterprise_features
        ;;
    "compact")
        test_compact_mode
        ;;
    "compatibility")
        test_raw_embeds
        ;;
    "status")
        test_status_types
        ;;
    "branch")
        test_branch_importance
        ;;
    "all")
        print_header "🧪 Running All Advanced Tests"
        test_smart_detection
        sleep 3
        test_rich_embeds
        sleep 3
        test_enterprise_features
        sleep 3
        test_compact_mode
        sleep 3
        test_raw_embeds
        sleep 3
        test_status_types
        sleep 3
        test_branch_importance
        ;;
    *)
        print_error "Unknown test type: $TEST_TYPE"
        print_status "Available test types: smart, rich, enterprise, compact, compatibility, status, branch, all"
        exit 1
        ;;
esac

print_header "✅ All Tests Completed Successfully!"
print_success "Check your Discord channel for the test notifications"
print_status "Each test demonstrates different advanced features:"
print_status "  • Smart auto-detection of workflow types"
print_status "  • Rich embeds with fields and thumbnails"
print_status "  • Enterprise features (retry, threads, mentions)"
print_status "  • Compact mode for busy channels"
print_status "  • Raw JSON embed compatibility"
print_status "  • Different status types and colors"
print_status "  • Branch importance detection" 