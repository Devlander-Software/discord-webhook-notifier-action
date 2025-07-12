# Discord Notify Action

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/Devlander-Software/discord-notify-action)](https://github.com/Devlander-Software/discord-notify-action/releases)
[![GitHub license](https://img.shields.io/github/license/Devlander-Software/discord-notify-action)](https://github.com/Devlander-Software/discord-notify-action/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Devlander-Software/discord-notify-action)](https://github.com/Devlander-Software/discord-notify-action/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Devlander-Software/discord-notify-action)](https://github.com/Devlander-Software/discord-notify-action/network)
[![GitHub issues](https://img.shields.io/github/issues/Devlander-Software/discord-notify-action)](https://github.com/Devlander-Software/discord-notify-action/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/Devlander-Software/discord-notify-action)](https://github.com/Devlander-Software/discord-notify-action/pulls)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/Devlander-Software/discord-notify-action/test.yml?branch=production)](https://github.com/Devlander-Software/discord-notify-action/actions)

> **The Most Advanced Discord Notification Action for GitHub Actions** 🚀

A powerful, feature-rich GitHub Action that sends beautiful Discord notifications when your workflows complete. Get real-time updates about your CI/CD pipeline status directly in your Discord server with unmatched customization and compatibility.

**✨ Why Choose This Action?**
- 🎨 **Beautiful Embeds** with status-based colors and icons
- 🔄 **Drop-in Compatible** with existing Discord notification actions
- 🎯 **Highly Customizable** with 15+ configuration options
- 🛡️ **Enterprise Ready** with comprehensive error handling
- ⚡ **Lightning Fast** and reliable notification delivery
- 🌟 **Open Source** with active community support

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

## 🌟 Features That Set Us Apart

### 🎨 **Beautiful & Professional Embeds**
- Rich Discord embeds with status-based colors and icons
- Direct links to repository, commits, and workflow runs
- Visual indicators for success, failure, and cancelled jobs
- Professional formatting with timestamps and footers

### 🔄 **Drop-in Compatibility**
- **Seamless Migration**: Replace any existing Discord notification action without changing your workflow
- **Raw JSON Support**: Use `embeds` input for complete control over embed structure
- **Content & TTS**: Support for plain text messages and text-to-speech
- **Backward Compatible**: All existing workflows continue to work

### 🎯 **Unmatched Customization**
- **15+ Configuration Options**: More customization than any other Discord action
- **Hex Color Support**: Use hex colors (e.g., `#ff0000`) with automatic conversion
- **Custom Titles & Descriptions**: Override default messages completely
- **Flexible Username & Avatar**: Customize bot appearance
- **Feature Toggles**: Enable/disable commit messages, duration, timestamps

### 🛡️ **Enterprise-Grade Reliability**
- **Comprehensive Error Handling**: Detailed error messages and validation
- **Rate Limit Protection**: Built-in safeguards against Discord rate limits
- **Dependency Validation**: Checks for required tools (`jq`, `curl`)
- **Robust Testing**: Automated tests for all scenarios

### ⚡ **Performance & Developer Experience**
- **Lightning Fast**: Optimized for speed with minimal overhead
- **Local Testing**: Comprehensive test scripts for development
- **Clear Documentation**: Extensive examples and troubleshooting guides
- **Active Maintenance**: Regular updates and community support

### 🌟 **Open Source Excellence**
- **MIT License**: Free for commercial and personal use
- **Community Driven**: Welcome contributions and feature requests
- **Transparent Development**: All code is open and auditable
- **Professional Standards**: Follows GitHub Action best practices

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

## 🚀 Quick Start

### Install in 30 Seconds

**Individual Repository:**
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

**🏢 Organization-Wide Setup:** See our [Organization Setup Guide](ORGANIZATION-SETUP.md) for centralized notifications across all repositories.

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

### Migrate from Other Actions

**Replace any existing Discord action with ours:**

```yaml
# Before (other action)
- name: Discord Notification
  uses: some-other/discord-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK_URL }}
    message: "Build completed"

# After (our action - same inputs work!)
- name: Discord Notification
  uses: Devlander-Software/discord-notify-action@v1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK_URL }}
    content: "Build completed"  # Same functionality, better features
```

---

## 📊 Why Choose Our Action?

| Feature | Our Action | Other Actions |
|---------|------------|---------------|
| **Customization Options** | 15+ inputs | 5-8 inputs |
| **Drop-in Compatibility** | ✅ Full support | ❌ Limited |
| **Hex Color Support** | ✅ Automatic conversion | ❌ Manual conversion |
| **Raw JSON Embeds** | ✅ Complete control | ❌ Basic only |
| **Local Testing** | ✅ Comprehensive scripts | ❌ None |
| **Error Handling** | ✅ Enterprise-grade | ⚠️ Basic |
| **Documentation** | ✅ Extensive guides | ⚠️ Minimal |
| **Organization Setup** | ✅ Complete guide | ❌ None |
| **Open Source** | ✅ MIT License | ⚠️ Various licenses |
| **Active Maintenance** | ✅ Regular updates | ⚠️ Inconsistent |

---

## Usage Examples

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

## 🤝 Community & Contributing

We welcome contributions from the community! Here's how you can help:

### 🚀 **Quick Contributions**
- ⭐ **Star this repository** to show your support
- 🐛 **Report bugs** by opening an issue
- 💡 **Suggest features** in the discussions
- 📖 **Improve documentation** with pull requests
- 🔧 **Fix bugs** or add new features

### 🛠️ **Development Setup**
1. **Fork the repository**
2. **Clone your fork**: `git clone https://github.com/YOUR_USERNAME/discord-notify-action.git`
3. **Create a branch**: `git checkout -b feature/amazing-feature`
4. **Make changes** and test locally using the scripts in `scripts/`
5. **Commit changes**: `git commit -m 'feat: add amazing feature'`
6. **Push to your fork**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### 🧪 **Testing Your Changes**
```bash
# Test basic functionality
./scripts/test-local.sh "YOUR_WEBHOOK_URL" success

# Test customization features
./scripts/test-custom.sh "YOUR_WEBHOOK_URL"

# Test with environment variables
./scripts/test-with-env.sh
```

### 📋 **Contribution Guidelines**
- Follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages
- Add tests for new features
- Update documentation for any changes
- Ensure all tests pass before submitting

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 🌟 **Support the Project**

If this action helps you, consider:

- ⭐ **Starring the repository**
- 🐛 **Reporting issues** you encounter
- 💬 **Joining discussions** about new features
- 📢 **Sharing** with your team and community
- ☕ **Buying us a coffee** (if you're feeling generous!)

---

## 📚 **Additional Resources**

- 📖 **[Full Documentation](https://github.com/Devlander-Software/discord-notify-action#readme)**
- 🏢 **[Organization Setup Guide](ORGANIZATION-SETUP.md)** - Set up centralized notifications for your entire organization
- 🔄 **[Changelog](CHANGELOG.md)** - See what's new
- 🛡️ **[Security Policy](SECURITY.md)** - Report security issues
- 💬 **[Discussions](https://github.com/Devlander-Software/discord-notify-action/discussions)** - Ask questions and share ideas
- 🐛 **[Issues](https://github.com/Devlander-Software/discord-notify-action/issues)** - Report bugs and request features

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Made with ❤️ by [Devlander Software](https://github.com/Devlander-Software)**
