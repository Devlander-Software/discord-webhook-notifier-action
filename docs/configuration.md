---
layout: default
title: Configuration Options - Discord Notify Action
description: Complete configuration guide for the Discord Notify Action
---

# Configuration Options

## Input Parameters

The Discord Notify Action supports extensive configuration options for maximum flexibility.

### Required Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `webhook` | string | Discord webhook URL | `${{ secrets.DISCORD_WEBHOOK }}` |

### Core Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `status` | string | `${{ job.status }}` | Workflow/job status |
| `workflow` | string | `${{ github.workflow }}` | Workflow name |
| `job` | string | `${{ github.job }}` | Job name |
| `repo` | string | `${{ github.repository }}` | Repository name |
| `branch` | string | `${{ github.ref_name }}` | Branch name |
| `commit` | string | `${{ github.sha }}` | Commit SHA |
| `actor` | string | `${{ github.actor }}` | User who triggered the workflow |
| `run_url` | string | Auto-generated | Link to workflow run |

### Smart Features

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `auto_detect` | boolean | `true` | Auto-detect workflow types and branch importance |
| `smart_formatting` | boolean | `true` | Use context-aware formatting and emojis |
| `use_rich_embeds` | boolean | `true` | Use Discord rich embeds with fields |

### Customization Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `content` | string | `null` | Custom message content |
| `username` | string | `GitHub Actions` | Custom webhook username |
| `avatar_url` | string | GitHub logo | Custom webhook avatar |
| `tts` | boolean | `false` | Text-to-speech for the message |
| `raw_embed` | string | `null` | Raw JSON embed object |

### Enterprise Features

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `retry_count` | number | `3` | Number of retry attempts on failure |
| `retry_delay` | number | `5` | Delay between retries (seconds) |
| `thread_id` | string | `null` | Discord thread ID for threaded messages |
| `mentions` | string | `null` | User/role mentions (e.g., `@here @role`) |
| `suppress_embeds` | boolean | `false` | Suppress Discord link previews |

### Compact Mode

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `compact_mode` | boolean | `false` | Use compact notification format |
| `show_commit_message` | boolean | `true` | Include commit message in notifications |
| `show_duration` | boolean | `true` | Show workflow duration |

## Configuration Examples

### Basic Configuration

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
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

### Advanced Configuration

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
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
    retry_count: 5
    retry_delay: 10
    mentions: "@here @dev-team"
    username: "CI/CD Bot"
    avatar_url: "https://github.com/github.png"
    show_commit_message: true
    show_duration: true
```

### Compact Mode

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
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
    show_commit_message: false
    show_duration: false
```

### Custom Content

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
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
    content: "🚀 Deployment completed! Check the results below."
    username: "Deployment Bot"
    avatar_url: "https://example.com/bot-avatar.png"
    tts: true
```

### Raw JSON Embed

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    raw_embed: |
      {
        "title": "Custom Notification",
        "description": "This is a custom embed",
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
        ]
      }
```

## Environment Variables

You can also configure the action using environment variables:

| Environment Variable | Description |
|---------------------|-------------|
| `DISCORD_WEBHOOK` | Discord webhook URL |
| `DISCORD_USERNAME` | Custom webhook username |
| `DISCORD_AVATAR_URL` | Custom webhook avatar URL |
| `DISCORD_TTS` | Enable text-to-speech |
| `DISCORD_RETRY_COUNT` | Number of retry attempts |
| `DISCORD_RETRY_DELAY` | Delay between retries |

## Best Practices

### 1. Use Organization Secrets

For organization-wide notifications, use organization secrets:

```yaml
webhook: ${{ secrets.ORG_DISCORD_WEBHOOK_URL }}
```

### 2. Conditional Notifications

Only send notifications for specific events:

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
  if: always() && (github.ref == 'refs/heads/main' || github.event_name == 'pull_request')
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    # ... other parameters
```

### 3. Different Configurations for Different Branches

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    mentions: ${{ github.ref == 'refs/heads/main' && '@production-team' || '@dev-team' }}
    # ... other parameters
```

### 4. Error Handling

```yaml
- name: Discord Notification
  uses: devlander/discord-webhook-notifier-action@v1
  continue-on-error: true
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    retry_count: 5
    retry_delay: 10
    # ... other parameters
```

## Validation

The action validates all input parameters and provides helpful error messages for:

- Invalid webhook URLs
- Malformed JSON in `raw_embed`
- Invalid boolean values
- Missing required parameters

## Next Steps

- [Explore Use Cases](examples.html)
- [Learn About Testing](testing.html)
- [Set Up Organization Notifications](organization.html)
- [Troubleshooting Guide](troubleshooting.html) 