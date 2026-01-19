#!/bin/bash
# Install all plugins from this marketplace

set -e

echo "🚀 Claude Code Plugins - Installation"
echo "====================================="
echo ""

# Check if Claude Code plugins directory exists
if [ ! -d ~/.claude/plugins ]; then
    echo "📁 Creating ~/.claude/plugins directory..."
    mkdir -p ~/.claude/plugins
    echo "✅ Directory created"
    echo ""
fi

# List of plugins to install
PLUGINS=(
    "personal-workspace-setup"
    "coding-skills"
    "productivity-skills"
    "dev-commands"
    "e2e-test-agent"
    "unit-test-agent"
)

echo "📦 Installing plugins..."
echo ""

for plugin in "${PLUGINS[@]}"; do
    if [ -d "$plugin" ]; then
        echo "Installing $plugin..."
        cp -r "$plugin" ~/.claude/plugins/
        echo "✅ $plugin installed"
    else
        echo "⚠️  $plugin not found in current directory"
    fi
done

echo ""
echo "🔧 Making scripts executable..."
chmod +x ~/.claude/plugins/personal-workspace-setup/hooks/scripts/*.sh 2>/dev/null || true
chmod +x ~/.claude/plugins/personal-workspace-setup/statusline.sh 2>/dev/null || true
echo "✅ Scripts made executable"
echo ""

echo "📋 Enabling plugins in Claude Code..."
echo ""

for plugin in "${PLUGINS[@]}"; do
    echo "Enabling $plugin..."
    cc --enable-plugin "$plugin" 2>/dev/null || echo "⚠️  Could not enable $plugin (Claude Code may need to be installed)"
done

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Next Steps:"
echo "  1. Restart Claude Code: cc"
echo "  2. Check installed plugins: cc --list-plugins"
echo ""
echo "🔧 Optional Configuration:"
echo "  - For notifications, add to ~/.zshrc or ~/.bashrc:"
echo "    export SLACK_BOT_TOKEN=\"xoxb-your-token-here\""
echo "    export PUSHOVER_USER_KEY=\"your-user-key-here\""
echo ""
echo "Happy coding! 🚀"
