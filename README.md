# Discord Notify Action

A GitHub Action that sends beautiful Discord notifications when your workflows complete. Get real-time updates about your CI/CD pipeline status directly in your Discord server.

---

## Table of Contents
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Usage](#usage)
- [Compatibility & Adapter Usage](#compatibility--adapter-usage)
- [Inputs](#inputs)
- [Setup](#setup)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

---

## Features
- 🎨 **Beautiful Embeds**: Rich Discord embeds with colors and icons based on job status
- 🔗 **Direct Links**: Clickable links to repository, commits, and workflow runs
- 📊 **Status Tracking**: Visual indicators for success, failure, and cancelled jobs
- 🛡️ **Error Handling**: Robust error checking and validation
- ⚡ **Fast & Reliable**: Lightweight and efficient notification delivery
- 🔄 **Drop-in Compatible**: Supports common Discord alert action inputs (`content`, `embeds`, etc.)

---

## Folder Structure

```
.
├── .github/
│   └── workflows/
│       ├── release.yml
│       ├── test.yml
│       ├── test-action.yml
│       └── test-workflow.yml
├── scripts/
│   ├── notify.sh
│   ├── test-local.sh
│   ├── test-custom.sh
│   └── test-with-env.sh
├── action.yml
├── env.example
├── package.json
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
```

- **.github/workflows/**: All GitHub Actions workflow files
- **scripts/**: All shell scripts for notifications and local testing
- **env.example**: Example environment file for local testing
- **action.yml**: Main action definition

---

## Usage

### Basic Example

```yaml
- name: Notify Discord
  uses: Devlander-Software/discord-notify-action@v1
  if: always()
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK_URL }}
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
    repo: ${{ github.repository }}
    branch: ${{ github.ref_name }}
    commit: ${{ github.sha }}
    actor: ${{ github.actor }}
    run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
```

---

## Compatibility & Adapter Usage

This action can be used as a **drop-in replacement** for most Discord notification actions. It supports the following common inputs:
- `content`: Plain text message (outside embed)
- `username`: Bot username
- `avatar_url`: Bot avatar URL
- `embeds`: Raw JSON array of Discord embeds (overrides all other embed options)
- `tts`: Text-to-speech (true/false)

**Example:**
```yaml
- name: Discord Alert
  uses: Devlander-Software/discord-notify-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK_URL }}
    content: "Build finished!"
    username: "CI Bot"
    avatar_url: "https://example.com/bot.png"
    embeds: '[{"title":"Build Status","description":"Success!","color":65280}]'
    tts: "false"
```

If `embeds` is set, your action will send exactly what is provided, just like other popular Discord actions.

---

## Inputs

### Required Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `webhook` | Discord Webhook URL | ✅ Yes | - |
| `status` | Job status (success, failure, cancelled) | ✅ Yes | - |
| `workflow` | Workflow name | ✅ Yes | - |
| `job` | Job name | ✅ Yes | - |
| `repo` | Repository name | ✅ Yes | - |
| `branch` | Branch name | ✅ Yes | - |
| `commit` | Commit SHA | ✅ Yes | - |
| `actor` | GitHub actor (user who triggered the workflow) | ✅ Yes | - |
| `run_url` | GitHub Actions run URL | ✅ Yes | - |

### Optional & Compatibility Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `content` | Plain text message (outside embed) | ❌ No | "" |
| `username` | Bot username | ❌ No | "GitHub Actions" |
| `avatar_url` | Bot avatar URL | ❌ No | GitHub logo |
| `embeds` | Raw JSON array of Discord embeds | ❌ No | "" |
| `tts` | Text-to-speech | ❌ No | "false" |
| `title` | Custom title for the Discord message | ❌ No | Status with icon |
| `description` | Custom description for the Discord message | ❌ No | Auto-generated |
| `include_commit_message` | Include commit message in notification | ❌ No | "true" |
| `include_duration` | Include job duration in notification | ❌ No | "true" |
| `color_success` | Custom color for success status (hex without #) | ❌ No | "3066993" |
| `color_failure` | Custom color for failure status (hex without #) | ❌ No | "15158332" |
| `color_cancelled` | Custom color for cancelled status (hex without #) | ❌ No | "9807270" |

---

## Setup

### 1. Create a Discord Webhook
1. Go to your Discord server settings
2. Navigate to **Integrations** → **Webhooks**
3. Click **New Webhook**
4. Choose a channel and give it a name
5. Copy the webhook URL

### 2. Add Webhook to GitHub Secrets
1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `DISCORD_WEBHOOK_URL`
5. Value: Your Discord webhook URL

### 3. Use the Action
Add the action to your workflow as shown in the examples above.

---

## Testing

### Local Testing

1. Copy `env.example` to `.env` (or set variables manually)
2. Run the test scripts in the `scripts/` folder:
   ```bash
   ./scripts/test-local.sh "YOUR_WEBHOOK_URL" success
   ./scripts/test-custom.sh "YOUR_WEBHOOK_URL"
   ./scripts/test-with-env.sh
   ```
3. Check your Discord channel for notifications.

### GitHub Actions Testing

- All workflow files are in `.github/workflows/`
- Add `DISCORD_WEBHOOK_URL` to your repository secrets
- Push changes to trigger the test workflow
- Check the Actions tab to see test results

---

## Troubleshooting

- **Webhook URL Invalid**: Make sure your Discord webhook URL is correct and the webhook hasn't been deleted
- **Missing Permissions**: Ensure the webhook has permission to send messages in the target channel
- **Rate Limiting**: Discord has rate limits; if you're sending many notifications, consider batching them
- **Custom Colors Not Working**: Use hex colors without the `#` symbol (e.g., `00ff00` not `#00ff00`)
- **Debug Mode**: Check the action logs in GitHub Actions for detailed output

---

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Changelog
See [CHANGELOG.md](CHANGELOG.md) for a complete history of changes and version information.

---

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
