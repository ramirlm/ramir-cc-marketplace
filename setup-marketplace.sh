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

# Ask for confirmation
read -p "Do you want to create a repository 'claude-plugins' under $GITHUB_USERNAME? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled."
    exit 1
fi

# Get repository name
read -p "Enter repository name (default: claude-plugins): " REPO_NAME
REPO_NAME=${REPO_NAME:-claude-plugins}

# Get marketplace name
read -p "Enter marketplace name (default: ramir-personal-marketplace): " MARKETPLACE_NAME
MARKETPLACE_NAME=${MARKETPLACE_NAME:-ramir-personal-marketplace}

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

# Update URLs using sed (macOS compatible)
sed -i '' "s|https://github.com/yourusername/claude-plugins|https://github.com/$GITHUB_USERNAME/$REPO_NAME|g" "$MARKETPLACE_FILE"
sed -i '' "s|ramir-personal-marketplace|$MARKETPLACE_NAME|g" "$MARKETPLACE_FILE"

echo "✅ marketplace.json updated"
echo ""

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

# Create initial commit
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

echo ""
echo "🎉 Success! Your marketplace is published!"
echo ""
echo "📋 Next Steps:"
echo "  1. View your repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "  2. Share with others to install:"
echo "     cc marketplace add https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/marketplace.json"
echo ""
echo "  3. Users can then install plugins:"
echo "     cc install personal-workspace-setup --marketplace=$MARKETPLACE_NAME"
echo ""
echo "📚 Documentation:"
echo "  - Repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "  - Marketplace: https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/marketplace.json"
echo ""
echo "Happy coding! 🚀"
