# Unit Test Agent

Autonomous agent for unit test execution with automatic framework detection (Jest/Vitest), intelligent failure analysis, and coverage reporting.

## Features

### 🤖 Autonomous Test Execution
- Auto-detects testing framework (Jest or Vitest)
- Runs tests autonomously with proper configuration
- Analyzes failures with detailed context
- Generates coverage reports

### 🔍 Framework Support
- **Jest**: Full support including ts-jest, @swc/jest
- **Vitest**: Full support with built-in TypeScript
- Automatic detection based on project configuration

### 📊 Intelligent Reporting
- Structured test results with pass/fail breakdown
- Detailed failure analysis with expected vs actual
- Coverage reports with actionable insights
- File and line number references

### 🛠️ Failure Analysis
- Assertion mismatches
- Async/await issues
- Mock and spy problems
- Type errors in tests
- Flaky test detection

### 🔄 Watch Mode Support
- TDD workflow with continuous testing
- Real-time feedback on changes
- Focused test re-running

## Installation

```bash
# Copy plugin to Claude plugins directory
cp -r unit-test-agent ~/.claude/plugins/

# Enable the plugin
cc --enable-plugin unit-test-agent
```

## Prerequisites

### For Jest
```bash
npm install -D jest @types/jest
# For TypeScript
npm install -D ts-jest @types/node
```

### For Vitest
```bash
npm install -D vitest
# TypeScript support is built-in
```

### Required Tools
- **Node.js**: For running tests
- **npm/yarn/pnpm**: Package manager

## Usage

The agent triggers automatically when you mention unit testing:

```
"Run the unit tests"
"Execute tests and show coverage"
"I fixed the bug, can you run tests?"
"Run tests in watch mode"
"What's our test coverage?"
```

### Example Interactions

#### Running Tests
```
User: "Run the unit tests"
Agent: *Detects Jest, runs tests, provides detailed report*
```

#### Coverage Analysis
```
User: "What's our test coverage looking like?"
Agent: *Runs tests with coverage, analyzes results*

## Unit Test Results
**Coverage:** 78.5%
**Files Needing Coverage:**
- src/utils/validation.ts: 45% (missing edge cases)
- src/services/payment.ts: 62% (error handling not tested)
```

#### TDD Workflow
```
User: "Run tests in watch mode while I implement the feature"
Agent: *Starts Jest/Vitest in watch mode, reports changes*
```

#### Post-Fix Verification
```
User: "I fixed the authentication bug, verify everything still works"
Agent: *Runs test suite, confirms no regressions*
```

## Output Format

The agent provides structured reports:

```
## Unit Test Results

**Framework:** Jest
**Total Tests:** 42
**Passed:** 40
**Failed:** 2
**Duration:** 3.2s

### ✅ Passed Test Suites
- src/utils/auth.test.ts (5 tests)
- src/components/Button.test.tsx (8 tests)
- src/services/api.test.ts (12 tests)

### ❌ Failed Tests

#### src/utils/validation.test.ts › validateEmail › should reject invalid format
**File:** src/utils/validation.test.ts:23
**Error:**
```
Expected: false
Received: true
```
**Analysis:** The email "user@domain" was accepted but should be rejected (missing TLD). The regex pattern doesn't check for TLD requirement.
**Suggested Fix:** Update regex in src/utils/validation.ts:15 to require TLD: `/^[^\s@]+@[^\s@]+\.[^\s@]+$/`

### 📊 Coverage Report
**Overall:** 78.5%
**Statements:** 245/312 (78.5%)
**Branches:** 42/58 (72.4%)
**Functions:** 67/82 (81.7%)
**Lines:** 238/305 (78.0%)

**Files Needing Coverage:**
- src/utils/validation.ts: 45% (missing edge case tests)
- src/services/payment.ts: 62% (error handling not tested)

### Summary
2 tests failing due to insufficient email validation. Coverage is good but payment error handling needs more tests.
```

## Common Failure Patterns

The agent recognizes and helps fix:

### Assertion Issues
- Expected vs actual mismatches
- Type mismatches
- Deep equality problems

### Async Problems
- Missing await keywords
- Unhandled promises
- Race conditions

### Mock Issues
- Incorrect mock setup
- Spy not being called
- Mock implementation errors

### Type Errors
- TypeScript compilation errors
- Missing type definitions
- Incorrect test types

## Framework Detection

The agent automatically detects your framework:

1. Checks for Vitest config (`vitest.config.ts`)
2. Checks for Jest config (`jest.config.js`)
3. Examines package.json dependencies and scripts
4. Analyzes test file patterns

## Coverage Thresholds

The agent highlights files with coverage below recommended thresholds:

- **Critical (< 70%)**: Red flag, needs immediate attention
- **Warning (70-80%)**: Yellow flag, should improve
- **Good (> 80%)**: Green, acceptable coverage

## Watch Mode

For TDD workflows, the agent supports watch mode:

```
User: "Start tests in watch mode"
Agent: *Runs `jest --watch` or `vitest`*
*Reports only changed test results*
*Provides quick feedback loop*
```

To exit watch mode:
```
User: "Stop watching tests"
Agent: *Gracefully exits watch mode*
```

## Customization

### Custom Test Scripts

If you have custom test scripts in `package.json`, the agent will detect and use them:

```json
{
  "scripts": {
    "test": "jest",
    "test:unit": "vitest run",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

### Test File Patterns

The agent recognizes these patterns:
- `**/*.test.ts` / `**/*.test.js`
- `**/*.spec.ts` / `**/*.spec.js`
- `__tests__/**/*.ts` / `__tests__/**/*.js`

## File Structure

```
unit-test-agent/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── unit-test-runner.md
└── README.md
```

## Troubleshooting

### Agent Not Triggering

Mention testing explicitly:
- "Run unit tests"
- "Execute test suite"
- "Check test coverage"

### Tests Not Running

1. Verify framework is installed:
   ```bash
   ls node_modules/jest       # For Jest
   ls node_modules/vitest     # For Vitest
   ```

2. Check test files exist:
   ```bash
   find . -name "*.test.ts" -o -name "*.spec.ts"
   ```

3. Verify you're in project root

### TypeScript Errors

**For Jest:**
```bash
npm install -D ts-jest @types/jest @types/node
```

**For Vitest:**
TypeScript support is built-in, no additional setup needed.

### Out of Memory

For large test suites:
```bash
# Jest
npx jest --maxWorkers=4

# Vitest
npx vitest --threads=false
```

## Best Practices

1. **Test isolation**: Each test should be independent
2. **Clear test names**: Describe what's being tested
3. **Arrange-Act-Assert**: Structure tests clearly
4. **Mock external dependencies**: Keep tests fast
5. **Test edge cases**: Don't just test happy paths
6. **Maintain coverage**: Aim for > 80% coverage

## Integration with CI/CD

The agent helps debug CI test failures:

```
User: "CI is failing on unit tests"
Agent: *Runs tests locally, analyzes failures, suggests fixes*
```

## License

MIT
