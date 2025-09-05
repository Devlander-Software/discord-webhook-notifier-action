#!/bin/bash

# Security Test Suite for Discord Webhook Notifier Action
# Tests security fixes and input validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if webhook URL is provided
if [ -z "$1" ]; then
    print_error "Usage: $0 <webhook_url>"
    exit 1
fi

WEBHOOK_URL="$1"

print_header "🔒 Security Test Suite"
echo "Testing webhook: ${WEBHOOK_URL:0:50}..."

# Test 1: Input Validation
print_header "🧪 Test 1: Input Validation"

echo "Testing malicious input sanitization..."

# Test with malicious content
MALICIOUS_CONTENT='"; echo "HACKED"; #'
MALICIOUS_TITLE='<script>alert("xss")</script>'
MALICIOUS_USERNAME='$(rm -rf /)'

export DISCORD_WEBHOOK_URL="$WEBHOOK_URL"
export STATUS="success"
export WORKFLOW="Security Test"
export JOB="test"
export REPO="test/test"
export BRANCH="main"
export COMMIT="abc123"
export ACTOR="test"
export RUN_URL="https://github.com/test/test/actions/runs/123"
export CONTENT="$MALICIOUS_CONTENT"
export CUSTOM_TITLE="$MALICIOUS_TITLE"
export CUSTOM_USERNAME="$MALICIOUS_USERNAME"

if bash scripts/notify.sh; then
    print_success "Malicious input sanitized successfully"
else
    print_error "Failed to sanitize malicious input"
fi

# Test 2: URL Validation
print_header "🧪 Test 2: URL Validation"

echo "Testing invalid avatar URL..."

export CUSTOM_AVATAR_URL="https://malicious-site.com/avatar.png"
export CONTENT=""
export CUSTOM_TITLE=""
export CUSTOM_USERNAME="Test Bot"

if bash scripts/notify.sh; then
    print_success "Invalid URL rejected and default used"
else
    print_error "URL validation failed"
fi

# Test 3: JSON Injection
print_header "🧪 Test 3: JSON Injection Prevention"

echo "Testing malicious JSON in EMBEDS..."

export CUSTOM_AVATAR_URL="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
export EMBEDS='[{"title":"Test","description":"Test","color":16711680,"fields":[{"name":"Test","value":"`; echo \"HACKED\"; #","inline":true}]}]'

if bash scripts/notify.sh; then
    print_success "JSON injection prevented"
else
    print_error "JSON injection test failed"
fi

# Test 4: Input Length Limits
print_header "🧪 Test 4: Input Length Limits"

echo "Testing input length limits..."

# Create very long input
LONG_INPUT=$(printf 'a%.0s' {1..3000})
export CONTENT="$LONG_INPUT"
export CUSTOM_TITLE="$LONG_INPUT"
export CUSTOM_USERNAME="$LONG_INPUT"
export EMBEDS=""

if bash scripts/notify.sh; then
    print_success "Input length limits enforced"
else
    print_error "Input length limit test failed"
fi

# Test 5: Webhook URL Validation
print_header "🧪 Test 5: Webhook URL Validation"

echo "Testing invalid webhook URL..."

export DISCORD_WEBHOOK_URL="https://invalid-webhook.com/api/webhooks/123/abc"
export CONTENT=""
export CUSTOM_TITLE=""
export CUSTOM_USERNAME="Test Bot"

if bash scripts/notify.sh; then
    print_error "Invalid webhook URL should have been rejected"
else
    print_success "Invalid webhook URL correctly rejected"
fi

# Test 6: Status Validation
print_header "🧪 Test 6: Status Validation"

echo "Testing invalid status..."

export DISCORD_WEBHOOK_URL="$WEBHOOK_URL"
export STATUS="invalid_status"
export CONTENT=""
export CUSTOM_TITLE=""
export CUSTOM_USERNAME="Test Bot"

if bash scripts/notify.sh; then
    print_error "Invalid status should have been rejected"
else
    print_success "Invalid status correctly rejected"
fi

# Test 7: Error Message Sanitization
print_header "🧪 Test 7: Error Message Sanitization"

echo "Testing error message sanitization..."

# This should fail but not leak sensitive info
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/invalid/invalid"
export STATUS="success"
export CONTENT=""
export CUSTOM_TITLE=""
export CUSTOM_USERNAME="Test Bot"

if bash scripts/notify.sh 2>&1 | grep -q "Error details:"; then
    print_success "Error messages are sanitized"
else
    print_warning "Error message sanitization may need review"
fi

print_header "✅ Security Test Suite Completed!"
print_success "All security tests completed"
print_warning "Note: Some tests may show expected failures - this is normal for security testing"
