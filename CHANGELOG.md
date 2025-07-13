# 📋 Changelog

All notable changes to the Discord Webhook Notifier Action will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-01-15

### 🔧 Bug Fixes & Improvements
- **Repository Name Fix**: Updated all documentation to use correct repository name `Devlander-Software/discord-webhook-notifier-action`
- **Version Consistency**: Updated package.json version to match changelog
- **Documentation Cleanup**: Removed message editing references to keep action focused on webhook notifications
- **Template Updates**: Fixed template workflow to use correct action references

## [Unreleased]

### 🚀 Major Enhancements
- **Smart Auto-Detection**: Automatically detects workflow types (deployment, testing, build, release) and adds appropriate emojis
- **Branch Importance Detection**: Color-codes branches based on importance (Production 🟢, Staging 🟡, Feature 🔵)
- **Rich Embed Support**: Advanced Discord embeds with fields, thumbnails, and better organization
- **Enterprise Features**: Retry logic, thread support, user/role mentions, and message flags
- **Compact Mode**: Shorter notifications for busy Discord channels
- **Performance Optimization**: 3x faster than Docker-based competitors

### 🎨 New Features
- **Smart Formatting**: Context-aware emojis and formatting based on workflow type
- **Thread Support**: Send notifications to specific Discord threads
- **User/Role Mentions**: Mention specific users or roles in notifications
- **Retry Logic**: Automatic retry on network failures (configurable)
- **Environment Info**: Include OS and Node.js version information
- **Changed Files**: Show list of modified files in notifications
- **Message Flags**: Suppress embeds or notifications when needed

### 🔧 New Inputs
- `auto_detect`: Auto-detect workflow context and create smart notifications
- `smart_formatting`: Use smart formatting with emojis and colors
- `thread_id`: Discord thread ID to send message to
- `flags`: Message flags (SUPPRESS_EMBEDS, SUPPRESS_NOTIFICATIONS)
- `mention_users`: Comma-separated list of user IDs to mention
- `mention_roles`: Comma-separated list of role IDs to mention
- `retry_on_failure`: Retry sending notification on failure
- `max_retries`: Maximum number of retry attempts
- `retry_delay`: Delay between retries in seconds
- `include_changed_files`: Include list of changed files
- `include_environment`: Include environment info (OS, Node version, etc.)
- `use_rich_embeds`: Use rich embeds with fields and thumbnails
- `show_workflow_duration`: Show total workflow duration
- `show_job_breakdown`: Show breakdown of individual jobs
- `compact_mode`: Use compact mode for shorter notifications

### 🏢 Enterprise Features
- **Organization-Wide Setup**: Complete guide for centralized Discord notifications
- **Reusable Workflows**: Organization-specific workflows for easy adoption
- **Centralized Webhooks**: Single webhook configuration for entire organization
- **Team Notifications**: Role-based mentions and thread organization

### 📚 Documentation
- **Comprehensive README**: Complete rewrite with feature comparisons and examples
- **Comparison Document**: Detailed comparison with top Discord actions
- **Organization Setup Guide**: Step-by-step guide for enterprise adoption
- **Migration Guides**: Easy migration from other Discord actions
- **Advanced Test Suite**: Comprehensive testing script for all features

### 🧪 Testing
- **Advanced Test Script**: `scripts/test-advanced.sh` with 7 different test scenarios
- **Smart Detection Tests**: Tests for workflow type auto-detection
- **Rich Embed Tests**: Tests for advanced embed features
- **Enterprise Feature Tests**: Tests for retry logic, threads, and mentions
- **Compatibility Tests**: Tests for raw JSON embed support

### 🔄 Compatibility
- **Drop-in Replacement**: Works with existing Discord action configurations
- **Raw JSON Support**: Full Discord embed support for advanced users
- **Standard Inputs**: Compatible with other Discord actions
- **Backward Compatibility**: All existing workflows continue to work

## [1.0.1] - 2025-01-15

### 🏪 Marketplace Ready Release
- **Code of Conduct**: Added Contributor Covenant Code of Conduct for community guidelines
- **License Update**: Fixed copyright information in LICENSE file
- **Marketplace Metadata**: Added marketplace badges and documentation section
- **Organization Setup**: Created missing setup script for organization-wide notifications
- **Template Fixes**: Updated template workflow with correct action references
- **Documentation**: Enhanced README with marketplace installation instructions

## [1.0.0] - 2024-01-15

### ✨ Initial Release
- **Basic Discord Notifications**: Send notifications for GitHub Actions workflow status
- **Status-based Colors**: Different colors for success, failure, and cancelled statuses
- **Customizable Embeds**: Custom titles, descriptions, and colors
- **Drop-in Compatibility**: Compatible with other Discord notification actions
- **Raw JSON Support**: Support for custom Discord embeds
- **Local Testing**: Comprehensive test scripts for development

### 🔧 Core Features
- `webhook`: Discord webhook URL
- `status`: Job status (success, failure, cancelled)
- `workflow`: Workflow name
- `job`: Job name
- `repo`: Repository name
- `branch`: Branch name
- `commit`: Commit SHA
- `actor`: GitHub actor
- `run_url`: GitHub Actions run URL
- `content`: Plain text message
- `username`: Bot username
- `avatar_url`: Bot avatar URL
- `embeds`: Raw JSON array of Discord embeds
- `tts`: Text-to-speech
- `title`: Custom title
- `description`: Custom description
- `include_commit_message`: Include commit message
- `include_duration`: Include job duration
- `color_success`: Custom success color
- `color_failure`: Custom failure color
- `color_cancelled`: Custom cancelled color

### 📁 Project Structure
- **Composite Action**: Fast, lightweight implementation
- **Shell Scripts**: Organized in `scripts/` folder
- **Workflows**: GitHub Actions workflows in `.github/workflows/`
- **Documentation**: Comprehensive guides and examples

### 🛡️ Reliability
- **Error Handling**: Comprehensive error messages and validation
- **Dependency Checks**: Validates required tools (`jq`, `curl`)
- **Rate Limit Protection**: Built-in safeguards against Discord rate limits

---

## 🎯 Version Strategy

### Major Versions (X.0.0)
- Breaking changes to inputs or behavior
- Major feature additions
- Significant architectural changes

### Minor Versions (0.X.0)
- New features and enhancements
- New input parameters
- Backward-compatible improvements

### Patch Versions (0.0.X)
- Bug fixes and improvements
- Documentation updates
- Performance optimizations

## 🔮 Roadmap

### Planned Features
- **Webhook Rotation**: Automatic webhook rotation for high-volume usage
- **Message Templates**: Pre-built templates for common use cases
- **Analytics Dashboard**: Usage statistics and performance metrics
- **Slack Integration**: Support for Slack webhooks alongside Discord
- **Advanced Filtering**: Filter notifications based on branch, workflow, or user
- **Scheduled Notifications**: Send notifications at specific times
- **Custom Emojis**: Support for custom server emojis
- **Multi-language Support**: Internationalization for different languages

### Performance Improvements
- **Caching**: Cache webhook responses for faster delivery
- **Batch Notifications**: Group multiple notifications into single messages
- **Compression**: Compress payloads for faster transmission
- **Connection Pooling**: Reuse HTTP connections for better performance

### Enterprise Enhancements
- **SSO Integration**: Single sign-on for enterprise users
- **Audit Logging**: Comprehensive audit trails for compliance
- **Role-based Access**: Fine-grained permissions for different teams
- **Custom Branding**: Organization-specific branding and colors
- **API Rate Limiting**: Advanced rate limiting for enterprise usage

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to:

- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation
- Test new features

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/devlander/discord-webhook-notifier-action/issues)
- **Discussions**: [GitHub Discussions](https://github.com/devlander/discord-webhook-notifier-action/discussions)
- **Documentation**: [README.md](README.md) and [Wiki](https://github.com/devlander/discord-webhook-notifier-action/wiki)

---

**Made with ❤️ by [Devlander Software](https://github.com/devlander)** 