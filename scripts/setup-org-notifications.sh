#!/bin/bash

# Organization Discord Notifications Setup Script
# This script helps set up centralized Discord notifications for GitHub organizations

set -e

echo "🏢 Setting up Organization Discord Notifications"
echo "================================================"

# Check if required tools are available
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq is required but not installed"
    echo "Install with: brew install jq (macOS) or apt-get install jq (Ubuntu)"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "❌ Error: curl is required but not installed"
    exit 1
fi

# Configuration
echo "📋 Configuration"
echo "----------------"

read -p "Enter your Discord webhook URL: " WEBHOOK_URL
read -p "Enter your GitHub organization name: " ORG_NAME
read -p "Enter the repository name for workflows (default: workflows): " REPO_NAME
REPO_NAME=${REPO_NAME:-workflows}

# Validate webhook URL
if [[ ! "$WEBHOOK_URL" =~ ^https://discord\.com/api/webhooks/[0-9]+/[a-zA-Z0-9_-]+$ ]]; then
    echo "❌ Invalid Discord webhook URL format"
    exit 1
fi

echo "✅ Webhook URL format is valid"

# Create organization workflow
echo "📝 Creating organization workflow..."

WORKFLOW_CONTENT=$(cat <<EOF
name: Organization Discord Notifications

on:
  workflow_call:
    inputs:
      status:
        required: true
        type: string
      workflow:
        required: true
        type: string
      job:
        required: true
        type: string
      repo:
        required: true
        type: string
      branch:
        required: true
        type: string
      commit:
        required: true
        type: string
      actor:
        required: true
        type: string
      run_url:
        required: true
        type: string
      custom_title:
        required: false
        type: string
        default: ""
      custom_username:
        required: false
        type: string
        default: "GitHub Actions"

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Discord Notification
        uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
        with:
          webhook: \${{ secrets.DISCORD_WEBHOOK_URL }}
          status: \${{ inputs.status }}
          workflow: \${{ inputs.workflow }}
          job: \${{ inputs.job }}
          repo: \${{ inputs.repo }}
          branch: \${{ inputs.branch }}
          commit: \${{ inputs.commit }}
          actor: \${{ inputs.actor }}
          run_url: \${{ inputs.run_url }}
          title: \${{ inputs.custom_title }}
          username: \${{ inputs.custom_username }}
          auto_detect: true
          smart_formatting: true
          use_rich_embeds: true
          retry_on_failure: true
          max_retries: 3
          retry_delay: 5
EOF
)

echo "📁 Creating workflow directory structure..."
mkdir -p .github/workflows

echo "💾 Saving organization workflow..."
echo "$WORKFLOW_CONTENT" > .github/workflows/org-discord-notify.yml

# Create README for the workflows repository
README_CONTENT=$(cat <<EOF
# $ORG_NAME Workflows

This repository contains reusable GitHub Actions workflows for the $ORG_NAME organization.

## Available Workflows

### org-discord-notify.yml
Centralized Discord notifications for all repositories in the organization.

#### Usage
\`\`\`yaml
- name: Notify Discord
  uses: $ORG_NAME/$REPO_NAME/.github/workflows/org-discord-notify.yml@main
  if: always()
  with:
    status: \${{ job.status }}
    workflow: \${{ github.workflow }}
    job: \${{ github.job }}
    repo: \${{ github.repository }}
    branch: \${{ github.ref_name }}
    commit: \${{ github.sha }}
    actor: \${{ github.actor }}
    run_url: \${{ github.server_url }}/\${{ github.repository }}/actions/runs/\${{ github.run_id }}
\`\`\`

## Setup

1. Add the \`DISCORD_WEBHOOK_URL\` secret to this repository
2. Use the workflow in your repositories as shown above

## Configuration

The workflow uses the Discord Notify Action with smart defaults:
- Auto-detection of workflow types
- Rich embeds with fields and thumbnails
- Retry logic for reliability
- Smart formatting with emojis

## Support

For issues or questions, contact the DevOps team.
EOF
)

echo "📖 Creating README..."
echo "$README_CONTENT" > README.md

# Create template workflow for repositories
TEMPLATE_CONTENT=$(cat <<EOF
name: CI/CD with Discord Notifications

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Tests
        run: echo "Add your test commands here"
      - name: Notify Discord
        uses: $ORG_NAME/$REPO_NAME/.github/workflows/org-discord-notify.yml@main
        if: always()
        with:
          status: \${{ job.status }}
          workflow: \${{ github.workflow }}
          job: \${{ github.job }}
          repo: \${{ github.repository }}
          branch: \${{ github.ref_name }}
          commit: \${{ github.sha }}
          actor: \${{ github.actor }}
          run_url: \${{ github.server_url }}/\${{ github.repository }}/actions/runs/\${{ github.run_id }}

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: echo "Add your build commands here"
      - name: Notify Discord
        uses: $ORG_NAME/$REPO_NAME/.github/workflows/org-discord-notify.yml@main
        if: always()
        with:
          status: \${{ job.status }}
          workflow: \${{ github.workflow }}
          job: \${{ github.job }}
          repo: \${{ github.repository }}
          branch: \${{ github.ref_name }}
          commit: \${{ github.sha }}
          actor: \${{ github.actor }}
          run_url: \${{ github.server_url }}/\${{ github.repository }}/actions/runs/\${{ github.run_id }}

  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: echo "Add your deploy commands here"
      - name: Notify Discord
        uses: $ORG_NAME/$REPO_NAME/.github/workflows/org-discord-notify.yml@main
        if: always()
        with:
          status: \${{ job.status }}
          workflow: \${{ github.workflow }}
          job: \${{ github.job }}
          repo: \${{ github.repository }}
          branch: \${{ github.ref_name }}
          commit: \${{ github.sha }}
          actor: \${{ github.actor }}
          run_url: \${{ github.server_url }}/\${{ github.repository }}/actions/runs/\${{ github.run_id }}
          custom_title: "🚀 Deployment Status"
          custom_username: "Deployment Bot"
EOF
)

echo "📄 Creating template workflow..."
echo "$TEMPLATE_CONTENT" > template-workflow.yml

echo ""
echo "✅ Organization Discord notifications setup complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Create a new repository called '$ORG_NAME/$REPO_NAME'"
echo "2. Push these files to the repository"
echo "3. Add the DISCORD_WEBHOOK_URL secret to the repository"
echo "4. Use the workflow in your repositories"
echo ""
echo "📁 Files created:"
echo "  - .github/workflows/org-discord-notify.yml"
echo "  - README.md"
echo "  - template-workflow.yml"
echo ""
echo "🔗 Documentation: https://github.com/Devlander-Software/discord-webhook-notifier-action" 