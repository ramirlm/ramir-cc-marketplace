# E2E Test Agent

Autonomous agent for end-to-end test execution with automatic framework detection (Playwright/Cypress) and intelligent failure analysis.

## Features

### 🤖 Autonomous Test Execution
- Auto-detects testing framework (Playwright or Cypress)
- Runs tests autonomously with no manual intervention
- Captures failures, screenshots, and traces
- Provides detailed failure analysis

### 🔍 Framework Support
- **Playwright**: Full support for @playwright/test
- **Cypress**: Full support for Cypress e2e tests
- Automatic detection based on project configuration

### 📊 Intelligent Reporting
- Structured test results with pass/fail breakdown
- Detailed failure analysis with line numbers
- Screenshot and trace references
- Actionable fix suggestions

### 🛠️ Failure Analysis
- Identifies common failure patterns
- Suggests specific fixes for each failure
- Groups related failures
- Detects flaky tests

## Installation

```bash
# Copy plugin to Claude plugins directory
cp -r e2e-test-agent ~/.claude/plugins/

# Enable the plugin
cc --enable-plugin e2e-test-agent
```

## Prerequisites

### For Playwright
```bash
npm install -D @playwright/test
npx playwright install
```

### For Cypress
```bash
npm install -D cypress
npx cypress open  # Run once for initial setup
```

### Required Tools
- **Node.js**: For running tests
- **jq**: For JSON processing (usually pre-installed)

## Usage

The agent triggers automatically when you mention e2e testing:

```
"Run the e2e tests"
"Execute end-to-end tests and report results"
"The CI is failing on e2e tests, can you investigate?"
"I finished the checkout flow, verify it works end-to-end"
```

### Example Interactions

#### Running Tests
```
User: "Run the e2e tests and let me know if anything fails"
Agent: *Detects Playwright, runs tests, provides detailed report*
```

#### Post-Feature Verification
```
User: "I've finished implementing user authentication"
Agent: "I'll run the e2e tests to verify the authentication flow works correctly"
*Runs relevant tests and reports results*
```

#### Debugging CI Failures
```
User: "CI is failing on e2e tests"
Agent: *Runs tests locally, analyzes failures, suggests fixes*
```

## Output Format

The agent provides structured reports:

```
## E2E Test Results

**Framework:** Playwright
**Total Tests:** 15
**Passed:** 13
**Failed:** 2
**Duration:** 2m 34s

### ✅ Passed Tests
- user-login.spec.ts: successful login
- user-login.spec.ts: failed login attempt
[...]

### ❌ Failed Tests

#### checkout-flow.spec.ts: complete purchase
**File:** tests/checkout-flow.spec.ts:45
**Error:** Timeout 30000ms exceeded waiting for element
**Analysis:** The payment button selector 'button[type="submit"]' was not found. The DOM shows the button has class 'payment-submit-btn' instead.
**Suggested Fix:** Update selector to 'button.payment-submit-btn' in line 45
**Screenshot:** test-results/checkout-flow/checkout-complete-purchase.png

[...]

### Summary
2 tests failed due to selector issues after recent UI refactoring. Update selectors to match new class names.
```

## Common Failure Patterns

The agent recognizes and helps fix:

### Selector Issues
- Element not found
- Outdated selectors after UI changes
- Timing-dependent selectors

### Timeout Problems
- Slow network requests
- Missing wait conditions
- Insufficient timeout values

### Flaky Tests
- Race conditions
- Timing issues
- Non-deterministic behavior

### State Issues
- Test isolation problems
- Database state pollution
- Missing cleanup

## Framework Detection

The agent automatically detects your framework:

1. Checks for Playwright config (`playwright.config.ts`)
2. Checks for Cypress config (`cypress.config.ts`)
3. Examines package.json dependencies
4. Analyzes test directory structure

If both frameworks exist, it prefers the one with more recent test files.

## Customization

### Custom Test Scripts

If you have custom test scripts in `package.json`, the agent will detect and use them:

```json
{
  "scripts": {
    "test:e2e": "playwright test --project=chromium",
    "test:e2e:headed": "playwright test --headed"
  }
}
```

### Environment Variables

Set required environment variables before running tests:

```bash
export TEST_API_URL=https://api.staging.example.com
export TEST_USER_EMAIL=test@example.com
```

The agent will detect missing environment variables and notify you.

## File Structure

```
e2e-test-agent/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── e2e-test-runner.md
└── README.md
```

## Troubleshooting

### Agent Not Triggering

Make sure you mention e2e testing explicitly:
- "Run e2e tests"
- "Execute end-to-end tests"
- "Verify with browser tests"

### Tests Not Running

1. Verify framework is installed:
   ```bash
   ls node_modules/@playwright/test  # For Playwright
   ls node_modules/cypress           # For Cypress
   ```

2. Check test files exist:
   ```bash
   find . -name "*.spec.ts" -o -name "*.spec.js"
   ```

3. Ensure you're in project root directory

### Missing Screenshots

- **Playwright**: Check `test-results/` directory
- **Cypress**: Check `cypress/screenshots/` directory

## Best Practices

1. **Keep tests isolated**: Each test should be independent
2. **Use data-testid**: More reliable than CSS selectors
3. **Proper waits**: Use framework wait methods, not fixed delays
4. **Clear test names**: Describe what's being tested
5. **Regular cleanup**: Reset state between tests

## License

MIT
