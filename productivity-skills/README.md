# Productivity Skills Bundle

Skills to enhance personal productivity through file organization, meeting insights, and prompt optimization.

## Skills Included

### 1. File Organizer
Intelligently organizes files and folders across your computer by understanding context, finding duplicates, suggesting better structures, and automating cleanup tasks.

**When to use**: Managing messy directories, organizing downloads, cleaning up projects, structuring codebases.

**Capabilities**:
- Context-aware file organization
- Duplicate detection and removal
- Smart folder structure suggestions
- Automated cleanup workflows

### 2. Meeting Insights Analyzer
Analyzes meeting transcripts and recordings to uncover behavioral patterns, communication insights, and actionable feedback.

**When to use**: After meetings, for communication improvement, leadership development, behavioral pattern analysis.

**Capabilities**:
- Identifies conflict avoidance patterns
- Detects filler words and speech patterns
- Analyzes conversation dominance
- Highlights listening opportunities
- Provides actionable communication feedback

### 3. Prompt Coach
Analyzes Claude Code session logs to improve prompt quality, optimize tool usage, and develop better AI-native engineering skills.

**When to use**: Improving your Claude Code prompts, learning best practices, optimizing workflows, debugging sessions.

**Capabilities**:
- Prompt quality analysis
- Tool usage optimization
- Pattern identification
- Best practice recommendations
- Session efficiency insights

## Installation

```bash
# Copy plugin to Claude plugins directory
cp -r productivity-skills ~/.claude/plugins/

# Enable the plugin
cc --enable-plugin productivity-skills
```

## Usage

### File Organizer

```
"Help me organize my Downloads folder"
"Find duplicate files in this directory"
"Suggest a better folder structure for this project"
```

### Meeting Insights Analyzer

```
"Analyze this meeting transcript for communication patterns"
"What behavioral insights can you extract from this recording?"
"How can I improve my communication based on this meeting?"
```

### Prompt Coach

```
"Review my recent Claude Code sessions"
"How can I improve my prompts?"
"Analyze my tool usage patterns"
```

## File Structure

```
productivity-skills/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── file-organizer/
│   │   └── SKILL.md
│   ├── meeting-insights-analyzer/
│   │   └── SKILL.md
│   └── prompt-coach/
│       └── SKILL.md
└── README.md
```

## Customization

Each skill can be customized by editing its `SKILL.md` file in the `skills/` directory.

## License

MIT
