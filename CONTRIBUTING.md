# Contributing to Claude Code Plugins

Thank you for your interest in contributing to this plugin collection!

## 🤝 How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (OS, Claude Code version, etc.)
   - Relevant logs or screenshots

### Suggesting Enhancements

1. Check if the enhancement has been suggested
2. Create a new issue with:
   - Clear description of the enhancement
   - Use cases and benefits
   - Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 Code Standards

### Plugin Development

Follow these standards when creating or modifying plugins:

#### Directory Structure
- Use kebab-case for all directories and files
- Place plugin.json in `.claude-plugin/` directory
- Organize components in standard directories (commands/, agents/, skills/, hooks/)

#### Naming Conventions
- **Plugins**: kebab-case (e.g., `my-plugin-name`)
- **Commands**: kebab-case (e.g., `my-command.md`)
- **Agents**: kebab-case (e.g., `my-agent.md`)
- **Skills**: kebab-case directories (e.g., `my-skill/`)

#### Documentation
- Every plugin MUST have a comprehensive README.md
- Include installation instructions
- Provide usage examples
- Document configuration options
- Add troubleshooting section

#### Security
- NEVER hardcode credentials
- Use environment variables for all secrets
- Document required environment variables
- Use `${CLAUDE_PLUGIN_ROOT}` for portable paths
- Implement proper input validation in hooks

#### Code Quality
- No unused imports
- Never use TypeScript `any` type
- Write clear, descriptive comments
- Follow existing code patterns in the repository

### Hook Scripts

- Start with shebang (`#!/bin/bash`)
- Add clear description comment at top
- Use `set -e` for error handling
- Validate inputs properly
- Exit with proper codes (0 = allow, 2 = block for PreToolUse)
- Make scripts executable (`chmod +x`)

### Agent Development

- Include 2-4 triggering examples in description
- Write clear, structured system prompts
- Define concrete responsibilities
- Specify output format
- Handle edge cases
- Use appropriate model (usually `inherit`)
- Limit tools to minimum needed

### Skills

- Write in third-person for description
- Use imperative form in body
- Keep body lean (1,500-2,000 words)
- Use progressive disclosure (references/, examples/)
- Include strong trigger phrases
- Provide working examples

### Commands

- Write instructions FOR Claude, not TO user
- Include clear argument-hint
- Specify minimal allowed-tools
- Provide usage examples
- Document expected behavior

## 🧪 Testing

Before submitting:

1. **Test plugin installation**
   ```bash
   cp -r plugin-name ~/.claude/plugins/
   cc --enable-plugin plugin-name
   ```

2. **Test functionality**
   - Verify all components load
   - Test triggering conditions
   - Validate outputs
   - Check error handling

3. **Test documentation**
   - Follow your own README
   - Verify all steps work
   - Check for broken links
   - Test code examples

4. **Validate structure**
   - Proper plugin.json format
   - All required files present
   - Scripts are executable
   - No hardcoded secrets

## 📋 Checklist for New Plugins

- [ ] Created `.claude-plugin/plugin.json` with required fields
- [ ] Written comprehensive README.md
- [ ] All scripts are executable (`chmod +x`)
- [ ] No hardcoded credentials
- [ ] Used `${CLAUDE_PLUGIN_ROOT}` for paths
- [ ] Tested installation process
- [ ] Tested functionality
- [ ] Added to marketplace.json
- [ ] Updated CHANGELOG.md
- [ ] Included usage examples
- [ ] Documented prerequisites
- [ ] Added troubleshooting section

## 🔍 Code Review Process

Pull requests will be reviewed for:

1. **Functionality**: Does it work as intended?
2. **Security**: No credentials, proper validation
3. **Documentation**: Clear and complete
4. **Code Quality**: Follows standards
5. **Testing**: Properly tested
6. **Compatibility**: Works with Claude Code

## 💡 Plugin Ideas

Looking for contribution ideas? Consider:

- Database migration agent
- API documentation generator
- Performance profiling agent
- Security vulnerability scanner
- Docker workflow commands
- Git workflow enhancements
- CI/CD integration plugins

## 📞 Getting Help

- Check existing documentation
- Search Issues for similar questions
- Create a new issue with your question
- Be specific and provide context

## 🎯 Best Practices

1. **Start small**: Begin with simple contributions
2. **Follow patterns**: Look at existing plugins for examples
3. **Ask questions**: Don't hesitate to ask for clarification
4. **Be patient**: Reviews take time
5. **Iterate**: Expect feedback and be ready to improve

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for making these plugins better! 🚀
