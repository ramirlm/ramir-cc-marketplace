# Changelog

All notable changes to this plugin marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-18

### Added

#### personal-workspace-setup v1.0.0
- Security hooks: block-aws-mutations, block-env-reads, block-rm-commands
- Notification hooks: slack-interactive, pushover-notify, slack-notify-error
- Custom statusline with git, model, context usage, and session info
- Environment variable based credential management
- Comprehensive documentation and setup guide

#### coding-skills v1.0.0
- coding-guidelines skill for TypeScript/React best practices
- planning skill for architecture decision-making
- review-changes skill for systematic code review
- writing skill for technical documentation

#### productivity-skills v1.0.0
- file-organizer skill for intelligent file management
- meeting-insights-analyzer skill for behavioral pattern extraction
- prompt-coach skill for Claude Code optimization

#### dev-commands v1.0.0
- /improve-claude command for CLAUDE.md enhancement
- /new-feat command for guided feature implementation
- /open-pr command for comprehensive PR creation
- /review command for code quality assessment

#### e2e-test-agent v1.0.0
- Autonomous e2e test execution agent
- Playwright and Cypress support with auto-detection
- Intelligent failure analysis with screenshots
- Proactive test triggering

#### unit-test-agent v1.0.0
- Autonomous unit test execution agent
- Jest and Vitest support with auto-detection
- Coverage reporting and analysis
- Watch mode support for TDD workflows

### Security
- All credentials moved to environment variables
- No hardcoded secrets in any plugin
- Security hooks prevent dangerous operations by default

### Documentation
- Comprehensive README for each plugin
- Master README with overview and usage
- INSTALLATION.md with step-by-step setup
- marketplace.json for publication

## [Unreleased]

### Planned
- Database migration agent
- API documentation generator
- Performance profiling agent
- Security vulnerability scanner

---

## Version History

- **1.0.0** (2026-01-18) - Initial release with 6 plugins
