# Installation Guide

Quick guide to install and configure all Claude Code plugins.

## 📋 Prerequisites

Install these before setting up plugins:

```bash
# macOS/Linux
brew install jq          # JSON processor (required)
brew install gh          # GitHub CLI (for dev-commands)

# Verify installations
jq --version
gh --version
```

## 🚀 Quick Installation (All Plugins)

```bash
# 1. Copy all plugins to Claude Code plugins directory
cp -r ~/claude-plugins/* ~/.claude/plugins/

# 2. Enable all plugins
cc --enable-plugin personal-workspace-setup
cc --enable-plugin coding-skills
cc --enable-plugin productivity-skills
cc --enable-plugin dev-commands
cc --enable-plugin e2e-test-agent
cc --enable-plugin unit-test-agent

# 3. Restart Claude Code
exit
cc
```

## 🔧 Configuration

### Step 1: Environment Variables (Required for notifications)

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Slack integration (optional, for personal-workspace-setup)
export SLACK_BOT_TOKEN="xoxb-your-token-here"
export SLACK_CHANNEL_ID="C0XXXXXXXXX"

# Pushover notifications (optional, for personal-workspace-setup)
export PUSHOVER_USER_KEY="your-user-key-here"
export PUSHOVER_APP_TOKEN="your-app-token-here"
```

Then reload:
```bash
source ~/.zshrc
```

### Step 2: GitHub CLI (Required for /open-pr)

```bash
gh auth login
# Follow prompts to authenticate
```

### Step 3: Verify Installation

```bash
# Check plugins are enabled
cc --list-plugins

# Verify hook scripts are executable
ls -la ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/hooks/scripts/

# Should show -rwx--x--x (executable)
```

## 📦 Individual Plugin Installation

If you only want specific plugins:

### personal-workspace-setup

```bash
cp -r ~/claude-plugins/personal-workspace-setup ~/.claude/plugins/
cc --enable-plugin personal-workspace-setup

# Configure environment variables (see above)
# Make scripts executable
chmod +x ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/hooks/scripts/*.sh
chmod +x ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/statusline.sh
```

### coding-skills

```bash
cp -r ~/claude-plugins/coding-skills ~/.claude/plugins/
cc --enable-plugin coding-skills
```

### productivity-skills

```bash
cp -r ~/claude-plugins/productivity-skills ~/.claude/plugins/
cc --enable-plugin productivity-skills
```

### dev-commands

```bash
cp -r ~/claude-plugins/dev-commands ~/.claude/plugins/
cc --enable-plugin dev-commands

# Requires GitHub CLI
gh auth login
```

### e2e-test-agent

```bash
cp -r ~/claude-plugins/e2e-test-agent ~/.claude/plugins/
cc --enable-plugin e2e-test-agent

# Requires Playwright or Cypress in your projects
# npm install -D @playwright/test
# or
# npm install -D cypress
```

### unit-test-agent

```bash
cp -r ~/claude-plugins/unit-test-agent ~/.claude/plugins/
cc --enable-plugin unit-test-agent

# Requires Jest or Vitest in your projects
# npm install -D jest @types/jest
# or
# npm install -D vitest
```

## 🧪 Testing Installation

### Test personal-workspace-setup

```bash
# Start Claude Code
cc

# Try a blocked command (will be prevented)
# Type: aws s3 rm s3://test/file
# Should be blocked by security hook

# Check statusline appears at bottom of terminal
```

### Test coding-skills

```bash
# Ask Claude a coding question
# Skills should activate automatically
"How should I structure this React component?"
```

### Test dev-commands

```bash
# Try a command
/improve-claude

# List all commands
/help
```

### Test test agents

```bash
# In a project with tests
"Run the unit tests"
"Run the e2e tests"
```

## ❌ Troubleshooting

### Plugins not showing up

```bash
# Check plugin directory
ls ~/.claude/plugins/

# Should see all plugin directories
# personal-workspace-setup, coding-skills, etc.

# Restart Claude Code
exit
cc
```

### Hooks not working

```bash
# Make scripts executable
chmod +x ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/hooks/scripts/*.sh
chmod +x ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/statusline.sh

# Verify
ls -la ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/hooks/scripts/
# Should show -rwx--x--x
```

### Environment variables not set

```bash
# Verify they're set
echo $SLACK_BOT_TOKEN
echo $PUSHOVER_USER_KEY

# If empty, add to ~/.zshrc and reload
source ~/.zshrc
```

### Commands not appearing

```bash
# List enabled plugins
cc --list-plugins

# Should show all enabled plugins

# Try enabling again
cc --enable-plugin dev-commands

# Restart
exit
cc
```

### GitHub CLI not working

```bash
# Check if authenticated
gh auth status

# If not, authenticate
gh auth login
```

## 🔄 Updating Plugins

To update plugins after making changes:

```bash
# 1. Make changes to plugin files in ~/claude-plugins/

# 2. Copy updated plugins
cp -r ~/claude-plugins/* ~/.claude/plugins/

# 3. Restart Claude Code
exit
cc
```

## 🗑️ Uninstalling

To remove all plugins:

```bash
# Disable plugins
cc --disable-plugin personal-workspace-setup
cc --disable-plugin coding-skills
cc --disable-plugin productivity-skills
cc --disable-plugin dev-commands
cc --disable-plugin e2e-test-agent
cc --disable-plugin unit-test-agent

# Remove plugin files
rm -rf ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup
rm -rf ~/.claude/plugins/coding-skills
rm -rf ~/.claude/plugins/productivity-skills
rm -rf ~/.claude/plugins/dev-commands
rm -rf ~/.claude/plugins/e2e-test-agent
rm -rf ~/.claude/plugins/unit-test-agent
```

## 📚 Next Steps

After installation:

1. **Configure environment variables** for Slack/Pushover (if using notifications)
2. **Test each plugin** to verify functionality
3. **Read individual READMEs** for detailed usage
4. **Customize as needed** - edit hooks, skills, commands to fit your workflow

See main README.md for usage examples and detailed documentation.
