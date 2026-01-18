---
description: Review and improve CLAUDE.md files based on codebase analysis and best practices
allowed-tools: Bash(git:*), Bash(find:*), Bash(ls:*)
---

# CLAUDE.md Improvement Analysis

Analyze the project and improve CLAUDE.md files with relevant, actionable instructions.

## Analysis Process:

1. **Current State Review**
   - Read existing CLAUDE.md files (root, .claude/, .claude/rules/)
   - Identify what's documented vs what's missing
   - Check for outdated or incorrect instructions

2. **Codebase Discovery**
   - Analyze project structure (directories, key files)
   - Identify tech stack (languages, frameworks, tools)
   - Review package.json, tsconfig.json, or equivalent configs
   - Check for existing linting/formatting rules (eslint, prettier)

3. **Pattern Extraction**
   - Identify naming conventions in use
   - Document file organization patterns
   - Extract common code patterns and idioms
   - Note testing conventions and structure

4. **Gap Analysis**
   - Compare documented rules vs actual practices
   - Identify undocumented conventions being followed
   - Find contradictions between docs and code
   - List missing critical instructions

5. **Improvement Recommendations**
   - Add missing conventions discovered in codebase
   - Remove outdated or contradictory instructions
   - Improve clarity and specificity of existing rules
   - Suggest modular organization if file is large

## Output Format:

### Current CLAUDE.md Assessment
- **Completeness**: [Score 1-10]
- **Accuracy**: [Score 1-10]
- **Actionability**: [Score 1-10]

### Discovered Patterns (Not Documented)
- [List patterns found in code but missing from CLAUDE.md]

### Outdated/Incorrect Instructions
- [List instructions that don't match current codebase]

### Recommended Additions
```markdown
[Provide exact markdown to add]
```

### Recommended Removals
- [List items to remove with reasoning]

### Suggested Reorganization
- [If applicable, suggest splitting into .claude/rules/]

### Updated CLAUDE.md
[Provide the complete improved CLAUDE.md content]

## Best Practices to Enforce:
- Be specific: "Use 2-space indentation" not "Format properly"
- Be actionable: Instructions Claude can follow, not philosophy
- Be current: Match what the codebase actually does
- Be concise: Remove redundant or obvious instructions
- Use imports: Reference existing docs with @path/to/file
