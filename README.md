# Discord Notify Action

A GitHub Action that sends beautiful Discord notifications when your workflows complete. Get real-time updates about your CI/CD pipeline status directly in your Discord server.

## Features

- 🎨 **Beautiful Embeds**: Rich Discord embeds with colors and icons based on job status
- 🔗 **Direct Links**: Clickable links to repository, commits, and workflow runs
- 📊 **Status Tracking**: Visual indicators for success, failure, and cancelled jobs
- 🛡️ **Error Handling**: Robust error checking and validation
- ⚡ **Fast & Reliable**: Lightweight and efficient notification delivery

## Installation

### Option 1: Install from GitHub Marketplace (Recommended)

1. Go to the [GitHub Marketplace](https://github.com/marketplace)
2. Search for "Discord Notify Action"
3. Click "Use latest version"
4. Select your repository and configure the action

### Option 2: Manual Installation

Add this to your workflow:

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

## Usage

### Basic Example

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

### Advanced Example with Multiple Jobs

```yaml
name: Full CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint Code
        run: npm run lint
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

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - name: Run Tests
        run: npm test
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

  deploy:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: npm run deploy
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

### Customization Examples

#### Custom Title and Description

```yaml
- name: Notify Discord with Custom Message
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
    # Customization options
    title: "🚀 Deployment Status"
    description: "**Project:** My Awesome App\n**Environment:** Production\n**Status:** ${{ job.status }}\n\nCheck the run for more details!"
    username: "Deployment Bot"
    avatar_url: "https://example.com/custom-avatar.png"
```

#### Custom Colors

```yaml
- name: Notify Discord with Custom Colors
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
    # Custom colors (hex values without #)
    color_success: "00ff00"  # Bright green
    color_failure: "ff0000"  # Bright red
    color_cancelled: "808080" # Gray
```

#### Minimal Notification

```yaml
- name: Minimal Discord Notification
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
    # Disable extra features
    include_commit_message: "false"
    include_duration: "false"
    title: "Build ${{ job.status }}"
```

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

### Optional Customization Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `title` | Custom title for the Discord message | ❌ No | Status with icon |
| `description` | Custom description for the Discord message | ❌ No | Auto-generated |
| `username` | Custom username for the Discord webhook | ❌ No | "GitHub Actions" |
| `avatar_url` | Custom avatar URL for the Discord webhook | ❌ No | GitHub logo |
| `include_commit_message` | Include commit message in notification | ❌ No | "true" |
| `include_duration` | Include job duration in notification | ❌ No | "true" |
| `color_success` | Custom color for success status (hex without #) | ❌ No | "3066993" |
| `color_failure` | Custom color for failure status (hex without #) | ❌ No | "15158332" |
| `color_cancelled` | Custom color for cancelled status (hex without #) | ❌ No | "9807270" |

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

## Status Colors

The action automatically uses different colors based on the job status:

- 🟢 **Success**: Green (#3066993)
- 🔴 **Failure**: Red (#15158332)
- ⚪ **Cancelled**: Gray (#9807270)

## Requirements

- `jq` - JSON processor (usually available in GitHub Actions runners)
- `curl` - HTTP client (usually available in GitHub Actions runners)

## Testing

### Local Testing

You can test the action locally before deploying:

1. **Create a Discord webhook** in your server
2. **Run the local test script**:
   ```bash
   ./test-local.sh "https://discord.com/api/webhooks/your-webhook-url" success
   ```

3. **Test different statuses**:
   ```bash
   ./test-local.sh "your-webhook-url" failure
   ./test-local.sh "your-webhook-url" cancelled
   ```

The test script will send notifications to your Discord channel so you can verify the formatting and functionality.

### GitHub Actions Testing

The action includes automated tests that run on every push:

- **Success scenario**: Tests successful job completion
- **Failure scenario**: Tests failed job completion  
- **Customization scenario**: Tests custom title, description, and colors

To run tests in your repository:

1. Add `DISCORD_WEBHOOK_URL` to your repository secrets
2. Push changes to trigger the test workflow
3. Check the Actions tab to see test results

## Troubleshooting

### Common Issues

1. **Webhook URL Invalid**: Make sure your Discord webhook URL is correct and the webhook hasn't been deleted
2. **Missing Permissions**: Ensure the webhook has permission to send messages in the target channel
3. **Rate Limiting**: Discord has rate limits; if you're sending many notifications, consider batching them
4. **Custom Colors Not Working**: Make sure to use hex colors without the `#` symbol (e.g., `00ff00` not `#00ff00`)

### Debug Mode

To see more detailed output, you can check the action logs in GitHub Actions. The action will show:
- Whether dependencies are available
- The notification payload being sent
- HTTP response codes
- Success/failure messages
- Customization options being used

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
