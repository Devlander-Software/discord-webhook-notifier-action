# Organization-Wide Discord Notifications Setup Guide

This guide shows you how to set up centralized Discord notifications across your entire GitHub organization using the Discord Notify Action, so you don't have to repeat the same configuration in every repository.

## 🏢 Overview

Instead of adding Discord notification configuration to every repository, you can:
- **Centralize your webhook** in organization secrets
- **Create a reusable workflow** that any repository can call
- **Minimize configuration** in individual repositories
- **Maintain consistency** across all your notifications

## 🚀 Quick Start

### Step 1: Set Up Organization Secret

1. Go to your GitHub organization settings
2. Navigate to **Secrets and variables** → **Actions**
3. Click **New organization secret**
4. Name: `ORG_DISCORD_WEBHOOK_URL`
5. Value: Your Discord webhook URL
6. Choose which repositories can access it (select all or specific ones)

### Step 2: Create Reusable Workflow

Create a file `.github/workflows/org-discord-notify.yml` in any repository (or create a dedicated "workflows" repository):

```yaml
name: Organization Discord Notify

on:
  workflow_call:
    inputs:
      # Minimal required inputs - everything else is centralized
      status:
        description: "Job status (success, failure, cancelled)"
        required: true
        type: string
      workflow:
        description: "Workflow name"
        required: true
        type: string
      job:
        description: "Job name"
        required: true
        type: string
      # Optional overrides
      custom_title:
        description: "Custom title (optional)"
        required: false
        type: string
        default: ""
      custom_description:
        description: "Custom description (optional)"
        required: false
        type: string
        default: ""
      custom_username:
        description: "Custom username (optional)"
        required: false
        type: string
        default: "Your Org CI/CD"
      custom_avatar:
        description: "Custom avatar URL (optional)"
        required: false
        type: string
        default: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
      # Advanced options
      include_commit_message:
        description: "Include commit message"
        required: false
        type: string
        default: "true"
      include_duration:
        description: "Include duration"
        required: false
        type: string
        default: "true"
      color_success:
        description: "Success color (hex without #)"
        required: false
        type: string
        default: "00ff00"
      color_failure:
        description: "Failure color (hex without #)"
        required: false
        type: string
        default: "ff0000"
      color_cancelled:
        description: "Cancelled color (hex without #)"
        required: false
        type: string
        default: "808080"

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Send Discord Notification
        uses: Devlander-Software/discord-webhook-notifier-action@v1
        with:
          # Use organization secret
          webhook: ${{ secrets.ORG_DISCORD_WEBHOOK_URL }}
          status: ${{ inputs.status }}
          workflow: ${{ inputs.workflow }}
          job: ${{ inputs.job }}
          repo: ${{ github.repository }}
          branch: ${{ github.ref_name }}
          commit: ${{ github.sha }}
          actor: ${{ github.actor }}
          run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          # Custom options
          title: ${{ inputs.custom_title }}
          description: ${{ inputs.custom_description }}
          username: ${{ inputs.custom_username }}
          avatar_url: ${{ inputs.custom_avatar }}
          include_commit_message: ${{ inputs.include_commit_message }}
          include_duration: ${{ inputs.include_duration }}
          color_success: ${{ inputs.color_success }}
          color_failure: ${{ inputs.color_failure }}
          color_cancelled: ${{ inputs.color_cancelled }}
```

### Step 3: Use in Any Repository

In any repository in your organization, add this minimal configuration:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Tests
        run: npm test
      - name: Notify Discord
        uses: your-org/your-repo/.github/workflows/org-discord-notify.yml@main
        if: always()
        with:
          status: ${{ job.status }}
          workflow: ${{ github.workflow }}
          job: ${{ github.job }}
          # Optional: Override defaults
          custom_title: "🚀 Build Status"
          custom_username: "My App CI"
```

## 🏗️ Advanced Setup Options

### Option 1: Dedicated Workflows Repository

Create a dedicated repository (e.g., `your-org/workflows`) to store all reusable workflows:

```
your-org/workflows/
├── .github/
│   └── workflows/
│       ├── org-discord-notify.yml
│       ├── org-security-scan.yml
│       └── org-deploy.yml
└── README.md
```

Then reference it from any repository:

```yaml
- name: Notify Discord
  uses: your-org/workflows/.github/workflows/org-discord-notify.yml@main
  with:
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
```

### Option 2: Template Repository

Create a template repository with pre-configured workflows:

1. Create a new repository called `your-org/ci-template`
2. Add the reusable workflow
3. Make it a template repository
4. When creating new repositories, use "Use this template"

### Option 3: GitHub CLI Automation

Create a script to automatically add notifications to repositories:

```bash
#!/bin/bash
# add-discord-notifications.sh

REPO=$1
WORKFLOW_URL="your-org/workflows/.github/workflows/org-discord-notify.yml@main"

gh workflow create --repo $REPO --file - << EOF
name: CI/CD with Discord Notifications

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Tests
        run: npm test
      - name: Notify Discord
        uses: $WORKFLOW_URL
        if: always()
        with:
          status: \${{ job.status }}
          workflow: \${{ github.workflow }}
          job: \${{ github.job }}
EOF
```

## 🎨 Customization Examples

### Different Notification Styles

```yaml
# Minimal notification
- name: Notify Discord
  uses: your-org/workflows/.github/workflows/org-discord-notify.yml@main
  with:
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
    include_commit_message: "false"
    include_duration: "false"

# Custom branding
- name: Notify Discord
  uses: your-org/workflows/.github/workflows/org-discord-notify.yml@main
  with:
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
    custom_title: "🚀 Deployment Status"
    custom_username: "Deployment Bot"
    custom_avatar: "https://your-org.com/bot-avatar.png"
    color_success: "00ff00"
    color_failure: "ff0000"

# Raw JSON embeds
- name: Notify Discord
  uses: Devlander-Software/discord-webhook-notifier-action@v1
  with:
    webhook: ${{ secrets.ORG_DISCORD_WEBHOOK_URL }}
    content: "Build completed!"
    embeds: '[{"title":"Custom Embed","description":"Custom description","color":65280}]'
```

## 🔧 Troubleshooting

### Common Issues

1. **Secret not found**: Make sure `ORG_DISCORD_WEBHOOK_URL` is set in organization secrets
2. **Repository access**: Ensure the repository has access to organization secrets
3. **Workflow not found**: Check the path to your reusable workflow
4. **Permission denied**: Verify the repository can access the workflow

### Debug Steps

1. Check organization secret visibility settings
2. Verify workflow file path and branch
3. Test with a simple workflow first
4. Check GitHub Actions logs for detailed error messages

## 📊 Benefits

### For Your Organization
- ✅ **Single Discord channel** for all notifications
- ✅ **Consistent branding** across all repositories
- ✅ **Easy maintenance** (change once, affects all)
- ✅ **Minimal configuration** in each repository
- ✅ **Centralized control** over notification settings

### For Individual Repositories
- ✅ **Minimal setup** required
- ✅ **Automatic notifications** on success/failure
- ✅ **Customizable** when needed
- ✅ **No webhook management** required

## 🚀 Next Steps

1. **Set up organization secrets** with your Discord webhook
2. **Create the reusable workflow** in a central repository
3. **Add notifications** to your existing repositories
4. **Customize** the notification style for your organization
5. **Share this guide** with your team

## 📚 Resources

- [GitHub Organization Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-an-organization)
- [Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Discord Notify Action Documentation](../README.md)
- [GitHub Actions Best Practices](https://docs.github.com/en/actions/learn-github-actions)

---

**Need help?** Open an issue in the [Discord Notify Action repository](https://github.com/Devlander-Software/discord-webhook-notifier-action/issues) or join our [Discussions](https://github.com/Devlander-Software/discord-webhook-notifier-action/discussions). 