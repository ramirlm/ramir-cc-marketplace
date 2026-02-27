#!/bin/bash
# Block reading .env files to prevent exposure of secrets
# Exit 2 = block with error message to Claude
# Exit 0 = allow

set -e

# Read JSON from stdin
INPUT=$(cat)

# Extract the file path from tool_input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Get just the filename
FILENAME=$(basename "$FILE_PATH")

# Check if file matches .env* pattern (case insensitive)
# Matches: .env, .env.local, .env.production, .env.development, etc.
if echo "$FILENAME" | grep -qiE '^\.env($|\.)'; then
  echo "🛑 BLOCKED: Reading .env files is not allowed. These files may contain secrets." >&2
  echo "File attempted: $FILE_PATH" >&2
  exit 2
fi

# Allow the read
exit 0
