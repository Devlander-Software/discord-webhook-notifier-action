# 🧪 Testing Guide

> **Comprehensive testing strategy for the Discord Notify Action before publishing**

## 📋 Testing Checklist

### ✅ **Pre-Publishing Tests**

- [ ] **Local Testing** - Test with real Discord webhook
- [ ] **Integration Testing** - Test in GitHub Actions environment
- [ ] **Cross-Platform Testing** - Test on Linux, macOS, Windows
- [ ] **Error Handling** - Test invalid inputs and edge cases
- [ ] **Rate Limiting** - Test Discord API rate limits
- [ ] **Performance Testing** - Test rapid-fire notifications
- [ ] **Compatibility Testing** - Test with existing Discord actions
- [ ] **Documentation Testing** - Verify all examples work

---

## 🏠 Local Testing

### 1. **Basic Functionality Test**

```bash
# Test basic notification
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" basic
```

**What to verify:**
- ✅ Notification appears in Discord
- ✅ Correct status color (green for success)
- ✅ Proper formatting and links
- ✅ All required fields are present

### 2. **Advanced Features Test**

```bash
# Test all advanced features
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" advanced
```

**What to verify:**
- ✅ Smart auto-detection works (workflow type, branch importance)
- ✅ Rich embeds with fields and thumbnails
- ✅ Environment information included
- ✅ Changed files information included
- ✅ Retry logic works correctly

### 3. **Failure Scenarios Test**

```bash
# Test failure and cancelled notifications
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" failure
```

**What to verify:**
- ✅ Failure notifications have red color
- ✅ Cancelled notifications have gray color
- ✅ Error messages are clear and helpful
- ✅ Links to failed workflow runs work

### 4. **Rate Limiting Test**

```bash
# Test rapid-fire notifications
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" rate-limit
```

**What to verify:**
- ✅ Retry logic handles rate limits gracefully
- ✅ Notifications are sent successfully after delays
- ✅ No data loss during rate limiting
- ✅ Proper error messages for rate limits

### 5. **Compatibility Test**

```bash
# Test raw JSON embed compatibility
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" compatibility
```

**What to verify:**
- ✅ Raw JSON embeds work correctly
- ✅ Custom usernames and avatars work
- ✅ Text-to-speech functionality works
- ✅ Drop-in compatibility with other actions

---

## 🔄 GitHub Actions Integration Testing

### 1. **Setup Test Repository**

Create a test repository with this workflow:

```yaml
name: Test Discord Notify Action

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Test Success
      uses: ./
      if: always()
      with:
        webhook: ${{ secrets.DISCORD_WEBHOOK_URL }}
        status: success
        workflow: ${{ github.workflow }}
        job: ${{ github.job }}
        repo: ${{ github.repository }}
        branch: ${{ github.ref_name }}
        commit: ${{ github.sha }}
        actor: ${{ github.actor }}
        run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
        auto_detect: true
        smart_formatting: true
        use_rich_embeds: true
        
    - name: Test Failure
      uses: ./
      if: failure()
      with:
        webhook: ${{ secrets.DISCORD_WEBHOOK_URL }}
        status: failure
        workflow: ${{ github.workflow }}
        job: ${{ github.job }}
        repo: ${{ github.repository }}
        branch: ${{ github.ref_name }}
        commit: ${{ github.sha }}
        actor: ${{ github.actor }}
        run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
        auto_detect: true
        smart_formatting: true
        use_rich_embeds: true
```

### 2. **Test Different Scenarios**

- **Push to main** - Should trigger success notification
- **Create PR** - Should trigger success notification
- **Force failure** - Add failing step to test failure notification
- **Cancel workflow** - Test cancelled notification

### 3. **Verify GitHub Actions Environment**

Check that all GitHub context variables are available:
- `github.workflow`
- `github.job`
- `github.repository`
- `github.ref_name`
- `github.sha`
- `github.actor`
- `github.run_id`
- `github.server_url`

---

## 🖥️ Cross-Platform Testing

### 1. **Linux Testing**

```bash
# Test on Ubuntu
docker run --rm -v $(pwd):/workspace -w /workspace ubuntu:latest bash -c "
  apt-get update && apt-get install -y curl jq
  ./scripts/test-integration.sh 'YOUR_WEBHOOK_URL' basic
"
```

### 2. **macOS Testing**

```bash
# Test on macOS (if available)
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" basic
```

### 3. **Windows Testing**

```bash
# Test on Windows (using WSL or GitHub Actions)
# The action should work on Windows runners
```

---

## 🛡️ Error Handling Testing

### 1. **Invalid Inputs**

```bash
# Test missing webhook URL
DISCORD_WEBHOOK_URL="" bash scripts/notify.sh

# Test missing status
DISCORD_WEBHOOK_URL="YOUR_WEBHOOK_URL" bash scripts/notify.sh

# Test invalid webhook URL
DISCORD_WEBHOOK_URL="https://invalid-url.com" bash scripts/notify.sh
```

**Expected behavior:**
- ✅ Graceful error messages
- ✅ No secrets leaked in logs
- ✅ Proper exit codes
- ✅ Clear instructions for fixing

### 2. **Missing Dependencies**

```bash
# Test without jq
PATH="/usr/bin:/bin" bash scripts/notify.sh

# Test without curl
PATH="/usr/bin" bash scripts/notify.sh
```

**Expected behavior:**
- ✅ Clear error message about missing dependencies
- ✅ Instructions for installing dependencies
- ✅ Proper exit codes

### 3. **Network Issues**

```bash
# Test with network timeout
timeout 1s bash scripts/notify.sh
```

**Expected behavior:**
- ✅ Retry logic kicks in
- ✅ Proper timeout handling
- ✅ Clear error messages

---

## ⚡ Performance Testing

### 1. **Speed Test**

```bash
# Measure execution time
time ./scripts/test-integration.sh "YOUR_WEBHOOK_URL" basic
```

**Target:**
- ✅ Under 2 seconds for basic notification
- ✅ Under 5 seconds for advanced features
- ✅ Under 10 seconds with retry logic

### 2. **Memory Usage**

```bash
# Monitor memory usage
/usr/bin/time -v ./scripts/test-integration.sh "YOUR_WEBHOOK_URL" basic
```

**Target:**
- ✅ Under 50MB memory usage
- ✅ No memory leaks
- ✅ Efficient resource usage

### 3. **Rate Limiting Performance**

```bash
# Test rapid notifications
for i in {1..10}; do
  ./scripts/test-integration.sh "YOUR_WEBHOOK_URL" basic &
done
wait
```

**Expected behavior:**
- ✅ Handles rate limits gracefully
- ✅ Retries with exponential backoff
- ✅ No data loss
- ✅ Proper error handling

---

## 🔌 Compatibility Testing

### 1. **Drop-in Replacement Test**

Test replacing existing Discord actions:

```yaml
# Before (other action)
- uses: some-other/discord-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    content: "Build completed"

# After (our action - should work with same config)
- uses: devlander/discord-notify-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    content: "Build completed"
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
    repo: ${{ github.repository }}
    branch: ${{ github.ref_name }}
    commit: ${{ github.sha }}
    actor: ${{ github.actor }}
    run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
```

### 2. **Raw JSON Embed Test**

```bash
# Test raw JSON embeds
DISCORD_WEBHOOK_URL="YOUR_WEBHOOK_URL" \
CONTENT="Test message" \
EMBEDS='[{"title":"Test","description":"Raw JSON embed","color":16711680}]' \
bash scripts/notify.sh
```

---

## 📚 Documentation Testing

### 1. **README Examples**

Test all examples in README.md:

```bash
# Test basic usage example
# Test advanced usage example
# Test migration examples
# Test organization setup examples
```

### 2. **Action.yml Validation**

```bash
# Validate action.yml syntax
yamllint action.yml

# Check for required fields
grep -q "required: true" action.yml
```

### 3. **Marketplace Metadata**

Verify marketplace metadata:
- ✅ Action name is clear and descriptive
- ✅ Description includes key features
- ✅ Keywords are relevant
- ✅ Branding is professional

---

## 🚀 Pre-Publishing Checklist

### ✅ **Code Quality**
- [ ] All tests pass
- [ ] No linting errors
- [ ] Proper error handling
- [ ] Security best practices followed

### ✅ **Functionality**
- [ ] Basic notifications work
- [ ] Advanced features work
- [ ] Error handling works
- [ ] Rate limiting works
- [ ] Cross-platform compatibility

### ✅ **Documentation**
- [ ] README is complete and accurate
- [ ] Examples work correctly
- [ ] Migration guides are clear
- [ ] Troubleshooting section exists

### ✅ **Performance**
- [ ] Fast execution time
- [ ] Low memory usage
- [ ] Efficient retry logic
- [ ] No resource leaks

### ✅ **Security**
- [ ] No secrets logged
- [ ] Input validation
- [ ] Secure defaults
- [ ] No vulnerabilities

### ✅ **Compatibility**
- [ ] Drop-in replacement works
- [ ] Raw JSON embeds work
- [ ] All major platforms supported
- [ ] Backward compatibility maintained

---

## 🎯 Running the Complete Test Suite

```bash
# Run all tests
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" all

# Run specific test categories
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" basic
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" advanced
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" failure
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" rate-limit
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" compatibility
./scripts/test-integration.sh "YOUR_WEBHOOK_URL" errors
```

---

## 📊 Test Results Template

After running tests, document results:

```markdown
## Test Results - [Date]

### ✅ Passed Tests
- Basic functionality: ✅
- Advanced features: ✅
- Error handling: ✅
- Rate limiting: ✅
- Cross-platform: ✅
- Performance: ✅

### ⚠️ Issues Found
- [List any issues found]

### 🔧 Fixes Applied
- [List fixes made]

### 📈 Performance Metrics
- Average execution time: X seconds
- Memory usage: X MB
- Success rate: X%

### 🚀 Ready for Publishing
- [ ] All tests pass
- [ ] No critical issues
- [ ] Documentation complete
- [ ] Performance acceptable
```

---

**Remember:** Thorough testing is crucial for a successful GitHub Action. Test early, test often, and test everything! 🧪 