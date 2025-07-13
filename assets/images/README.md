# Test Images

This directory contains test images used by the Discord Webhook Notifier Action for testing and development purposes.

## Images

- **test-bot-avatar.png** - Default avatar for integration test bot (Discord CDN avatar)
- **github-logo.png** - GitHub logo for default bot avatars
- **success-icon.png** - Success icon for test notifications

## Usage

These images are used in:
- Integration tests (`scripts/test-integration.sh`)
- Local testing scripts
- Development and debugging

## Benefits

- **Reliability**: No dependency on external URLs
- **Speed**: Local files load instantly
- **Consistency**: Same images across all environments
- **Offline**: Works without internet connection

## Adding New Images

To add new test images:
1. Place the image file in this directory
2. Update the relevant test scripts to use the local path
3. Commit the image to the repository 