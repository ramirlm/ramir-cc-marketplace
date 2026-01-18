# Publishing to Claude Code Marketplace

Complete guide to publishing your plugin collection to Claude Code marketplace.

## 📋 Prerequisites

Before publishing, ensure:

- ✅ All plugins tested and working
- ✅ Documentation complete (README for each plugin)
- ✅ No hardcoded credentials
- ✅ marketplace.json properly configured
- ✅ LICENSE file present
- ✅ .gitignore configured

## 🚀 Publication Methods

### Method 1: GitHub Repository (Recommended)

This is the most common and recommended method for sharing Claude Code plugins.

#### Step 1: Create GitHub Repository

```bash
# 1. Initialize git in your plugins directory
cd ~/claude-plugins
git init

# 2. Add all files
git add .

# 3. Commit
git commit -m "Initial commit: Claude Code plugins collection"

# 4. Create GitHub repository (via gh CLI)
gh repo create claude-plugins --public --source=. --remote=origin --push

# Or create manually on GitHub and push
# git remote add origin https://github.com/yourusername/claude-plugins.git
# git branch -M main
# git push -u origin main
```

#### Step 2: Update marketplace.json

Replace placeholder URLs in `marketplace.json`:

```json
{
  "repository": "https://github.com/YOUR_USERNAME/claude-plugins",
  "plugins": [
    {
      "repository": "https://github.com/YOUR_USERNAME/claude-plugins/tree/main/personal-workspace-setup",
      ...
    }
  ]
}
```

Update with your actual GitHub username.

#### Step 3: Create Release

```bash
# Tag version
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# Or create release via GitHub CLI
gh release create v1.0.0 \
  --title "v1.0.0 - Initial Release" \
  --notes "Complete plugin collection with 6 plugins"
```

#### Step 4: Share Your Marketplace

Users can now install from your marketplace:

```bash
# Users add your marketplace
cc marketplace add https://raw.githubusercontent.com/YOUR_USERNAME/claude-plugins/main/marketplace.json

# Then install plugins
cc install personal-workspace-setup --marketplace=ramir-personal-marketplace
```

---

### Method 2: Official Claude Code Marketplace

To submit to the official Claude Code marketplace:

#### Step 1: Prepare Submission

1. **Create individual plugin repositories** (optional but recommended):
   ```bash
   # For each plugin, you can create a separate repo
   cd ~/claude-plugins/personal-workspace-setup
   git init
   gh repo create personal-workspace-setup --public
   ```

2. **Ensure quality standards**:
   - Comprehensive documentation
   - Working examples
   - No security issues
   - Proper error handling

#### Step 2: Submit to Official Marketplace

1. Visit Claude Code marketplace submission page
2. Submit marketplace.json or individual plugin manifests
3. Follow their review process

**Note**: Check official Claude Code documentation for current submission process.

---

### Method 3: NPM Package (Alternative)

Publish as npm packages for easy installation:

#### For Each Plugin:

```bash
cd ~/claude-plugins/personal-workspace-setup

# 1. Create package.json
npm init -y

# 2. Update package.json
# Add: "name": "@your-scope/personal-workspace-setup"
#      "version": "1.0.0"
#      "description": "..."
#      "keywords": ["claude-code-plugin", ...]

# 3. Publish to npm
npm publish --access public
```

#### Users Install via NPM:

```bash
npm install -g @your-scope/personal-workspace-setup
# Plugin installs to node_modules, then copy to ~/.claude/plugins/
```

---

## 📝 Marketplace Configuration

### marketplace.json Structure

Your `marketplace.json` defines the entire plugin collection:

```json
{
  "name": "your-marketplace-id",
  "displayName": "Your Marketplace Name",
  "description": "Description of your plugin collection",
  "author": {
    "name": "Your Name",
    "email": "your@email.com",
    "url": "https://yourwebsite.com"
  },
  "repository": "https://github.com/yourusername/claude-plugins",
  "plugins": [
    {
      "id": "plugin-name",
      "name": "Plugin Display Name",
      "version": "1.0.0",
      "description": "Plugin description",
      "category": "productivity",
      "featured": true,
      "requirements": {
        "tools": ["required-tool"],
        "optional": ["optional-dependency"]
      }
    }
  ]
}
```

### Categories

Available categories:
- `productivity` - Productivity tools
- `development` - Development workflows
- `testing` - Testing and QA
- `security` - Security tools
- `documentation` - Documentation tools
- `utilities` - General utilities

### Featured Plugins

Mark your best plugins as `featured: true` to highlight them.

---

## 🎨 Best Practices

### Documentation

1. **README Quality**:
   - Clear installation instructions
   - Usage examples with code blocks
   - Prerequisites section
   - Troubleshooting guide
   - Screenshots/GIFs if applicable

2. **Version Documentation**:
   - Maintain CHANGELOG.md
   - Document breaking changes
   - Follow semantic versioning

3. **Code Comments**:
   - Comment complex logic
   - Explain why, not what
   - Keep comments up to date

### Security

1. **No Credentials**:
   - Never commit API keys, tokens, passwords
   - Use environment variables
   - Document required env vars

2. **Input Validation**:
   - Validate all hook inputs
   - Sanitize user input
   - Handle errors gracefully

3. **Minimal Permissions**:
   - Request only needed tools
   - Explain why each tool is needed
   - Follow principle of least privilege

### Quality

1. **Testing**:
   - Test all plugins before publishing
   - Test on clean system
   - Verify installation process

2. **Dependencies**:
   - Document all prerequisites
   - Keep dependencies minimal
   - Specify version requirements

3. **Backwards Compatibility**:
   - Don't break existing functionality
   - Deprecate gracefully
   - Document migration paths

---

## 🔄 Updating Plugins

### Release Process

1. **Make Changes**:
   ```bash
   # Edit plugin files
   # Test thoroughly
   ```

2. **Update Version**:
   ```bash
   # Update version in plugin.json
   # Update CHANGELOG.md
   ```

3. **Commit and Tag**:
   ```bash
   git add .
   git commit -m "Version 1.1.0: Add new feature"
   git tag -a v1.1.0 -m "Version 1.1.0"
   git push origin main --tags
   ```

4. **Create Release**:
   ```bash
   gh release create v1.1.0 \
     --title "v1.1.0 - Feature Update" \
     --notes-file CHANGELOG.md
   ```

### Version Numbers

Follow semantic versioning:
- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (0.1.0): New features, backwards compatible
- **PATCH** (0.0.1): Bug fixes

---

## 📢 Promoting Your Plugins

### Share on Social Media

- Twitter/X: Share with #ClaudeCode hashtag
- LinkedIn: Post in developer groups
- Reddit: r/ClaudeCode or relevant subreddits
- Dev.to: Write tutorial articles

### Create Content

- Write blog posts about your plugins
- Create video tutorials
- Share use cases and workflows
- Highlight unique features

### Community Engagement

- Respond to issues promptly
- Accept pull requests
- Help users in discussions
- Share updates and improvements

---

## 📊 Monitoring

### GitHub Insights

Track:
- Stars and forks
- Issues and PRs
- Traffic and clones
- Popular plugins

### User Feedback

- Monitor GitHub issues
- Read user comments
- Gather feature requests
- Track bug reports

---

## 🎯 Next Steps

1. **Choose Publication Method**: GitHub, Official Marketplace, or NPM
2. **Create Repository**: Set up GitHub repo with your plugins
3. **Update URLs**: Replace placeholders in marketplace.json
4. **Test Installation**: Verify users can install from your marketplace
5. **Announce**: Share your plugins with the community
6. **Maintain**: Keep plugins updated and respond to issues

---

## 📚 Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Plugin Development Guide](https://docs.anthropic.com/claude-code/plugins)
- [Marketplace Guidelines](https://docs.anthropic.com/claude-code/marketplace)
- [Semantic Versioning](https://semver.org/)

---

## ✅ Pre-Publication Checklist

Before publishing, verify:

- [ ] All plugins tested and working
- [ ] README.md for each plugin
- [ ] marketplace.json properly configured
- [ ] No hardcoded credentials
- [ ] LICENSE file present
- [ ] .gitignore configured
- [ ] CHANGELOG.md updated
- [ ] GitHub repository created
- [ ] URLs updated in marketplace.json
- [ ] Release created with proper version tag
- [ ] Installation tested from marketplace

---

**Ready to publish?** Follow the steps above and share your amazing plugins with the Claude Code community! 🚀
