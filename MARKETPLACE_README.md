# 🚀 Claude Code Plugins Marketplace

**Your complete productivity and development toolkit for Claude Code**

A comprehensive collection of 6 production-ready plugins covering security, productivity, testing, and development workflows.

---

## ⚡ Quick Start

### Install Marketplace

```bash
# Add this marketplace to Claude Code
cc marketplace add https://raw.githubusercontent.com/YOUR_USERNAME/claude-plugins/main/marketplace.json

# List available plugins
cc marketplace list

# Install plugins
cc install personal-workspace-setup
cc install coding-skills
cc install productivity-skills
cc install dev-commands
cc install e2e-test-agent
cc install unit-test-agent
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/claude-plugins.git
cd claude-plugins

# Copy plugins
cp -r personal-workspace-setup ~/.claude/plugins/
cp -r coding-skills ~/.claude/plugins/
# ... (repeat for other plugins)

# Enable plugins
cc --enable-plugin personal-workspace-setup
```

---

## 📦 Plugins Overview

### 🛡️ personal-workspace-setup
**Essential workspace foundation with security and notifications**

**Features:**
- 🔒 Block AWS mutations, .env reads, rm commands
- 📢 Slack interactive Q&A automation
- 🔔 Pushover completion notifications
- 📊 Rich statusline with git, model, context tracking

**Perfect for:** Security-conscious developers, remote workflows, team collaboration

[📖 Full Documentation](./personal-workspace-setup/README.md)

---

### 💻 coding-skills
**Comprehensive coding standards and best practices**

**Includes 4 Skills:**
- `coding-guidelines` - TypeScript/React standards, e2e type-safety
- `planning` - Architecture and design decisions
- `review-changes` - Systematic code review
- `writing` - Technical documentation

**Perfect for:** Maintaining code quality, team standards, consistent style

[📖 Full Documentation](./coding-skills/README.md)

---

### 🚀 productivity-skills
**Enhance personal productivity through automation**

**Includes 3 Skills:**
- `file-organizer` - Intelligent file management
- `meeting-insights-analyzer` - Extract behavioral patterns
- `prompt-coach` - Optimize Claude Code usage

**Perfect for:** Personal productivity, communication improvement, workflow optimization

[📖 Full Documentation](./productivity-skills/README.md)

---

### ⚡ dev-commands
**Streamlined development workflow commands**

**Includes 4 Commands:**
- `/improve-claude` - Enhance CLAUDE.md files
- `/new-feat` - Guided feature implementation
- `/open-pr` - Create comprehensive PRs
- `/review` - Code quality assessment

**Perfect for:** Standardizing workflows, PR quality, code reviews

[📖 Full Documentation](./dev-commands/README.md)

---

### 🤖 e2e-test-agent
**Autonomous end-to-end test execution**

**Features:**
- 🎭 Auto-detects Playwright or Cypress
- 🔍 Intelligent failure analysis
- 📸 Screenshot and trace capture
- 🎯 Proactive test triggering

**Perfect for:** Browser testing, CI debugging, feature verification

[📖 Full Documentation](./e2e-test-agent/README.md)

---

### 🧪 unit-test-agent
**Autonomous unit test execution**

**Features:**
- ⚡ Auto-detects Jest or Vitest
- 📊 Coverage reporting and analysis
- 👁️ Watch mode for TDD workflows
- 🔍 Detailed failure analysis

**Perfect for:** TDD workflows, test coverage, continuous testing

[📖 Full Documentation](./unit-test-agent/README.md)

---

## 🎯 Use Cases

### Security & Compliance
```
✅ personal-workspace-setup
   → Block dangerous operations automatically
   → Prevent .env file exposure
   → Get notified of important events
```

### Code Quality
```
✅ coding-skills + dev-commands
   → Maintain consistent standards
   → Systematic code reviews
   → Comprehensive PR creation
```

### Testing & QA
```
✅ e2e-test-agent + unit-test-agent
   → Autonomous test execution
   → Intelligent failure analysis
   → Coverage tracking
```

### Personal Productivity
```
✅ productivity-skills
   → Organize files intelligently
   → Extract meeting insights
   → Optimize prompts
```

---

## 📋 Prerequisites

### Required (All Plugins)
- **Claude Code** (latest version)
- **jq** - JSON processor
  ```bash
  brew install jq  # macOS
  ```

### Optional (Specific Plugins)

**For personal-workspace-setup:**
- Slack Bot Token (for Slack integration)
- Pushover API Keys (for notifications)

**For dev-commands:**
- GitHub CLI (`gh`)
  ```bash
  brew install gh
  gh auth login
  ```

**For test agents:**
- Jest/Vitest (unit tests)
- Playwright/Cypress (e2e tests)

---

## 🔧 Configuration

### Environment Variables

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Slack (optional)
export SLACK_BOT_TOKEN="xoxb-your-token"
export SLACK_CHANNEL_ID="C0XXXXXXXXX"

# Pushover (optional)
export PUSHOVER_USER_KEY="your-key"
export PUSHOVER_APP_TOKEN="your-token"
```

### Plugin Settings

Each plugin works out of the box with sensible defaults. See individual plugin READMEs for customization options.

---

## 🌟 Highlights

### 🔐 Security First
- Zero hardcoded credentials
- Environment variable based config
- Security hooks prevent dangerous operations
- Proper input validation

### 📚 Comprehensive Documentation
- README for each plugin
- Installation guides
- Usage examples
- Troubleshooting sections

### 🎨 Production Ready
- Tested and working
- Based on real-world usage
- Proper error handling
- Portable across systems

### 🔄 Easy Updates
- Semantic versioning
- Clear changelogs
- Migration guides
- Backwards compatible

---

## 💡 Popular Combinations

### The Essentials
```bash
cc install personal-workspace-setup  # Security & notifications
cc install coding-skills              # Code quality
cc install dev-commands               # Workflow automation
```

### The Testing Suite
```bash
cc install e2e-test-agent            # E2E testing
cc install unit-test-agent           # Unit testing
cc install dev-commands              # PR creation
```

### The Productivity Pack
```bash
cc install personal-workspace-setup  # Notifications & statusline
cc install productivity-skills       # File org & insights
cc install coding-skills             # Standards & planning
```

### The Complete Stack
```bash
# Install all 6 plugins for full power
cc install personal-workspace-setup
cc install coding-skills
cc install productivity-skills
cc install dev-commands
cc install e2e-test-agent
cc install unit-test-agent
```

---

## 📊 Plugin Comparison

| Plugin | Type | Auto-Trigger | User Action | Best For |
|--------|------|--------------|-------------|----------|
| personal-workspace-setup | Hooks | ✅ Always | Configure once | Security |
| coding-skills | Skills | ✅ Context | None | Quality |
| productivity-skills | Skills | ✅ Context | None | Productivity |
| dev-commands | Commands | ❌ Manual | `/command` | Workflows |
| e2e-test-agent | Agent | ✅ Context | Ask to test | E2E Testing |
| unit-test-agent | Agent | ✅ Context | Ask to test | Unit Testing |

---

## 🛠️ Troubleshooting

### Plugins Not Loading
```bash
# Verify installation
ls ~/.claude/plugins/

# Check if enabled
cc --list-plugins

# Restart Claude Code
exit
cc
```

### Hooks Not Working
```bash
# Make scripts executable
chmod +x ~/.claude/plugins/personal-workspace-setup/hooks/scripts/*.sh
chmod +x ~/.claude/plugins/personal-workspace-setup/statusline.sh
```

### Environment Variables
```bash
# Verify they're set
echo $SLACK_BOT_TOKEN
echo $PUSHOVER_USER_KEY

# Reload shell config
source ~/.zshrc
```

See individual plugin READMEs for more troubleshooting.

---

## 📈 Roadmap

Future plugins in development:
- 🗄️ Database migration agent
- 📝 API documentation generator
- ⚡ Performance profiling agent
- 🔍 Security vulnerability scanner
- 🐳 Docker workflow commands

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](./LICENSE) file

---

## 👤 Author

**Ramir Mesquita**
- GitHub: [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)

---

## 🌟 Show Your Support

If these plugins helped you, please:
- ⭐ Star the repository
- 🐛 Report bugs
- 💡 Suggest features
- 🔀 Submit pull requests
- 📢 Share with others

---

## 📚 Resources

- [Installation Guide](./INSTALLATION.md)
- [Publishing Guide](./PUBLISHING.md)
- [Contributing Guide](./CONTRIBUTING.md)
- [Changelog](./CHANGELOG.md)
- [Claude Code Docs](https://docs.anthropic.com/claude-code)

---

**Ready to supercharge your Claude Code workflow?**

```bash
cc marketplace add https://raw.githubusercontent.com/YOUR_USERNAME/claude-plugins/main/marketplace.json
cc install personal-workspace-setup
```

Happy coding! 🚀
