#!/bin/bash

# Discord Webhook Notifier Action - Screenshot Examples
# This script sends various notification examples to Discord for screenshot purposes

set -e

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

WEBHOOK_URL="${DISCORD_WEBHOOK:-$DISCORD_WEBHOOK_URL}"

if [ -z "$WEBHOOK_URL" ]; then
    echo "❌ Error: No Discord webhook URL found in .env file"
    echo "Please set DISCORD_WEBHOOK_URL in your .env file"
    exit 1
fi

echo "📸 Sending Discord notification examples for screenshots..."
echo "Webhook: ${WEBHOOK_URL:0:50}..."

# Function to send Discord notification
send_notification() {
    local title="$1"
    local description="$2"
    local color="$3"
    local fields="$4"
    local username="$5"
    local avatar_url="$6"
    
    local payload=$(cat <<EOF
{
    "username": "${username:-"GitHub Actions"}",
    "avatar_url": "${avatar_url:-"https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"}",
    "embeds": [{
        "title": "${title}",
        "description": "${description}",
        "color": ${color},
        "fields": ${fields},
        "footer": {
            "text": "Discord Webhook Notifier Action • Screenshot Example"
        },
        "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
    }]
}
EOF
)
    
    curl -s -X POST -H "Content-Type: application/json" -d "$payload" "$WEBHOOK_URL" > /dev/null
    echo "✅ Sent: $title"
    sleep 2
}

# Wait for user to be ready
echo "🚀 Ready to send notification examples?"
echo "Press Enter to start, or Ctrl+C to cancel..."
read

echo ""
echo "📸 Sending Basic Success Notification..."
send_notification \
    "✅ Build Successful" \
    "**devlander-software/discord-webhook-notifier-action** build completed successfully on branch \`main\`" \
    "3066993" \
    '[
        {"name": "Repository", "value": "devlander-software/discord-webhook-notifier-action", "inline": true},
        {"name": "Branch", "value": "main", "inline": true},
        {"name": "Commit", "value": "a1b2c3d4e5", "inline": true},
        {"name": "Actor", "value": "@landonwjohnson", "inline": true}
    ]' \
    "GitHub Actions Bot" \
    "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"

echo ""
echo "📸 Sending Basic Failure Notification..."
send_notification \
    "❌ Build Failed" \
    "**devlander-software/discord-webhook-notifier-action** build failed on branch \`feature/new-feature\`" \
    "15158332" \
    '[
        {"name": "Repository", "value": "devlander-software/discord-webhook-notifier-action", "inline": true},
        {"name": "Branch", "value": "feature/new-feature", "inline": true},
        {"name": "Error", "value": "Test suite failed", "inline": true},
        {"name": "Actor", "value": "@landonwjohnson", "inline": true}
    ]' \
    "GitHub Actions Bot" \
    "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"

echo ""
echo "📸 Sending Rich Embed with Custom Branding..."
send_notification \
    "🚀 Production Deployment" \
    "**v1.2.0** has been successfully deployed to production environment" \
    "3066993" \
    '[
        {"name": "Version", "value": "v1.2.0", "inline": true},
        {"name": "Environment", "value": "Production", "inline": true},
        {"name": "Deployment Time", "value": "2m 30s", "inline": true},
        {"name": "Status", "value": "✅ Healthy", "inline": true}
    ]' \
    "Deployment Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Compact Mode Notification..."
send_notification \
    "✅ Tests Passed" \
    "**devlander-software/discord-webhook-notifier-action** • main • @landonwjohnson" \
    "3066993" \
    '[]' \
    "CI Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Release Notification..."
send_notification \
    "🎉 New Release: v1.2.0" \
    "**Discord Webhook Notifier Action v1.2.0** has been published!\n\n✨ New Features:\n• Enhanced error handling\n• Improved performance\n• Better documentation\n\n🐛 Bug Fixes:\n• Fixed webhook timeout issues\n• Resolved formatting problems" \
    "3447003" \
    '[
        {"name": "Version", "value": "v1.2.0", "inline": true},
        {"name": "Downloads", "value": "1,234", "inline": true}
    ]' \
    "Release Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Enterprise Features Notification..."
send_notification \
    "⚠️ Security Scan Alert" \
    "**devlander-software/discord-webhook-notifier-action** security scan detected potential vulnerabilities" \
    "16776960" \
    '[
        {"name": "Severity", "value": "Medium", "inline": true},
        {"name": "Vulnerabilities", "value": "3 found", "inline": true},
        {"name": "Branch", "value": "main", "inline": true},
        {"name": "Requires Action", "value": "Yes", "inline": true}
    ]' \
    "Enterprise Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Cancelled Notification..."
send_notification \
    "⏹️ Build Cancelled" \
    "**devlander-software/discord-webhook-notifier-action** build was cancelled on branch \`feature/experimental\`" \
    "9807270" \
    '[
        {"name": "Repository", "value": "devlander-software/discord-webhook-notifier-action", "inline": true},
        {"name": "Branch", "value": "feature/experimental", "inline": true},
        {"name": "Reason", "value": "Manual cancellation", "inline": true},
        {"name": "Actor", "value": "@landonwjohnson", "inline": true}
    ]' \
    "GitHub Actions Bot" \
    "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"

echo ""
echo "📸 Sending Staging Deployment Notification..."
send_notification \
    "🚀 Staging Deployment" \
    "**devlander-software/discord-webhook-notifier-action** has been deployed to staging environment" \
    "16776960" \
    '[
        {"name": "Environment", "value": "Staging", "inline": true},
        {"name": "Branch", "value": "develop", "inline": true},
        {"name": "Deployment Time", "value": "1m 45s", "inline": true},
        {"name": "Status", "value": "✅ Deployed", "inline": true}
    ]' \
    "Deployment Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Test Results with Coverage..."
send_notification \
    "🧪 Test Results" \
    "**devlander-software/discord-webhook-notifier-action** test suite completed with excellent coverage" \
    "3066993" \
    '[
        {"name": "Tests Passed", "value": "156/156", "inline": true},
        {"name": "Coverage", "value": "98.5%", "inline": true},
        {"name": "Duration", "value": "45s", "inline": true},
        {"name": "Branch", "value": "main", "inline": true}
    ]' \
    "Test Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Pull Request Notification..."
send_notification \
    "🔀 Pull Request Merged" \
    "**Feature: Add advanced notification features** has been merged into \`main\`" \
    "3066993" \
    '[
        {"name": "PR #", "value": "#42", "inline": true},
        {"name": "Author", "value": "@landonwjohnson", "inline": true},
        {"name": "Target Branch", "value": "main", "inline": true},
        {"name": "Files Changed", "value": "15 files", "inline": true}
    ]' \
    "GitHub Actions Bot" \
    "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"

echo ""
echo "📸 Sending Error with Details..."
send_notification \
    "💥 Critical Error" \
    "**devlander-software/discord-webhook-notifier-action** encountered a critical error during deployment" \
    "15158332" \
    '[
        {"name": "Error Type", "value": "Database Connection", "inline": true},
        {"name": "Environment", "value": "Production", "inline": true},
        {"name": "Impact", "value": "High", "inline": true},
        {"name": "ETA", "value": "15 minutes", "inline": true}
    ]' \
    "Alert Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "📸 Sending Build Success with URLs..."
send_notification \
    "✅ Build Successful" \
    "**[devlander-software/discord-webhook-notifier-action](https://github.com/devlander-software/discord-webhook-notifier-action)** build completed successfully on branch `main`.\n\n[View Run](https://github.com/devlander-software/discord-webhook-notifier-action/actions/runs/123456789)" \
    "3066993" \
    '[
        {"name": "Repository", "value": "[devlander-software/discord-webhook-notifier-action](https://github.com/devlander-software/discord-webhook-notifier-action)", "inline": true},
        {"name": "Branch", "value": "[main](https://github.com/devlander-software/discord-webhook-notifier-action/tree/main)", "inline": true},
        {"name": "Commit", "value": "[a1b2c3d4e5](https://github.com/devlander-software/discord-webhook-notifier-action/commit/a1b2c3d4e5)", "inline": true}
    ]' \
    "GitHub Actions Bot" \
    "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"

# Embed with clickable title (url property)
echo ""
echo "📸 Sending Build Success with Clickable Title..."
curl -s -X POST -H "Content-Type: application/json" -d '{
    "username": "GitHub Actions Bot",
    "avatar_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
    "embeds": [{
        "title": "✅ Build Successful (Clickable Title)",
        "url": "https://github.com/devlander-software/discord-webhook-notifier-action/actions/runs/123456789",
        "description": "Build completed successfully. Click the title to view the run.",
        "color": 3066993,
        "fields": [
            {"name": "Repository", "value": "[devlander-software/discord-webhook-notifier-action](https://github.com/devlander-software/discord-webhook-notifier-action)", "inline": true},
            {"name": "Branch", "value": "main", "inline": true}
        ],
        "footer": {"text": "Discord Webhook Notifier Action • Screenshot Example"},
        "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
    }]
}' "$WEBHOOK_URL" > /dev/null
echo "✅ Sent: Build Success with Clickable Title"
sleep 2

echo ""
echo "📸 Sending Release Notification with Download Link..."
send_notification \
    "🎉 New Release: v1.2.0" \
    "**Discord Webhook Notifier Action v1.2.0** has been published!\n\n[Download Release](https://github.com/devlander-software/discord-webhook-notifier-action/releases/tag/v1.2.0)" \
    "3447003" \
    '[
        {"name": "Version", "value": "v1.2.0", "inline": true},
        {"name": "Release Page", "value": "[View on GitHub](https://github.com/devlander-software/discord-webhook-notifier-action/releases/tag/v1.2.0)", "inline": true}
    ]' \
    "Release Bot" \
    "https://raw.githubusercontent.com/devlander-software/discord-webhook-notifier-action/production/assets/images/bot-avatar.png"

echo ""
echo "🎉 All notification examples sent successfully!"
echo "📸 You can now take screenshots of each notification type in your Discord channel."
echo ""
echo "📋 Screenshot Checklist:"
echo "  ✅ Basic Success Notification (green)"
echo "  ✅ Basic Failure Notification (red)"
echo "  ✅ Rich Embed with Custom Branding (deployment)"
echo "  ✅ Compact Mode (minimal info)"
echo "  ✅ Release Notification (blue, detailed)"
echo "  ✅ Enterprise Features (warning, security)"
echo "  ✅ Cancelled Notification (gray)"
echo "  ✅ Staging Deployment (orange)"
echo "  ✅ Test Results with Coverage (green, detailed)"
echo "  ✅ Pull Request Notification (green, PR info)"
echo "  ✅ Error with Details (red, critical)"
echo ""
echo "💡 Tips for screenshots:"
echo "  • Take screenshots of each notification individually"
echo "  • Include the bot avatar and username in the screenshot"
echo "  • Capture the full embed with all fields"
echo "  • Save with descriptive names matching the documentation" 