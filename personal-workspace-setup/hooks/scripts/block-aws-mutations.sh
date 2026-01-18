#!/bin/bash
# Block AWS CLI commands that create, modify, or delete resources
# Exit 2 = block with error message to Claude
# Exit 0 = allow

set -e

# Read JSON from stdin
INPUT=$(cat)

# Extract the command from tool_input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Check if this is an AWS CLI command
if ! echo "$COMMAND" | grep -qE '(^|[;&|]|\s)aws\s'; then
  # Not an AWS command, allow it
  exit 0
fi

# Define mutation verbs (commands that create, modify, or delete resources)
# Read-only verbs are: describe, get, list, head, wait, help
MUTATION_VERBS=(
  "create"
  "delete"
  "remove"
  "update"
  "modify"
  "put"
  "set"
  "add"
  "attach"
  "detach"
  "enable"
  "disable"
  "start"
  "stop"
  "reboot"
  "terminate"
  "deregister"
  "register"
  "associate"
  "disassociate"
  "import"
  "export"
  "copy"
  "move"
  "restore"
  "revoke"
  "authorize"
  "grant"
  "deny"
  "invoke"
  "execute"
  "run"
  "send"
  "publish"
  "subscribe"
  "unsubscribe"
  "cancel"
  "reset"
  "release"
  "allocate"
  "assign"
  "unassign"
  "tag"
  "untag"
  "rotate"
  "replicate"
  "batch"
  "initiate"
  "complete"
  "abort"
  "purge"
  "flush"
  "apply"
  "deploy"
  "undeploy"
  "rollback"
)

# Build regex pattern from mutation verbs
PATTERN=$(printf "|%s" "${MUTATION_VERBS[@]}")
PATTERN="${PATTERN:1}"  # Remove leading |

# Check if the AWS command contains any mutation verb
# This looks for patterns like "aws <service> <mutation-verb>"
if echo "$COMMAND" | grep -qiE "aws\s+\S+\s+($PATTERN)"; then
  echo "🛑 BLOCKED: AWS CLI mutation commands require explicit user approval." >&2
  echo "Command attempted: $COMMAND" >&2
  echo "" >&2
  echo "This command appears to create, modify, or delete AWS resources." >&2
  echo "Read-only commands (describe, get, list) are allowed." >&2
  exit 2
fi

# Allow read-only AWS commands
exit 0
