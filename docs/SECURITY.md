# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in Discord Webhook Notifier Action, please follow these steps:

1. **Do NOT create a public GitHub issue** for the vulnerability
2. **Email the maintainers** at [landon@devlander.software](mailto:landon@devlander.software) with:
   - A detailed description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact assessment
   - Any suggested fixes (if available)

3. **Wait for acknowledgment** - You should receive a response within 48 hours
4. **Follow up** - We'll work with you to validate and fix the issue

## Security Features

This action includes comprehensive security measures:

### Input Validation & Sanitization
- **All user inputs are sanitized** to prevent injection attacks
- **Input length limits** prevent abuse and buffer overflow attacks
- **URL validation** ensures only trusted domains are used for avatars
- **JSON validation** prevents injection through embed parameters
- **Command injection protection** by using GitHub API instead of git commands

### Security Validations
- **Webhook URL format validation** ensures only valid Discord webhooks are accepted
- **Status validation** restricts to allowed values (success, failure, cancelled)
- **Error message sanitization** prevents information disclosure
- **Character filtering** removes dangerous control characters

### Safe Defaults
- **Trusted domain allowlist** for avatar URLs
- **Maximum input lengths** for all text fields
- **Secure error handling** with sanitized responses

## Security Best Practices

When using this action, please follow these security guidelines:

### Webhook Security

- **Never commit webhook URLs** to your repository
- **Use GitHub Secrets** to store your Discord webhook URL
- **Rotate webhook URLs** periodically
- **Use dedicated webhooks** for different projects/environments

### Repository Security

- **Review workflow permissions** - Only grant necessary permissions
- **Use branch protection rules** to prevent unauthorized changes
- **Enable security scanning** for your repository

### Action Usage

- **Pin action versions** to specific releases (e.g., `@v1.0.0`) rather than using `@main`
- **Review action source code** before using in production
- **Monitor action logs** for any unexpected behavior
- **Test with security test suite** using `./scripts/test-security.sh`

## Disclosure Policy

1. **Private disclosure** - We'll work with you privately to fix the issue
2. **Coordinated disclosure** - We'll coordinate the public disclosure with you
3. **Credit acknowledgment** - We'll credit you in the security advisory (unless you prefer to remain anonymous)

## Security Updates

Security updates will be released as patch versions (e.g., 1.0.1, 1.0.2) and will be clearly marked in the release notes.

## Contact

For security-related questions or concerns, please contact:
- Email: [landon@devlander.software](mailto:landon@devlander.software)
- GitHub: [@Devlander-Software](https://github.com/Devlander-Software)

Thank you for helping keep Discord Webhook Notifier Action secure! 🔒 