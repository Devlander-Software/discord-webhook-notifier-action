#!/bin/bash

# Organization Discord Notifications Setup Script
# This script helps you set up centralized Discord notifications across your GitHub organization

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ORG_NAME=""
WEBHOOK_URL=""
WORKFLOW_REPO=""
DISCORD_INVITE="https://discord.gg/devlander"

echo -e "${BLUE}🏢 Organization Discord Notifications Setup${NC}"
echo "================================================"
echo ""

# Get organization name
read -p "Enter your GitHub organization name: " ORG_NAME
if [ -z "$ORG_NAME" ]; then
    echo -e "${RED}❌ Organization name is required${NC}"
    exit 1
fi

# Get Discord webhook URL
read -p "Enter your Discord webhook URL: " WEBHOOK_URL
if [ -z "$WEBHOOK_URL" ]; then
    echo -e "${RED}❌ Discord webhook URL is required${NC}"
    exit 1
fi

# Get workflow repository
read -p "Enter the repository name to store reusable workflows (e.g., workflows): " WORKFLOW_REPO
if [ -z "$WORKFLOW_REPO" ]; then
    WORKFLOW_REPO="workflows"
fi

echo ""
echo -e "${YELLOW}📋 Setup Steps:${NC}"
echo ""

# Step 1: Create organization secret
echo -e "${BLUE}1. Create Organization Secret${NC}"
echo "   • Go to: https://github.com/organizations/$ORG_NAME/settings/secrets/actions"
echo "   • Click 'New organization secret'"
echo "   • Name: ORG_DISCORD_WEBHOOK_URL"
echo "   • Value: $WEBHOOK_URL"
echo "   • Select repositories that can access this secret"
echo ""

# Step 2: Create workflows repository
echo -e "${BLUE}2. Create Workflows Repository${NC}"
echo "   • Create repository: $ORG_NAME/$WORKFLOW_REPO"
echo "   • Add the reusable workflow file"
echo ""

# Step 3: Create reusable workflow
echo -e "${BLUE}3. Create Reusable Workflow${NC}"
echo "   • Create file: .github/workflows/org-discord-notify.yml"
echo "   • Use the template provided in this repository"
echo ""

# Step 4: Test setup
echo -e "${BLUE}4. Test Your Setup${NC}"
echo "   • Use the test script: ./scripts/test-org-setup.sh"
echo ""

# Create the reusable workflow file
echo -e "${YELLOW}📁 Creating reusable workflow file...${NC}"
mkdir -p .github/workflows

cat > .github/workflows/org-discord-notify.yml << 'EOF'
name: Organization Discord Notify

on:
  workflow_call:
    inputs:
      # Required inputs
      status:
        description: "Job status (success, failure, cancelled)"
        required: true
        type: string
      workflow:
        description: "Workflow name"
        required: true
        type: string
      job:
        description: "Job name"
        required: true
        type: string
      
      # Optional customization
      custom_title:
        description: "Custom title (optional)"
        required: false
        type: string
        default: ""
      custom_description:
        description: "Custom description (optional)"
        required: false
        type: string
        default: ""
      custom_username:
        description: "Custom username (optional)"
        required: false
        type: string
        default: "Devlander CI/CD"
      custom_avatar:
        description: "Custom avatar URL (optional)"
        required: false
        type: string
        default: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
      
      # Advanced options
      include_commit_message:
        description: "Include commit message"
        required: false
        type: string
        default: "true"
      include_duration:
        description: "Include duration"
        required: false
        type: string
        default: "true"
      include_changed_files:
        description: "Include changed files"
        required: false
        type: string
        default: "false"
      include_environment:
        description: "Include environment info"
        required: false
        type: string
        default: "false"
      
      # Enterprise features
      thread_id:
        description: "Discord thread ID to send to"
        required: false
        type: string
        default: ""
      mention_users:
        description: "Comma-separated user IDs to mention"
        required: false
        type: string
        default: ""
      mention_roles:
        description: "Comma-separated role IDs to mention"
        required: false
        type: string
        default: ""
      
      # Smart features
      auto_detect:
        description: "Auto-detect workflow context"
        required: false
        type: string
        default: "true"
      smart_formatting:
        description: "Use smart formatting with emojis"
        required: false
        type: string
        default: "true"
      use_rich_embeds:
        description: "Use rich embeds with fields"
        required: false
        type: string
        default: "true"
      compact_mode:
        description: "Use compact mode for shorter notifications"
        required: false
        type: string
        default: "false"
      
      # Colors
      color_success:
        description: "Success color (hex without #)"
        required: false
        type: string
        default: "00ff00"
      color_failure:
        description: "Failure color (hex without #)"
        required: false
        type: string
        default: "ff0000"
      color_cancelled:
        description: "Cancelled color (hex without #)"
        required: false
        type: string
        default: "808080"

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Send Discord Notification
        uses: Devlander-Software/discord-webhook-notifier-action@v1
        with:
          # Use organization secret
          webhook: ${{ secrets.ORG_DISCORD_WEBHOOK_URL }}
          
          # Required fields
          status: ${{ inputs.status }}
          workflow: ${{ inputs.workflow }}
          job: ${{ inputs.job }}
          repo: ${{ github.repository }}
          branch: ${{ github.ref_name }}
          commit: ${{ github.sha }}
          actor: ${{ github.actor }}
          run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          
          # Custom options
          title: ${{ inputs.custom_title }}
          description: ${{ inputs.custom_description }}
          username: ${{ inputs.custom_username }}
          avatar_url: ${{ inputs.custom_avatar }}
          
          # Advanced options
          include_commit_message: ${{ inputs.include_commit_message }}
          include_duration: ${{ inputs.include_duration }}
          include_changed_files: ${{ inputs.include_changed_files }}
          include_environment: ${{ inputs.include_environment }}
          
          # Enterprise features
          thread_id: ${{ inputs.thread_id }}
          mention_users: ${{ inputs.mention_users }}
          mention_roles: ${{ inputs.mention_roles }}
          
          # Smart features
          auto_detect: ${{ inputs.auto_detect }}
          smart_formatting: ${{ inputs.smart_formatting }}
          use_rich_embeds: ${{ inputs.use_rich_embeds }}
          compact_mode: ${{ inputs.compact_mode }}
          
          # Colors
          color_success: ${{ inputs.color_success }}
          color_failure: ${{ inputs.color_failure }}
          color_cancelled: ${{ inputs.color_cancelled }}
EOF

echo -e "${GREEN}✅ Created reusable workflow file${NC}"

# Create example usage
echo -e "${YELLOW}📝 Example Usage in Any Repository:${NC}"
echo ""
echo "Add this to any repository's workflow:"
echo ""
echo "```yaml"
echo "- name: Notify Discord"
echo "  uses: $ORG_NAME/$WORKFLOW_REPO/.github/workflows/org-discord-notify.yml@main"
echo "  if: always()"
echo "  with:"
echo "    status: \${{ job.status }}"
echo "    workflow: \${{ github.workflow }}"
echo "    job: \${{ github.job }}"
echo "    # Optional: Override defaults"
echo "    custom_title: \"🚀 Build Status\""
echo "    custom_username: \"My App CI\""
echo "```"
echo ""

# Create test script
echo -e "${YELLOW}🧪 Creating test script...${NC}"
cat > scripts/test-org-setup.sh << EOF
#!/bin/bash

# Test organization setup
echo "Testing organization Discord notifications..."

# Test basic notification
curl -H "Content-Type: application/json" \\
     -X POST \\
     -d '{
       "content": "🧪 Testing organization setup",
       "embeds": [{
         "title": "Organization Setup Test",
         "description": "Testing centralized Discord notifications",
         "color": 3066993,
         "fields": [
           {
             "name": "Status",
             "value": "✅ Success",
             "inline": true
           },
           {
             "name": "Organization",
             "value": "$ORG_NAME",
             "inline": true
           }
         ]
       }]
     }' \\
     "$WEBHOOK_URL"

echo "✅ Test notification sent to Discord"
echo "Check your Discord channel for the test message"
EOF

chmod +x scripts/test-org-setup.sh
echo -e "${GREEN}✅ Created test script${NC}"

echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Create the organization secret as shown above"
echo "2. Create the $WORKFLOW_REPO repository and add the workflow file"
echo "3. Test your setup: ./scripts/test-org-setup.sh"
echo "4. Add notifications to your repositories using the example above"
echo ""
echo -e "${BLUE}Need help? Join our Discord: $DISCORD_INVITE${NC}"
echo "" 