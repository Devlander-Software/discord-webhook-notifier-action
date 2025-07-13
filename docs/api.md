# API Reference

## Inputs

### Required Inputs

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| `webhook` | string | ✅ | Discord webhook URL |
| `status` | string | ✅ | Job status (success, failure, cancelled) |
| `workflow` | string | ✅ | Workflow name |
| `job` | string | ✅ | Job name |
| `repo` | string | ✅ | Repository name (e.g., owner/repo) |
| `branch` | string | ✅ | Branch name |
| `commit` | string | ✅ | Commit SHA |
| `actor` | string | ✅ | GitHub actor (user who triggered the workflow) |
| `run_url` | string | ✅ | GitHub Actions run URL |

### Optional Inputs

#### Smart Features
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `auto_detect` | boolean | `true` | Auto-detect workflow context and create smart notifications |
| `smart_formatting` | boolean | `true` | Use smart formatting with emojis, colors, and rich content |

#### Compatibility/Adapter
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `content` | string | `""` | Plain text message (outside embed) |
| `username` | string | `"GitHub Actions"` | Bot username (overrides default) |
| `avatar_url` | string | GitHub logo | Bot avatar URL (overrides default) |
| `embeds` | string | `""` | Raw JSON array of Discord embeds (overrides all other embed options) |
| `tts` | boolean | `false` | Text-to-speech |

#### Advanced Features
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `thread_id` | string | `""` | Discord thread ID to send message to |
| `flags` | string | `""` | Message flags (SUPPRESS_EMBEDS, SUPPRESS_NOTIFICATIONS) |
| `mention_users` | string | `""` | Comma-separated list of user IDs to mention |
| `mention_roles` | string | `""` | Comma-separated list of role IDs to mention |

#### Enterprise Features
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `retry_on_failure` | boolean | `true` | Retry sending notification on failure |
| `max_retries` | number | `3` | Maximum number of retry attempts |
| `retry_delay` | number | `5` | Delay between retries in seconds |

#### Customization
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `title` | string | `""` | Custom title for the Discord message |
| `description` | string | `""` | Custom description for the Discord message |
| `include_commit_message` | boolean | `true` | Include commit message in the notification |
| `include_duration` | boolean | `true` | Include job duration in the notification |
| `include_changed_files` | boolean | `false` | Include list of changed files |
| `include_environment` | boolean | `false` | Include environment info (OS, Node version, etc.) |
| `color_success` | string | `"3066993"` | Custom color for success status (hex color without #) |
| `color_failure` | string | `"15158332"` | Custom color for failure status (hex color without #) |
| `color_cancelled` | string | `"9807270"` | Custom color for cancelled status (hex color without #) |

#### Rich Formatting
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `use_rich_embeds` | boolean | `true` | Use rich embeds with thumbnails, fields, and better formatting |
| `show_workflow_duration` | boolean | `true` | Show total workflow duration |
| `show_job_breakdown` | boolean | `false` | Show breakdown of individual jobs |
| `compact_mode` | boolean | `false` | Use compact mode for shorter notifications |

## Environment Variables

The action uses these environment variables internally:

| Variable | Description |
|----------|-------------|
| `DISCORD_WEBHOOK_URL` | Discord webhook URL |
| `STATUS` | Job status |
| `WORKFLOW` | Workflow name |
| `JOB` | Job name |
| `REPO` | Repository name |
| `BRANCH` | Branch name |
| `COMMIT` | Commit SHA |
| `ACTOR` | GitHub actor |
| `RUN_URL` | GitHub Actions run URL |

## Outputs

This action doesn't produce any outputs.

## Examples

### Basic Usage
```yaml
- name: Discord Notification
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
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

### Advanced Usage
```yaml
- name: Discord Notification
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
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
    # Smart features
    auto_detect: true
    smart_formatting: true
    use_rich_embeds: true
    # Enterprise features
    thread_id: "1234567890123456789"
    mention_users: "123456789012345678,987654321098765432"
    mention_roles: "1234567890123456789"
    retry_on_failure: true
    max_retries: 3
    # Customization
    include_changed_files: true
    include_environment: true
    compact_mode: false
```

### Raw JSON Embeds
```yaml
- name: Discord Notification
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    embeds: |
      [
        {
          "title": "Custom Title",
          "description": "Custom description",
          "color": 3066993,
          "fields": [
            {
              "name": "Field 1",
              "value": "Value 1",
              "inline": true
            }
          ]
        }
      ]
```

## Error Handling

The action includes comprehensive error handling:

- **Missing Required Inputs**: Action will fail with clear error messages
- **Invalid Webhook URL**: Validates webhook format before sending
- **Network Failures**: Automatic retry with exponential backoff
- **Discord API Errors**: Graceful handling of rate limits and API errors
- **Dependency Checks**: Validates required tools (`jq`, `curl`) are available

## Rate Limiting

Discord webhooks have rate limits:
- **5 requests per 2 seconds** per webhook
- Action includes automatic retry logic to handle rate limits
- Configurable retry attempts and delays

## Security

- **No Logging**: Webhook URLs are never logged
- **Input Validation**: All inputs are validated before use
- **Error Sanitization**: Error messages don't expose sensitive information 