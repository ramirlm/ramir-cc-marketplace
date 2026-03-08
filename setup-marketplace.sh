#!/bin/bash
# Setup script to prepare plugins for marketplace publication
# This script will help you:
# 1. Initialize git repository
# 2. Update marketplace.json with your GitHub username
# 3. Create initial commit
# 4. Push to GitHub

set -e

echo "🚀 Claude Code Plugins - Marketplace Setup"
echo "=========================================="
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Install it with: brew install gh"
    echo "Then run: gh auth login"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ GitHub CLI is not authenticated."
    echo "Run: gh auth login"
    exit 1
fi

# Get GitHub username
GITHUB_USERNAME=$(gh api user -q .login)
echo "✅ Authenticated as: $GITHUB_USERNAME"
echo ""

# Check if repository already exists
EXISTING_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")

if [ -n "$EXISTING_REMOTE" ]; then
    echo "📦 Found existing remote repository:"
    echo "   $EXISTING_REMOTE"
    echo ""
    read -p "Do you want to reuse this repository (update only) or create a new one? (reuse/new): " REPO_ACTION

    if [[ "$REPO_ACTION" == "reuse" ]]; then
        # Reuse mode - just update marketplace.json
        read -p "Enter marketplace name (default: ramir-personal-marketplace): " MARKETPLACE_NAME
        MARKETPLACE_NAME=${MARKETPLACE_NAME:-ramir-personal-marketplace}

        # Extract repo name from URL
        REPO_NAME=$(basename "$EXISTING_REMOTE" .git)

        echo ""
        echo "📝 Configuration:"
        echo "  GitHub Username: $GITHUB_USERNAME"
        echo "  Repository Name: $REPO_NAME"
        echo "  Marketplace Name: $MARKETPLACE_NAME"
        echo ""
    else
        # Create new mode
        read -p "Enter repository name (default: claude-plugins): " REPO_NAME
        REPO_NAME=${REPO_NAME:-claude-plugins}

        read -p "Enter marketplace name (default: ramir-personal-marketplace): " MARKETPLACE_NAME
        MARKETPLACE_NAME=${MARKETPLACE_NAME:-ramir-personal-marketplace}

        echo ""
        echo "📝 Configuration:"
        echo "  GitHub Username: $GITHUB_USERNAME"
        echo "  Repository Name: $REPO_NAME"
        echo "  Marketplace Name: $MARKETPLACE_NAME"
        echo ""
    fi
else
    # No existing repo - create new one
    read -p "Enter repository name (default: claude-plugins): " REPO_NAME
    REPO_NAME=${REPO_NAME:-claude-plugins}

    read -p "Enter marketplace name (default: ramir-personal-marketplace): " MARKETPLACE_NAME
    MARKETPLACE_NAME=${MARKETPLACE_NAME:-ramir-personal-marketplace}

    echo ""
    echo "📝 Configuration:"
    echo "  GitHub Username: $GITHUB_USERNAME"
    echo "  Repository Name: $REPO_NAME"
    echo "  Marketplace Name: $MARKETPLACE_NAME"
    echo ""

    REPO_ACTION="create"
fi

echo ""
echo "📝 Configuration:"
echo "  GitHub Username: $GITHUB_USERNAME"
echo "  Repository Name: $REPO_NAME"
echo "  Marketplace Name: $MARKETPLACE_NAME"
echo ""

# Update marketplace.json with actual URLs
echo "📝 Updating marketplace.json..."
MARKETPLACE_FILE="marketplace.json"

# Backup original
cp "$MARKETPLACE_FILE" "${MARKETPLACE_FILE}.backup"

# Update URLs using sed (cross-platform compatible)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|https://github.com/yourusername/claude-plugins|https://github.com/$GITHUB_USERNAME/$REPO_NAME|g" "$MARKETPLACE_FILE"
    sed -i '' "s|ramir-personal-marketplace|$MARKETPLACE_NAME|g" "$MARKETPLACE_FILE"
else
    # Linux
    sed -i "s|https://github.com/yourusername/claude-plugins|https://github.com/$GITHUB_USERNAME/$REPO_NAME|g" "$MARKETPLACE_FILE"
    sed -i "s|ramir-personal-marketplace|$MARKETPLACE_NAME|g" "$MARKETPLACE_FILE"
fi

echo "✅ marketplace.json updated"
echo ""

# Only initialize and create repo if it's a new one
if [ "$REPO_ACTION" != "reuse" ]; then
    # Initialize git if not already
    if [ ! -d .git ]; then
        echo "📦 Initializing git repository..."
        git init
        echo "✅ Git initialized"
        echo ""
    else
        echo "✅ Git already initialized"
        echo ""
    fi

    # Create .gitignore if not exists
    if [ ! -f .gitignore ]; then
        echo "📝 Creating .gitignore..."
        cat > .gitignore << 'EOF'
# Generated files
*.backup

# OS
.DS_Store

# Environment
.env
.env.local

# Logs
*.log
EOF
        echo "✅ .gitignore created"
        echo ""
    fi

    # Add all files
    echo "📦 Staging files..."
    git add .
    echo "✅ Files staged"
    echo ""

    # Create initial commit (only if no commits exist)
    if ! git rev-parse --quiet --verify HEAD >/dev/null 2>&1; then
        echo "💾 Creating initial commit..."
        git commit -m "Initial commit: Claude Code plugins marketplace

- personal-workspace-setup: Security hooks and notifications
- coding-skills: Development best practices
- productivity-skills: Productivity enhancement
- dev-commands: Development workflow commands
- e2e-test-agent: Autonomous E2E testing
- unit-test-agent: Autonomous unit testing"
        echo "✅ Initial commit created"
        echo ""
    fi

    # Create GitHub repository
    echo "🌐 Creating GitHub repository..."
    gh repo create "$REPO_NAME" \
        --public \
        --source=. \
        --description="Claude Code plugins collection: Security, productivity, testing, and development workflows" \
        --remote=origin \
        --push

    echo ""
    echo "✅ Repository created and pushed!"
    echo ""

    # Create initial release
    echo "🏷️  Creating v1.0.0 release..."
    gh release create v1.0.0 \
        --title "v1.0.0 - Initial Release" \
        --notes "Complete plugin collection with 6 plugins:

- **personal-workspace-setup**: Security hooks, notifications, and statusline
- **coding-skills**: Coding standards and best practices
- **productivity-skills**: File organization, meeting analysis, prompt optimization
- **dev-commands**: Development workflow commands
- **e2e-test-agent**: Autonomous end-to-end testing with Playwright/Cypress
- **unit-test-agent**: Autonomous unit testing with Jest/Vitest

See README.md for installation and usage instructions."
else
    # Reuse mode - only update and push changes
    echo "📦 Updating existing repository..."

    git add marketplace.json

    # Check if there are changes to commit
    if ! git diff --cached --quiet; then
        echo "💾 Committing changes..."
        git commit -m "Update marketplace configuration: $MARKETPLACE_NAME"
        echo "✅ Changes committed"
        echo ""

        echo "🔄 Pushing to remote..."
        git push origin master || git push origin main
        echo "✅ Changes pushed!"
    else
        echo "✅ No changes to commit"
    fi
    echo ""
fi

echo ""
if [ "$REPO_ACTION" = "reuse" ]; then
    echo "🎉 Success! Your marketplace has been updated!"
else
    echo "🎉 Success! Your marketplace is published!"
fi
echo ""
echo "📋 Installation Instructions for Users:"
echo ""
echo "1️⃣  Clone or download the repository:"
echo "   git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo ""
echo "2️⃣  Copy plugins to Claude Code plugins directory:"
echo "   cp -r ~/$REPO_NAME/* ~/.claude/plugins/"
echo ""
echo "3️⃣  Enable the plugins you want to use:"
echo "   cc --enable-plugin personal-workspace-setup"
echo "   cc --enable-plugin coding-skills"
echo "   cc --enable-plugin productivity-skills"
echo "   cc --enable-plugin dev-commands"
echo "   cc --enable-plugin e2e-test-agent"
echo "   cc --enable-plugin unit-test-agent"
echo ""
echo "4️⃣  Make hook scripts executable (for personal-workspace-setup):"
echo "   chmod +x ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/hooks/scripts/*.sh"
echo "   chmod +x ~/.claude/plugins/marketplaces/ramir-personal-marketplace/personal-workspace-setup/statusline.sh"
echo ""
echo "5️⃣  Restart Claude Code:"
echo "   cc"
echo ""
echo "📚 Documentation:"
echo "  - Repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "  - Marketplace JSON: https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/marketplace.json"
echo "  - Installation Guide: See INSTALLATION.md in the repository"
echo ""
echo "🔧 Configuration (Optional):"
echo "  - For notifications, set environment variables in ~/.zshrc or ~/.bashrc:"
echo "    export SLACK_BOT_TOKEN=\"xoxb-your-token-here\""
echo "    export PUSHOVER_USER_KEY=\"your-user-key-here\""
echo ""
echo "❓ Need help?"
echo "  - Check INSTALLATION.md for detailed setup instructions"
echo "  - Check individual plugin READMEs for usage"
echo "  - See CONTRIBUTING.md for customization"
echo ""
echo "Happy coding! 🚀"
