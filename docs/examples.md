---
layout: default
title: Examples - Discord Webhook Notifier Action
description: Common use cases and examples for the Discord Webhook Notifier Action
---

# Examples

## Basic Usage

### Simple Success/Failure Notification

```yaml
- name: Discord Notification
  uses: ./
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

### With Smart Formatting

```yaml
- name: Discord Notification
  uses: ./
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

## Advanced Examples

### Custom Branding

```yaml
- name: Discord Notification
  uses: ./
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
    title: "🚀 Deployment Status"
    username: "Deployment Bot"
    avatar_url: "https://your-domain.com/bot-avatar.png"
    color_success: "00ff00"
    color_failure: "ff0000"
```

### Compact Mode for Busy Channels

```yaml
- name: Discord Notification
  uses: ./
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
    compact_mode: true
    include_commit_message: false
    include_duration: false
```

### Enterprise Features

```yaml
- name: Discord Notification
  uses: ./
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
    retry_on_failure: true
    max_retries: 5
    retry_delay: 10
    thread_id: "1234567890123456789"
    mention_users: "123456789012345678,987654321098765432"
    mention_roles: "123456789012345678"
```

## Complete Workflow Examples

### CI/CD Pipeline

```yaml
name: CI/CD Pipeline

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
        run: npm test
      - name: Discord Notification
        uses: ./
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

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
      - name: Discord Notification
        uses: ./
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

  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: npm run deploy
      - name: Discord Notification
        uses: ./
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
          title: "🚀 Deployment Status"
          username: "Deployment Bot"
```

### Release Workflow

```yaml
name: Release

on:
  release:
    types: [published]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Discord Notification
        uses: ./
        with:
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          status: success
          workflow: ${{ github.workflow }}
          job: notify
          repo: ${{ github.repository }}
          branch: ${{ github.ref_name }}
          commit: ${{ github.sha }}
          actor: ${{ github.actor }}
          run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          title: "🎉 New Release Published"
          description: "**${{ github.event.release.name }}** has been published!\n\n${{ github.event.release.body }}\n\n[Download Release](${{ github.event.release.html_url }})"
          username: "Release Bot"
```

## Raw JSON Examples

### Custom Embed

```yaml
- name: Discord Notification
  uses: ./
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    content: "Custom notification with raw JSON embed"
    embeds: |
      [{
        "title": "Custom Embed",
        "description": "This is a custom embed created with raw JSON",
        "color": 3447003,
        "fields": [
          {
            "name": "Status",
            "value": "${{ job.status }}",
            "inline": true
          },
          {
            "name": "Repository",
            "value": "${{ github.repository }}",
            "inline": true
          }
        ],
        "footer": {
          "text": "Custom Footer"
        }
      }]
    username: "Custom Bot"
```

## Conditional Notifications

### Only on Main Branch

```yaml
- name: Discord Notification
  uses: ./
  if: always() && github.ref == 'refs/heads/main'
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

### Only on Failure

```yaml
- name: Discord Notification
  uses: ./
  if: failure()
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
    title: "❌ Build Failed"
    mention_users: "123456789012345678"
```

---

**Need more examples?** Check out the [Configuration Guide](configuration.md) for all available options, or visit our [GitHub Discussions](https://github.com/Devlander-Software/discord-webhook-notifier-action/discussions) for community examples. 