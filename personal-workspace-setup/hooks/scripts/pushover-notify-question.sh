#!/bin/bash
# Pushover notification for AskUserQuestion hook
# Fires as PreToolUse when Claude needs user input

LOG="$HOME/.claude/hook_notify.log"
echo "[$(date)] AskUserQuestion hook fired. PUSHOVER_USER_KEY=${PUSHOVER_USER_KEY:+SET}${PUSHOVER_USER_KEY:-UNSET}" >> "$LOG"

# Credentials - load from shell profiles if not already in environment
if [[ -z "$PUSHOVER_USER_KEY" ]] || [[ -z "$PUSHOVER_APP_TOKEN" ]]; then
  for profile in "$HOME/.zprofile" "$HOME/.zshenv" "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
    if [[ -f "$profile" ]]; then
      while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^export\ PUSHOVER_ ]]; then
          eval "$line" 2>/dev/null || true
        fi
      done < "$profile"
    fi
  done
fi

if [[ -z "$PUSHOVER_USER_KEY" ]] || [[ -z "$PUSHOVER_APP_TOKEN" ]]; then
  echo "[$(date)] Pushover credentials not configured, skipping." >> "$LOG"
  exit 0
fi

# Read stdin (hook context)
input=$(cat)

# Extract question and context
tool_input=$(echo "$input" | jq -r '.tool_input // {}' 2>/dev/null)
question=$(echo "$tool_input" | jq -r '.questions[0].question // "Sua resposta é necessária"' 2>/dev/null)
cwd=$(echo "$input" | jq -r '.cwd // ""' 2>/dev/null)
project_name=$(basename "$cwd" 2>/dev/null || echo "Claude")
session_id=$(echo "$input" | jq -r '.session_id // ""' 2>/dev/null)
short_id="${session_id:0:8}"

title="Claude aguarda resposta: ${project_name} (${short_id})"
message="${question:0:500}"

result=$(curl -s \
    --form-string "token=${PUSHOVER_APP_TOKEN}" \
    --form-string "user=${PUSHOVER_USER_KEY}" \
    --form-string "title=${title}" \
    --form-string "message=${message}" \
    --form-string "priority=1" \
    --form-string "sound=siren" \
    "https://api.pushover.net/1/messages.json" 2>&1 || true)

echo "[$(date)] AskUserQuestion Pushover result: $result" >> "$LOG"

exit 0
