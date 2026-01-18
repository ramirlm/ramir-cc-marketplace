# Development Commands Bundle

Slash commands for common development workflows including CLAUDE.md improvement, feature development, PR creation, and code review.

## Commands Included

### 1. `/improve-claude`
Review and improve CLAUDE.md files based on codebase analysis and best practices.

**Usage**:
```bash
/improve-claude
```

**What it does**:
- Analyzes existing CLAUDE.md file
- Reviews against best practices
- Suggests improvements
- Updates file with enhanced guidelines

**When to use**: Setting up new projects, maintaining coding standards, improving AI assistance quality.

### 2. `/new-feat`
Plan and implement a new feature following CLAUDE.md guidelines with focus on clarity, observability, security, accessibility, and performance.

**Usage**:
```bash
/new-feat [feature-description]
```

**What it does**:
- Creates implementation plan
- Follows coding guidelines
- Implements with best practices
- Includes tests and documentation

**When to use**: Starting new feature development, ensuring consistent implementation quality.

### 3. `/open-pr`
Create and open a pull request with comprehensive summary and test plan.

**Usage**:
```bash
/open-pr
```

**What it does**:
- Analyzes changes since branch divergence
- Generates comprehensive PR description
- Creates test plan
- Opens PR via GitHub CLI

**When to use**: Ready to submit changes for review.

**Prerequisites**:
- GitHub CLI (`gh`) installed and authenticated
- Git repository with remote

### 4. `/review`
Comprehensive code review focusing on clarity, observability, security, accessibility, and performance per CLAUDE.md guidelines.

**Usage**:
```bash
/review [file-or-directory]
```

**What it does**:
- Reviews code against CLAUDE.md standards
- Checks for type safety
- Identifies security issues
- Suggests performance improvements
- Validates accessibility
- Provides actionable feedback

**When to use**: Before committing code, during code review, maintaining code quality.

## Installation

```bash
# Copy plugin to Claude plugins directory
cp -r dev-commands ~/.claude/plugins/

# Enable the plugin
cc --enable-plugin dev-commands
```

## Prerequisites

- **Git**: Version control (for /open-pr)
- **GitHub CLI** (`gh`): For PR creation (for /open-pr)
  ```bash
  # macOS
  brew install gh

  # Authenticate
  gh auth login
  ```

## Usage Examples

### Improve CLAUDE.md

```bash
# Review and improve your project's CLAUDE.md
/improve-claude
```

### Develop New Feature

```bash
# Start new feature with guided implementation
/new-feat Add user authentication with JWT

# Or without arguments for interactive mode
/new-feat
```

### Create Pull Request

```bash
# Create PR with auto-generated description
/open-pr

# Verify changes first
git status
git log origin/main..HEAD
/open-pr
```

### Review Code

```bash
# Review specific file
/review src/components/UserAuth.tsx

# Review entire directory
/review src/components/

# Review current directory
/review
```

## File Structure

```
dev-commands/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── improve-claude.md
│   ├── new-feat.md
│   ├── open-pr.md
│   └── review.md
└── README.md
```

## Customization

Commands are defined in the `commands/` directory. Each command is a Markdown file with YAML frontmatter.

To customize a command:
1. Edit the relevant `.md` file in `commands/`
2. Modify the frontmatter (name, description, allowed-tools)
3. Update the instruction content

Example command structure:
```markdown
---
name: command-name
description: What this command does
allowed-tools: [Read, Write, Bash, Edit]
---

Instructions for Claude on how to execute this command...
```

## Best Practices

1. **CLAUDE.md First**: Run `/improve-claude` when starting new projects
2. **Feature Planning**: Use `/new-feat` for consistent feature implementation
3. **PR Quality**: Always use `/open-pr` for comprehensive PR descriptions
4. **Regular Reviews**: Run `/review` before committing code

## Troubleshooting

### /open-pr fails

1. Verify GitHub CLI is installed and authenticated:
   ```bash
   gh auth status
   ```

2. Ensure you're in a git repository with a remote:
   ```bash
   git remote -v
   ```

3. Make sure you have commits to include in the PR:
   ```bash
   git log origin/main..HEAD
   ```

### Commands not appearing

1. Verify plugin is enabled:
   ```bash
   cc --list-plugins
   ```

2. Restart Claude Code session

3. Check command files are in `commands/` directory

## License

MIT
