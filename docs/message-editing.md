# Message Editing

The Discord Notify Action supports editing existing messages in Discord channels. This is useful for updating status messages, progress indicators, or maintaining a single message that gets updated throughout a workflow.

## 🔄 **How Message Editing Works**

### **Two Methods Available:**

1. **Webhook Message Editing** (Limited)
   - Can only edit messages created by the same webhook
   - Requires storing the message ID from the initial send
   - Simpler setup, but limited functionality

2. **Bot API Message Editing** (Recommended)
   - Can edit any message in channels the bot has access to
   - Requires a Discord bot token
   - Full editing capabilities
   - More flexible and powerful

## 🚀 **Quick Start**

### **Basic Message Editing**

```yaml
- name: Edit Discord Message
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
    message_id: "1234567890123456789"
    edit_message: true
    status: ${{ job.status }}
    workflow: ${{ github.workflow }}
    job: ${{ github.job }}
    repo: ${{ github.repository }}
    branch: ${{ github.ref_name }}
    commit: ${{ github.sha }}
    actor: ${{ github.actor }}
    run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
```

### **Progressive Status Updates**

```yaml
name: CI/CD with Progressive Updates

on:
  push:
    branches: [ main ]

jobs:
  notify-start:
    runs-on: ubuntu-latest
    steps:
      - name: Send Initial Notification
        uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
        with:
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          status: "pending"
          workflow: ${{ github.workflow }}
          job: "Initial"
          repo: ${{ github.repository }}
          branch: ${{ github.ref_name }}
          commit: ${{ github.sha }}
          actor: ${{ github.actor }}
          run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          title: "🚀 Starting Deployment"
          description: "Deployment is starting..."

  test:
    runs-on: ubuntu-latest
    needs: notify-start
    steps:
      - uses: actions/checkout@v4
      - name: Run Tests
        run: npm test
      - name: Update Status - Testing
        uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
        if: always()
        with:
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
          message_id: ${{ needs.notify-start.outputs.message_id }}
          edit_message: true
          status: ${{ job.status }}
          workflow: ${{ github.workflow }}
          job: ${{ github.job }}
          repo: ${{ github.repository }}
          branch: ${{ github.ref_name }}
          commit: ${{ github.sha }}
          actor: ${{ github.actor }}
          run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          title: "🧪 Testing Complete"
          description: "Tests have completed with status: ${{ job.status }}"

  deploy:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: npm run deploy
      - name: Update Status - Deployed
        uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
        if: always()
        with:
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
          message_id: ${{ needs.notify-start.outputs.message_id }}
          edit_message: true
          status: ${{ job.status }}
          workflow: ${{ github.workflow }}
          job: ${{ github.job }}
          repo: ${{ github.repository }}
          branch: ${{ github.ref_name }}
          commit: ${{ github.sha }}
          actor: ${{ github.actor }}
          run_url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          title: "🚀 Deployment Complete"
          description: "Deployment has completed with status: ${{ job.status }}"
```

## ⚙️ **Configuration**

### **Required Inputs for Message Editing**

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| `edit_message` | boolean | ✅ | Set to `true` to edit instead of send |
| `message_id` | string | ✅ | Discord message ID to edit |
| `bot_token` | string | ✅ | Discord bot token for API access |

### **Optional Inputs**

All other inputs work the same as regular notifications:
- `status`, `workflow`, `job`, etc.
- `title`, `description` for custom content
- `use_rich_embeds`, `compact_mode`, etc.

## 🔧 **Setup Requirements**

### **1. Discord Bot Setup**

1. **Create a Discord Application**:
   - Go to [Discord Developer Portal](https://discord.com/developers/applications)
   - Click "New Application"
   - Give it a name (e.g., "GitHub Actions Bot")

2. **Create a Bot**:
   - Go to "Bot" section
   - Click "Add Bot"
   - Copy the bot token

3. **Set Bot Permissions**:
   - Go to "OAuth2" → "URL Generator"
   - Select scopes: `bot`, `applications.commands`
   - Select permissions: `Send Messages`, `Manage Messages`, `Read Message History`
   - Use the generated URL to invite the bot to your server

4. **Add Bot Token to Secrets**:
   ```bash
   # In your repository settings
   DISCORD_BOT_TOKEN = "your-bot-token-here"
   ```

### **2. Get Message ID**

To get a message ID in Discord:
1. Enable Developer Mode (User Settings → Advanced → Developer Mode)
2. Right-click on the message you want to edit
3. Click "Copy Message ID"

### **3. Channel ID Extraction**

The action automatically extracts the channel ID from your webhook URL. Make sure your webhook URL follows this format:
```
https://discord.com/api/webhooks/[webhook-id]/[webhook-token]
```

## 📋 **Use Cases**

### **1. Progressive Status Updates**
Update a single message as your workflow progresses through different stages.

### **2. Live Progress Tracking**
Show real-time progress of long-running operations.

### **3. Status Dashboards**
Maintain a single message that shows the current state of your system.

### **4. Deployment Status**
Keep one message updated with deployment progress and final status.

## 🔒 **Security Considerations**

### **Bot Token Security**
- **Never commit bot tokens** to your repository
- Use GitHub Secrets to store the token
- Rotate tokens regularly
- Use minimal required permissions

### **Message Access**
- Bots can only edit messages in channels they have access to
- Ensure proper channel permissions are set
- Consider using dedicated channels for bot messages

## 🚨 **Limitations**

### **Discord API Limits**
- **5 requests per 2 seconds** per webhook
- **50 requests per 2 seconds** per bot
- Action includes automatic retry logic

### **Message Age**
- Discord bots cannot edit messages older than 2 weeks
- Consider this when designing long-running workflows

### **Channel Permissions**
- Bot needs `Manage Messages` permission to edit messages
- Bot needs `Read Message History` to access message content

## 🔍 **Troubleshooting**

### **Common Issues**

1. **"Could not extract channel ID"**
   - Ensure webhook URL is in correct format
   - Check that webhook URL is valid

2. **"Failed to edit Discord message"**
   - Verify bot token is correct
   - Check bot has proper permissions
   - Ensure message ID is valid
   - Check message is not older than 2 weeks

3. **"MESSAGE_ID is required"**
   - Provide a valid Discord message ID
   - Enable Developer Mode to copy message IDs

### **Debug Mode**

Enable debug output by setting the action to verbose mode:
```yaml
- name: Edit Message
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
  with:
    # ... other inputs ...
    edit_message: true
    message_id: "1234567890123456789"
    bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
```

## 📚 **Examples**

### **Simple Status Update**
```yaml
- name: Update Status
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
    message_id: "1234567890123456789"
    edit_message: true
    status: "success"
    title: "✅ Build Complete"
    description: "All tests passed successfully!"
```

### **Rich Embed Update**
```yaml
- name: Update Rich Embed
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
    message_id: "1234567890123456789"
    edit_message: true
    status: "success"
    use_rich_embeds: true
    include_changed_files: true
    include_environment: true
    title: "🚀 Deployment Successful"
```

### **Compact Mode Update**
```yaml
- name: Update Compact Status
  uses: Devlander-Software/discord-webhook-notifier-action@v1.0.1
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    bot_token: ${{ secrets.DISCORD_BOT_TOKEN }}
    message_id: "1234567890123456789"
    edit_message: true
    status: "success"
    compact_mode: true
    title: "✅ Done"
``` 