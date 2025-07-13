# Contributing to Discord Webhook Notifier Action

Thank you for your interest in contributing to Discord Webhook Notifier Action! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in the [Issues](https://github.com/Devlander-Software/discord-webhook-notifier-action/issues) section
2. If not, create a new issue with:
   - A clear and descriptive title
   - Steps to reproduce the bug
   - Expected vs actual behavior
   - Your GitHub Actions workflow configuration (with sensitive data removed)
   - Any error messages or logs

### Suggesting Enhancements

1. Check if the enhancement has already been suggested in the [Issues](https://github.com/Devlander-Software/discord-webhook-notifier-action/issues) section
2. If not, create a new issue with:
   - A clear and descriptive title
   - A detailed description of the proposed enhancement
   - Use cases and examples
   - Any mockups or designs if applicable

### Submitting Pull Requests

1. Fork the repository
2. Create a new branch for your feature/fix: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test your changes:
   - Update the test workflow if needed
   - Ensure the action works with your changes
5. Commit your changes with a descriptive commit message
6. Push to your fork and submit a pull request

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Devlander-Software/discord-webhook-notifier-action.git
   cd discord-webhook-notifier-action
   ```

2. Make your changes to the relevant files:
   - `action.yml` - Action configuration
   - `notify.sh` - Main notification logic
   - `README.md` - Documentation

3. Test your changes locally or by pushing to a fork

## Code Style Guidelines

- Use consistent indentation (2 spaces for YAML, 4 spaces for shell scripts)
- Write clear, descriptive commit messages
- Add comments to complex logic in shell scripts
- Keep the action lightweight and efficient
- Follow the existing code structure and patterns

## Testing

Before submitting a pull request, please ensure:

1. The action works with the test workflow (`.github/workflows/test.yml`)
2. All required inputs are properly validated
3. Error handling is robust
4. The documentation is updated if needed

## Release Process

1. Update the version in `package.json`
2. Create a new tag: `git tag v1.0.1`
3. Push the tag: `git push origin v1.0.1`
4. The release workflow will automatically create a GitHub release

## Questions?

If you have any questions about contributing, please open an issue or reach out to the maintainers.

Thank you for contributing to Discord Webhook Notifier Action! 🎉 