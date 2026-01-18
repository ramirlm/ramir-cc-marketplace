# Personal Workspace Setup

Complete workspace setup with security hooks, notifications, and custom statusline for Claude Code.

## Features

### 🛡️ Security Hooks
- **Block AWS Mutations**: Prevents destructive AWS CLI commands (create, delete, modify)
- **Block .env Reads**: Protects sensitive environment files from being read
- **Block rm Commands**: Prevents accidental file deletion

### 📢 Notification Hooks
- **Slack Interactive**: Posts questions to Slack and automatically injects responses
- **Pushover Notifications**: Sends notifications when Claude Code completes tasks
- **Slack Error Notifications**: Alerts you when errors occur

### 📊 Custom Statusline
Rich terminal status display showing:
- Current directory and git status
- Model being used
- Session duration
- Message count
- Context usage with visual progress bar
- Session name and ID

## Installation

### Via Claude Code Plugin System

```bash
# Clone or copy this plugin to your Claude plugins directory
cp -r personal-workspace-setup ~/.claude/plugins/

# Enable the plugin in Claude Code
cc --enable-plugin personal-workspace-setup
```

### Prerequisites

- **jq**: JSON processor for hook scripts
  ```bash
  # macOS
  brew install jq

  # Linux
  sudo apt-get install jq
  ```

- **curl**: HTTP client (usually pre-installed)

## Configuration

### Environment Variables

Set these in your shell profile (`~/.zshrc`, `~/.bashrc`, etc.):

#### For Slack Integration

```bash
# Get these from your Slack App at https://api.slack.com/apps
export SLACK_BOT_TOKEN="xoxb-your-bot-token-here"
export SLACK_CHANNEL_ID="C0XXXXXXXXX"
```

**How to get Slack credentials:**
1. Go to https://api.slack.com/apps
2. Create a new app or select existing
3. Add OAuth scopes: `chat:write`, `channels:read`, `conversations.replies`
4. Install app to workspace
5. Copy the Bot User OAuth Token (starts with `xoxb-`)
6. Get channel ID from Slack (right-click channel → View channel details → Copy ID at bottom)

#### For Pushover Integration

```bash
# Get these from https://pushover.net/
export PUSHOVER_USER_KEY="your-user-key-here"
export PUSHOVER_APP_TOKEN="your-app-token-here"
```

**How to get Pushover credentials:**
1. Sign up at https://pushover.net/
2. Your user key is shown on the dashboard
3. Create an application to get an app token
4. Install Pushover app on your phone/desktop

### Notification Sound (Optional)

The plugin includes a notification sound hook. To use it:

```bash
# Download or copy your preferred notification sound
mkdir -p ~/claude-plugins/personal-workspace-setup/hooks/sounds
cp /path/to/notification.mp3 ~/claude-plugins/personal-workspace-setup/hooks/sounds/
```

Or comment out the Notification hook in `hooks/hooks.json` if not needed.

### Statusline Setup

The statusline is automatically configured via the plugin. To manually configure it in your global settings:

```json
{
  "statusLine": {
    "type": "command",
    "command": "${CLAUDE_PLUGIN_ROOT}/statusline.sh"
  }
}
```

## Usage

### Security Hooks

Security hooks run automatically and block dangerous operations:

```bash
# ✅ Allowed: Read-only AWS commands
aws s3 ls
aws ec2 describe-instances

# 🛑 Blocked: Mutation commands
aws s3 rm s3://bucket/file
aws ec2 terminate-instances --instance-ids i-xxx

# ✅ Allowed: Safe file operations
cat .env  # Only if not trying to read via Read tool

# 🛑 Blocked: Reading .env files
# (Blocked when Claude tries to read .env files)

# ✅ Allowed: Most operations
mv file.txt backup.txt

# 🛑 Blocked: Dangerous deletions
rm -rf directory/
```

### Notification Hooks

#### Slack Interactive

When Claude asks a question (via AskUserQuestion):
1. Question automatically posts to your configured Slack channel
2. Respond in the Slack thread
3. Your response is automatically typed into Claude Code

#### Pushover Notifications

Automatically sends a notification when Claude Code stops, including:
- Stop reason (task complete, interrupted, etc.)
- Project name
- Last assistant message
- Session information

#### Slack Error Notifications

Posts to Slack when errors occur, allowing you to stay informed even when away from your desk.

### Custom Statusline

The statusline automatically updates and shows:

```
➜ project-name (main*) │ Sonnet │ ⏱ 2m15s │ 💬 12 │ [████████████--------] ~45k [session-id]
```

- **Directory**: Current working directory
- **Git**: Branch name and dirty status (`*` if uncommitted changes)
- **Model**: Claude model in use
- **Duration**: Time spent in current session
- **Messages**: Number of messages exchanged
- **Progress Bar**: Visual context usage (orange = used, gray = available)
- **Token Estimate**: Approximate tokens used (~45k)
- **Session Info**: Session name (if set) and ID

## Customization

### Modify Hook Behavior

Edit `hooks/hooks.json` to customize which hooks run and when:

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",  // Run before Bash tool
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/block-rm-commands.sh",
          "timeout": 5
        }
      ]
    }
  ]
}
```

### Add Custom Hooks

Create new hook scripts in `hooks/scripts/` and add them to `hooks/hooks.json`:

```bash
#!/bin/bash
# Your custom hook logic here
# Exit 0 = allow, Exit 2 = block
```

### Customize Statusline

Edit `statusline.sh` to modify colors, format, or displayed information.

## Troubleshooting

### Hooks Not Running

1. Verify plugin is enabled:
   ```bash
   cc --list-plugins
   ```

2. Check hook scripts are executable:
   ```bash
   ls -la ~/claude-plugins/personal-workspace-setup/hooks/scripts/
   ```

3. Test hook manually:
   ```bash
   echo '{"tool_input":{"command":"rm file.txt"}}' | \
     ~/claude-plugins/personal-workspace-setup/hooks/scripts/block-rm-commands.sh
   ```

### Slack Not Working

1. Verify environment variables are set:
   ```bash
   echo $SLACK_BOT_TOKEN
   echo $SLACK_CHANNEL_ID
   ```

2. Check Slack bot permissions include:
   - `chat:write`
   - `channels:read`
   - `conversations.replies`

3. Verify bot is added to the target channel

4. Check logs:
   ```bash
   tail -f ~/.claude/slack_hook.log
   ```

### Pushover Not Working

1. Verify environment variables:
   ```bash
   echo $PUSHOVER_USER_KEY
   echo $PUSHOVER_APP_TOKEN
   ```

2. Test Pushover API manually:
   ```bash
   curl -s \
     --form-string "token=$PUSHOVER_APP_TOKEN" \
     --form-string "user=$PUSHOVER_USER_KEY" \
     --form-string "message=Test" \
     https://api.pushover.net/1/messages.json
   ```

### Statusline Not Displaying

1. Check if statusline is configured in settings
2. Verify script is executable: `chmod +x statusline.sh`
3. Test manually:
   ```bash
   echo '{"workspace":{"current_dir":"'$PWD'"}}' | \
     ~/claude-plugins/personal-workspace-setup/statusline.sh
   ```

## File Structure

```
personal-workspace-setup/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── hooks/
│   ├── hooks.json                # Hook configuration
│   ├── scripts/
│   │   ├── block-aws-mutations.sh    # AWS security hook
│   │   ├── block-env-reads.sh        # .env protection hook
│   │   ├── block-rm-commands.sh      # rm prevention hook
│   │   ├── pushover-notify.sh        # Pushover notification hook
│   │   ├── slack-interactive.sh      # Slack Q&A hook
│   │   └── slack-notify-error.sh     # Slack error hook
│   └── sounds/                   # Optional notification sounds
├── statusline.sh                 # Custom statusline script
└── README.md                     # This file
```

## Security Considerations

- **Credentials**: Never commit credentials to version control
- **Environment Variables**: Use environment variables for all secrets
- **Hook Scripts**: Review all hook scripts before enabling
- **Permissions**: Hooks run with your user permissions
- **Slack Bot**: Use a dedicated Slack bot with minimal permissions
- **AppleScript**: slack-interactive.sh uses AppleScript to type responses (macOS only)

## License

MIT

## Author

Ramir Mesquita

## Support

For issues or questions, please check the troubleshooting section or review hook logs in `~/.claude/slack_hook.log`.
