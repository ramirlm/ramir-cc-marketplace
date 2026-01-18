# Coding Skills Bundle

Comprehensive skills for software development including coding standards, project planning, code review, and technical writing.

## Skills Included

### 1. Coding Guidelines
Comprehensive coding standards for TypeScript/JavaScript projects with React. Focuses on e2e type-safety, readability, and maintainability.

**When to use**: Writing new code, refactoring, or setting up project structure.

**Key principles**:
- End-to-end type safety
- No `any` types
- Clean imports (no unused)
- Consistent code style

### 2. Planning
Project planning and architecture decision-making workflow. Emphasizes simplicity, type-safety, and avoiding over-engineering.

**When to use**: Starting new projects, designing systems, choosing technologies, making architectural decisions.

**Key principles**:
- Simplicity over complexity
- Type-safety first
- Observability and maintainability
- Avoid over-engineering

### 3. Review Changes
Systematic code review workflow for evaluating changes against coding standards.

**When to use**: Reviewing pull requests, commits, diffs, or code changes before merging.

**Key principles**:
- Type-safety validation
- Maintainability checks
- Readability assessment
- Best practices adherence

### 4. Writing
Clear, concise writing standards for documentation, comments, commit messages, and technical communication.

**When to use**: Writing README files, documentation, PR descriptions, code comments, or any technical writing.

**Key principles**:
- Clarity over cleverness
- Brevity
- Active voice
- Consistent formatting

## Installation

```bash
# Copy plugin to Claude plugins directory
cp -r coding-skills ~/.claude/plugins/

# Enable the plugin
cc --enable-plugin coding-skills
```

## Usage

These skills activate automatically when Claude detects relevant tasks. You can also explicitly invoke them:

- **Coding Guidelines**: Triggered when writing or refactoring code
- **Planning**: Triggered when discussing project architecture or design
- **Review Changes**: Triggered when reviewing code or pull requests
- **Writing**: Triggered when creating documentation or technical content

## Customization

Skills are located in the `skills/` directory. Each skill has its own subdirectory with a `SKILL.md` file and supporting resources.

To customize:
1. Edit the relevant `SKILL.md` file
2. Add examples to the `examples/` subdirectory
3. Add reference documentation to `references/` subdirectory

## File Structure

```
coding-skills/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── coding-guidelines/
│   │   └── SKILL.md
│   ├── planning/
│   │   └── SKILL.md
│   ├── review-changes/
│   │   └── SKILL.md
│   └── writing/
│       └── SKILL.md
└── README.md
```

## License

MIT
