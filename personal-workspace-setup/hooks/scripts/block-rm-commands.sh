#!/bin/bash
# Block rm commands to prevent accidental file deletion
# Exit 2 = block with error message to Claude
# Exit 0 = allow

set -e

# Read JSON from stdin
INPUT=$(cat)

# Extract the command from tool_input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Check if command contains rm with various patterns
# Matches: rm, rm -rf, rm -f, sudo rm, etc.
if echo "$COMMAND" | grep -qE '(^|[;&|]|\s)(sudo\s+)?rm(\s|$)'; then
  echo "🛑 BLOCKED: rm commands are not allowed. File deletion requires explicit user approval." >&2
  echo "Command attempted: $COMMAND" >&2
  exit 2
fi

# Allow the command
exit 0
