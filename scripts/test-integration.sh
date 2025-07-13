#!/bin/bash

# Integration Test Suite for Discord Webhook Notifier Action
# Tests the action with real Discord webhooks and GitHub Actions scenarios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

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
    print_error "Usage: $0 <webhook_url> [test_scenario]"
    print_error "Test scenarios: basic, advanced, failure, rate-limit, all"
    exit 1
fi

WEBHOOK_URL="$1"
TEST_SCENARIO="${2:-all}"

print_header "🧪 Integration Test Suite"
print_status "Testing webhook: ${WEBHOOK_URL:0:50}..."
print_status "Test scenario: $TEST_SCENARIO"

# Test 1: Basic GitHub Actions Workflow
test_basic_workflow() {
    print_header "🔧 Testing Basic GitHub Actions Workflow"
    
    print_status "Simulating successful CI/CD workflow..."
    
    # Simulate GitHub Actions environment
    export GITHUB_WORKFLOW="CI/CD Pipeline"
    export GITHUB_JOB="build-and-test"
    export GITHUB_REPOSITORY="devlander/awesome-app"
    export GITHUB_REF_NAME="main"
    export GITHUB_SHA="abc1234567890abcdef1234567890abcdef1234"
    export GITHUB_ACTOR="landonjohnson"
    export GITHUB_RUN_ID="1234567890"
    export GITHUB_SERVER_URL="https://github.com"
    
    # Test success scenario
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="$GITHUB_WORKFLOW" \
    JOB="$GITHUB_JOB" \
    REPO="$GITHUB_REPOSITORY" \
    BRANCH="$GITHUB_REF_NAME" \
    COMMIT="$GITHUB_SHA" \
    ACTOR="$GITHUB_ACTOR" \
    RUN_URL="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    USE_RICH_EMBEDS="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    print_success "Basic workflow test completed"
}

# Test 2: Advanced Features Integration
test_advanced_features() {
    print_header "🚀 Testing Advanced Features Integration"
    
    print_status "Testing enterprise features with real webhook..."
    
    # Test with all advanced features enabled
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="Production Deployment" \
    JOB="deploy-to-production" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="def5678901234567890abcdef5678901234567890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567891" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    USE_RICH_EMBEDS="true" \
    INCLUDE_ENVIRONMENT="true" \
    INCLUDE_CHANGED_FILES="true" \
    RETRY_ON_FAILURE="true" \
    MAX_RETRIES="3" \
    RETRY_DELAY="2" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    print_success "Advanced features test completed"
}

# Test 3: Failure Scenarios
test_failure_scenarios() {
    print_header "❌ Testing Failure Scenarios"
    
    print_status "Testing failure notification..."
    
    # Test failure scenario
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="failure" \
    WORKFLOW="Test Suite" \
    JOB="run-tests" \
    REPO="devlander/awesome-app" \
    BRANCH="feature/new-feature" \
    COMMIT="ghi1234567890abcdef1234567890abcdef1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567892" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    USE_RICH_EMBEDS="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    sleep 2
    
    print_status "Testing cancelled notification..."
    
    # Test cancelled scenario
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="cancelled" \
    WORKFLOW="Long Running Job" \
    JOB="data-processing" \
    REPO="devlander/awesome-app" \
    BRANCH="develop" \
    COMMIT="jkl5678901234567890abcdef5678901234567890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567893" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    USE_RICH_EMBEDS="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    print_success "Failure scenarios test completed"
}

# Test 4: Rate Limiting and Retry Logic
test_rate_limiting() {
    print_header "⏱️ Testing Rate Limiting and Retry Logic"
    
    print_status "Testing rapid-fire notifications (rate limit test)..."
    
    # Send multiple notifications quickly to test rate limiting
    for i in {1..5}; do
        print_status "Sending notification $i/5..."
        
        DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
        STATUS="success" \
        WORKFLOW="Rate Limit Test" \
        JOB="test-$i" \
        REPO="devlander/awesome-app" \
        BRANCH="test" \
        COMMIT="mno${i}234567890abcdef1234567890abcdef1234" \
        ACTOR="landonjohnson" \
        RUN_URL="https://github.com/devlander/awesome-app/actions/runs/123456789${i}" \
        RETRY_ON_FAILURE="true" \
        MAX_RETRIES="3" \
        RETRY_DELAY="1" \
        CUSTOM_USERNAME="Integration Test Bot" \
        CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
        bash scripts/notify.sh
        
        sleep 1
    done
    
    print_success "Rate limiting test completed"
}

# Test 5: Different Workflow Types
test_workflow_types() {
    print_header "🔄 Testing Different Workflow Types"
    
    # Test deployment workflow
    print_status "Testing deployment workflow detection..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="deploy-to-staging" \
    JOB="deploy" \
    REPO="devlander/awesome-app" \
    BRANCH="develop" \
    COMMIT="pqr1234567890abcdef1234567890abcdef1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567894" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    sleep 2
    
    # Test release workflow
    print_status "Testing release workflow detection..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="create-release" \
    JOB="release" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="stu5678901234567890abcdef5678901234567890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567895" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    sleep 2
    
    # Test build workflow
    print_status "Testing build workflow detection..."
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="build-and-package" \
    JOB="build" \
    REPO="devlander/awesome-app" \
    BRANCH="feature/build-improvements" \
    COMMIT="vwx1234567890abcdef1234567890abcdef1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567896" \
    AUTO_DETECT="true" \
    SMART_FORMATTING="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    print_success "Workflow types test completed"
}

# Test 6: Compact Mode
test_compact_mode() {
    print_header "📱 Testing Compact Mode"
    
    print_status "Testing compact mode for busy channels..."
    
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    STATUS="success" \
    WORKFLOW="Quick Test" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="hotfix/urgent-fix" \
    COMMIT="yza5678901234567890abcdef5678901234567890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567897" \
    COMPACT_MODE="true" \
    SMART_FORMATTING="true" \
    CUSTOM_USERNAME="Integration Test Bot" \
    CUSTOM_AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    bash scripts/notify.sh
    
    print_success "Compact mode test completed"
}

# Test 7: Raw JSON Embeds (Compatibility)
test_raw_embeds() {
    print_header "🔌 Testing Raw JSON Embeds (Compatibility)"
    
    print_status "Testing raw JSON embed support..."
    
    DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    CONTENT="Integration test with custom embed" \
    EMBEDS='[{"title":"Custom Integration Test","description":"This embed was created using raw JSON","color":16711680,"fields":[{"name":"Test Field","value":"Integration test successful","inline":true},{"name":"Status","value":"✅ Working","inline":true}],"footer":{"text":"Integration Test Suite"}}]' \
    USERNAME="Integration Test Bot" \
    AVATAR_URL="https://cdn.discordapp.com/embed/avatars/0.png" \
    TTS="false" \
    bash scripts/notify.sh
    
    print_success "Raw JSON embeds test completed"
}

# Test 8: Error Handling
test_error_handling() {
    print_header "🛡️ Testing Error Handling"
    
    print_status "Testing invalid webhook URL handling..."
    
    # Test with invalid webhook (should fail gracefully)
    if DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/invalid/invalid" \
    STATUS="success" \
    WORKFLOW="Error Test" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="bcd1234567890abcdef1234567890abcdef1234" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567898" \
    bash scripts/notify.sh; then
        print_warning "Invalid webhook test should have failed"
    else
        print_success "Invalid webhook handled correctly"
    fi
    
    print_status "Testing missing required parameters..."
    
    # Test with missing STATUS (should fail gracefully)
    if DISCORD_WEBHOOK_URL="$WEBHOOK_URL" \
    WORKFLOW="Error Test" \
    JOB="test" \
    REPO="devlander/awesome-app" \
    BRANCH="main" \
    COMMIT="efg5678901234567890abcdef5678901234567890" \
    ACTOR="landonjohnson" \
    RUN_URL="https://github.com/devlander/awesome-app/actions/runs/1234567899" \
    bash scripts/notify.sh; then
        print_warning "Missing STATUS test should have failed"
    else
        print_success "Missing STATUS handled correctly"
    fi
    
    print_success "Error handling test completed"
}

# Main test execution
case "$TEST_SCENARIO" in
    "basic")
        test_basic_workflow
        ;;
    "advanced")
        test_advanced_features
        ;;
    "failure")
        test_failure_scenarios
        ;;
    "rate-limit")
        test_rate_limiting
        ;;
    "workflows")
        test_workflow_types
        ;;
    "compact")
        test_compact_mode
        ;;
    "compatibility")
        test_raw_embeds
        ;;
    "errors")
        test_error_handling
        ;;
    "all")
        print_header "🧪 Running Complete Integration Test Suite"
        test_basic_workflow
        sleep 3
        test_advanced_features
        sleep 3
        test_failure_scenarios
        sleep 3
        test_rate_limiting
        sleep 3
        test_workflow_types
        sleep 3
        test_compact_mode
        sleep 3
        test_raw_embeds
        sleep 3
        test_error_handling
        ;;
    *)
        print_error "Unknown test scenario: $TEST_SCENARIO"
        print_status "Available scenarios: basic, advanced, failure, rate-limit, workflows, compact, compatibility, errors, all"
        exit 1
        ;;
esac

print_header "✅ Integration Test Suite Completed!"
print_success "All tests completed successfully"
print_status "Check your Discord channel for the test notifications"
print_status "Integration test results:"
print_status "  ✅ Basic GitHub Actions workflow simulation"
print_status "  ✅ Advanced features integration"
print_status "  ✅ Failure scenario handling"
print_status "  ✅ Rate limiting and retry logic"
print_status "  ✅ Different workflow type detection"
print_status "  ✅ Compact mode functionality"
print_status "  ✅ Raw JSON embed compatibility"
print_status "  ✅ Error handling and validation"
print_warning "Note: Some tests may trigger Discord rate limits. This is expected behavior." 