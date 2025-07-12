# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Support for raw JSON embeds via `embeds` input
- Plain text content support via `content` input
- Text-to-speech support via `tts` input
- Drop-in compatibility with other Discord notification actions
- Hex color support with automatic conversion to decimal
- Improved folder structure and organization
- Comprehensive test scripts for local development

### Changed
- Reorganized project structure (scripts moved to `scripts/` folder)
- Updated README with compatibility section and better organization
- Enhanced error handling and validation

### Fixed
- Color conversion for hex values (e.g., "ff0000" now works correctly)
- Improved JSON payload construction

## [1.0.0] - 2024-07-12

### Added
- Initial release of Discord Notify Action
- Beautiful Discord embeds with status-based colors
- Support for success, failure, and cancelled job statuses
- Direct links to repository, commits, and workflow runs
- Customizable title and description
- Custom username and avatar support
- Custom color support for different statuses
- Commit message and duration inclusion options
- Comprehensive error handling and validation
- Local testing scripts
- GitHub Actions test workflows
- Automated release workflow
- Professional documentation (README, CONTRIBUTING, SECURITY)

### Features
- 🎨 **Beautiful Embeds**: Rich Discord embeds with colors and icons based on job status
- 🔗 **Direct Links**: Clickable links to repository, commits, and workflow runs
- 📊 **Status Tracking**: Visual indicators for success, failure, and cancelled jobs
- 🛡️ **Error Handling**: Robust error checking and validation
- ⚡ **Fast & Reliable**: Lightweight and efficient notification delivery
- 🎨 **Highly Customizable**: Custom titles, descriptions, colors, and avatars

### Technical Details
- Built as a composite GitHub Action
- Uses `jq` for JSON processing
- Uses `curl` for HTTP requests
- Supports both hex and decimal color values
- Includes comprehensive test coverage

---

## Version History

### v1.0.0
- **Release Date**: July 12, 2024
- **Status**: Stable
- **Features**: Core Discord notification functionality with customization options
- **Compatibility**: GitHub Actions runners with `jq` and `curl`

---

## Migration Guide

### From v1.0.0 to Unreleased
- No breaking changes
- New optional inputs available for enhanced compatibility
- All existing workflows will continue to work without modification

---

## Contributing to the Changelog

When adding new features or making changes:

1. Add entries under the appropriate section in `[Unreleased]`
2. Use the following categories:
   - **Added**: New features
   - **Changed**: Changes in existing functionality
   - **Deprecated**: Features that will be removed
   - **Removed**: Features that have been removed
   - **Fixed**: Bug fixes
   - **Security**: Security-related changes

3. When releasing a new version, move `[Unreleased]` entries to the new version section

---

## Links

- [GitHub Repository](https://github.com/Devlander-Software/discord-notify-action)
- [GitHub Marketplace](https://github.com/marketplace) (when published)
- [Issues](https://github.com/Devlander-Software/discord-notify-action/issues)
- [Pull Requests](https://github.com/Devlander-Software/discord-notify-action/pulls) 