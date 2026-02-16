# Claude Code Plugins Collection

A comprehensive collection of Claude Code plugins for enhanced development workflows, security, productivity, and autonomous testing.

## 📦 Plugins Included

### 1. **personal-workspace-setup** 🛡️
Complete workspace setup with security hooks, notifications, and custom statusline.

**Features:**
- Security hooks (block AWS mutations, .env reads, rm commands)
- Notification system (Slack, Pushover)
- Custom statusline with git, model, context usage
- Zero hardcoded credentials (uses environment variables)

**Use case:** Essential foundation for secure, observable Claude Code workflows.

---

### 2. **coding-skills** 💻
Comprehensive coding standards and best practices.

**Includes:**
- `coding-guidelines` - TypeScript/React standards, e2e type-safety
- `planning` - Architecture and design decision-making
- `review-changes` - Code review workflow and standards
- `writing` - Technical documentation and communication

**Use case:** Maintain consistent code quality across projects.

---

### 3. **productivity-skills** 🚀
Productivity enhancement through automation and analysis.

**Includes:**
- `file-organizer` - Intelligent file and folder organization
- `meeting-insights-analyzer` - Extract behavioral patterns from meetings
- `prompt-coach` - Improve Claude Code prompt quality

**Use case:** Optimize personal productivity and communication.

---

### 4. **dev-commands** ⚡
Development workflow slash commands.

**Includes:**
- `/improve-claude` - Enhance CLAUDE.md files
- `/new-feat` - Guided feature implementation
- `/open-pr` - Create comprehensive pull requests
- `/review` - Code quality review

**Use case:** Streamline common development tasks.

---

### 5. **e2e-test-agent** 🤖
Autonomous end-to-end test execution.

**Features:**
- Auto-detects Playwright or Cypress
- Runs tests autonomously
- Intelligent failure analysis
- Screenshot and trace capture

**Use case:** Automated browser testing and debugging.

---

### 6. **unit-test-agent** 🧪
Autonomous unit test execution.

**Features:**
- Auto-detects Jest or Vitest
- Coverage reporting
- Watch mode support
- Detailed failure analysis

**Use case:** TDD workflows and test coverage analysis.

---

## 🚀 Quick Start

### Install All Plugins

```bash
# Copy all plugins to Claude Code plugins directory
cp -r ~/claude-plugins/* ~/.claude/plugins/

# Or install individually
cp -r ~/claude-plugins/personal-workspace-setup ~/.claude/plugins/
```

### Enable Plugins

```bash
# Enable all plugins
cc --enable-plugin personal-workspace-setup
cc --enable-plugin coding-skills
cc --enable-plugin productivity-skills
cc --enable-plugin dev-commands
cc --enable-plugin e2e-test-agent
cc --enable-plugin unit-test-agent

# Or enable via settings UI
cc settings
```

## 📋 Prerequisites

### Global Requirements
- **Node.js** (v18+)
- **jq** - JSON processor
  ```bash
  brew install jq  # macOS
  ```

### For personal-workspace-setup
- **Slack Bot Token** (optional, for Slack integration)
- **Pushover API Keys** (optional, for notifications)

### For dev-commands
- **GitHub CLI** (`gh`) - For PR creation
  ```bash
  brew install gh
  gh auth login
  ```

### For test agents
- **Jest** or **Vitest** (unit tests)
- **Playwright** or **Cypress** (e2e tests)

## 🔧 Configuration

### Environment Variables

Create a `.env` file or add to your shell profile (~/.zshrc):

```bash
# Slack integration (for personal-workspace-setup)
export SLACK_BOT_TOKEN="xoxb-your-token"
export SLACK_CHANNEL_ID="C0XXXXXXXXX"

# Pushover notifications (for personal-workspace-setup)
export PUSHOVER_USER_KEY="your-user-key"
export PUSHOVER_APP_TOKEN="your-app-token"
```

### Settings Configuration

The personal-workspace-setup plugin configures:
- Custom statusline
- Security hooks
- Notification hooks

No additional configuration needed for other plugins.

## 📚 Usage Examples

### Security with personal-workspace-setup

```bash
# ✅ Allowed
aws s3 ls
git status

# 🛑 Blocked automatically
aws s3 rm s3://bucket/file  # Blocked: AWS mutation
rm -rf directory/           # Blocked: rm command
# Reading .env files blocked via Read tool
```

### Development with coding-skills + dev-commands

```bash
# Improve project standards
/improve-claude

# Implement new feature with guided workflow
/new-feat Add payment integration

# Create comprehensive PR
/open-pr

# Review code quality
/review src/components/
```

### Testing with test agents

```bash
# Unit tests
"Run the unit tests"
"What's our test coverage?"
"Run tests in watch mode"

# E2E tests
"Run the e2e tests"
"The CI is failing on e2e tests, investigate"
"I finished the checkout flow, verify it works"
```

## 📁 File Structure

```
claude-plugins/
├── README.md                          # This file
├── personal-workspace-setup/
│   ├── .claude-plugin/plugin.json
│   ├── hooks/
│   │   ├── hooks.json
│   │   └── scripts/
│   ├── statusline.sh
│   └── README.md
├── coding-skills/
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   │   ├── coding-guidelines/
│   │   ├── planning/
│   │   ├── review-changes/
│   │   └── writing/
│   └── README.md
├── productivity-skills/
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   │   ├── file-organizer/
│   │   ├── meeting-insights-analyzer/
│   │   └── prompt-coach/
│   └── README.md
├── dev-commands/
│   ├── .claude-plugin/plugin.json
│   ├── commands/
│   │   ├── improve-claude.md
│   │   ├── new-feat.md
│   │   ├── open-pr.md
│   │   └── review.md
│   └── README.md
├── e2e-test-agent/
│   ├── .claude-plugin/plugin.json
│   ├── agents/
│   │   └── e2e-test-runner.md
│   └── README.md
└── unit-test-agent/
    ├── .claude-plugin/plugin.json
    ├── agents/
    │   └── unit-test-runner.md
    └── README.md
```

## 🔍 Plugin Details

| Plugin | Type | Components | Auto-Trigger |
|--------|------|------------|--------------|
| personal-workspace-setup | Hooks + Statusline | 6 hook scripts, statusline | Always active |
| coding-skills | Skills | 4 skills | Context-based |
| productivity-skills | Skills | 3 skills | Context-based |
| dev-commands | Commands | 4 commands | User-invoked |
| e2e-test-agent | Agent | 1 agent | Context-based |
| unit-test-agent | Agent | 1 agent | Context-based |

## 🛠️ Customization

Each plugin can be customized independently:

- **Hooks**: Edit `hooks/hooks.json` and hook scripts
- **Skills**: Modify `SKILL.md` files in skill directories
- **Commands**: Edit `.md` files in commands directory
- **Agents**: Modify agent `.md` files in agents directory

## 🐛 Troubleshooting

### Plugins Not Loading

```bash
# Verify plugins are in correct location
ls ~/.claude/plugins/

# Check if enabled
cc --list-plugins

# Restart Claude Code
exit  # Exit current session
cc    # Start new session
```

### Hooks Not Working

```bash
# Check hook scripts are executable
ls -la ~/.claude/plugins/personal-workspace-setup/hooks/scripts/

# Make executable if needed
chmod +x ~/.claude/plugins/personal-workspace-setup/hooks/scripts/*.sh
```

### Environment Variables Not Set

```bash
# Verify environment variables
echo $SLACK_BOT_TOKEN
echo $PUSHOVER_USER_KEY

# Source your shell profile
source ~/.zshrc  # or ~/.bashrc
```

## 📊 Best Practices

1. **Start with personal-workspace-setup**: Foundation for secure workflows
2. **Enable coding-skills early**: Maintain quality from day one
3. **Use dev-commands for consistency**: Standardize common workflows
4. **Let agents work autonomously**: Trust test agents to run and analyze
5. **Customize gradually**: Start with defaults, customize as needed

## 🔒 Security Notes

- **No hardcoded credentials**: All secrets via environment variables
- **Hook validation**: Security hooks prevent dangerous operations
- **Least privilege**: Agents have minimal tool access needed
- **Credential isolation**: Slack/Pushover tokens in environment only

## 📝 License

All plugins: MIT License

## 👤 Author

Ramir Mesquita

## 🤝 Contributing

### Creating New Plugins

Use the plugin template generator to quickly scaffold new plugins:

```bash
# Interactive mode - prompts for all details
./create-plugin.sh

# Non-interactive mode - specify all parameters
./create-plugin.sh --name "my-agent" --type agent --category automation --description "My autonomous agent"
```

**Plugin Types:**
- `agent` - Autonomous agents
- `skill` - Step-by-step skills
- `dev-command` - Development commands

**Categories:**
- `coding` - Code development
- `productivity` - Productivity tools
- `testing` - Testing frameworks
- `security` - Security tools
- `automation` - Automation workflows

**Generated Structure:**
The generator creates:
- Plugin directory with proper structure
- `plugin.json` with metadata
- README.md with examples
- CHANGELOG.md
- Type-specific templates (agents/, skills/, or commands/)
- Automatic marketplace.json update

**Example Usage:**
```bash
# Create a testing agent
./create-plugin.sh --name "api-test-agent" --type agent --category testing

# Create a code review skill
./create-plugin.sh --name "code-review-skill" --type skill --category coding

# Create a refactoring command
./create-plugin.sh --name "refactor-command" --type dev-command --category coding
```

For more details, run:
```bash
./create-plugin.sh --help
```

### Contributing Guidelines

To contribute or report issues:
1. Use the plugin generator for new plugins
2. Test plugins thoroughly
3. Follow existing patterns
4. Document changes
5. Update READMEs

## 🚦 Roadmap

Potential future plugins:
- Database migration agent
- API documentation generator
- Performance profiling agent
- Security vulnerability scanner

## 📖 Additional Resources

- Each plugin has its own detailed README
- See individual plugin directories for specific documentation
- Check Claude Code docs: https://docs.anthropic.com/claude-code
