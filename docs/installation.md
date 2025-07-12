---
layout: default
title: Installation Guide - Discord Notify Action
description: How to install and set up the Discord Notify Action
---

# Installation Guide

## Prerequisites

Before installing the Discord Notify Action, you'll need:

1. **A Discord Server** where you want to receive notifications
2. **A Discord Webhook** URL (we'll help you create this)
3. **A GitHub Repository** with GitHub Actions enabled

## Step 1: Create a Discord Webhook

### Create the Webhook

1. Go to your Discord server
2. Right-click on the channel where you want notifications
3. Select **Edit Channel**
4. Go to **Integrations** tab
5. Click **Create Webhook**
6. Give it a name (e.g., "GitHub Actions")
7. Copy the webhook URL

### Webhook URL Format

Your webhook URL will look like this:
```
https://discord.com/api/webhooks/1234567890123456789/abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz
```

**Keep this URL secure!** Anyone with this URL can send messages to your Discord channel.

## Step 2: Add Webhook to GitHub Secrets

### For Individual Repository

1. Go to your GitHub repository
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Name: `DISCORD_WEBHOOK`
6. Value: Your Discord webhook URL
7. Click **Add secret**

### For Organization (Recommended)

1. Go to your GitHub organization
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New organization secret**
5. Name: `ORG_DISCORD_WEBHOOK_URL`
6. Value: Your Discord webhook URL
7. Click **Add secret**

## Step 3: Add the Action to Your Workflow

### Basic Installation

Add this to your `.github/workflows/your-workflow.yml`:

```yaml
- name: Discord Notification
  uses: devlander/discord-notify-action@v1
  if: always()
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
    repo: ${{ github.repository }}
    branch: ${{ github.ref_name }}
    commit: ${{ github.sha }}
    actor: ${{ github.actor }}
    run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
```

### Complete Workflow Example

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Run tests
      run: npm test
      
    - name: Build application
      run: npm run build
      
    - name: Discord Notification
      uses: devlander/discord-notify-action@v1
      if: always()
      with:
        webhook: ${{ secrets.DISCORD_WEBHOOK }}
        status: ${{ job.status }}
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

## Step 4: Test Your Installation

### Trigger a Test

1. Make a small change to your repository
2. Push the change to trigger your workflow
3. Check your Discord channel for the notification

### Manual Testing

You can also test locally using our test scripts:

```bash
# Clone the repository
git clone https://github.com/devlander/discord-notify-action.git
cd discord-notify-action

# Test basic functionality
./scripts/test-integration.sh "YOUR_DISCORD_WEBHOOK_URL" basic
```

## Step 5: Verify Everything Works

### What to Look For

✅ **Success Notification**: Green embed with workflow details
✅ **Failure Notification**: Red embed with error information  
✅ **Proper Links**: Clickable links to repository and workflow run
✅ **Smart Formatting**: Context-aware emojis and formatting

### Troubleshooting

If notifications aren't appearing:

1. **Check Webhook URL**: Verify it's correct and not expired
2. **Check GitHub Secrets**: Ensure the secret name matches your workflow
3. **Check Discord Permissions**: Make sure the webhook can send messages
4. **Check Workflow Logs**: Look for error messages in GitHub Actions

## Next Steps

Now that you have the basic installation working:

1. [Configure Advanced Features](configuration.html)
2. [Explore Use Cases](examples.html)
3. [Set Up Organization-Wide Notifications](organization.html)
4. [Learn About Testing](testing.html)

## Support

Need help with installation?

- [Troubleshooting Guide](troubleshooting.html)
- [GitHub Issues](https://github.com/devlander/discord-notify-action/issues)
- [Discussions](https://github.com/devlander/discord-notify-action/discussions)

---

**Ready to configure advanced features?** [Continue to Configuration](configuration.html) 