#!/bin/bash
# Pushover notification hook for Claude Code
# Sends notification with context when Claude stops
# Cross-platform (macOS + Linux)

LOG="$HOME/.claude/hook_notify.log"
echo "[$(date)] Stop hook fired. PUSHOVER_USER_KEY=${PUSHOVER_USER_KEY:+SET}${PUSHOVER_USER_KEY:-UNSET}" >> "$LOG"

# Credentials - load from shell profiles if not already in environment
if [[ -z "$PUSHOVER_USER_KEY" ]] || [[ -z "$PUSHOVER_APP_TOKEN" ]]; then
  for profile in "$HOME/.local.zsh" "$HOME/.zprofile" "$HOME/.zshenv" "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
    if [[ -f "$profile" ]]; then
      while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^export\ PUSHOVER_ ]]; then
          eval "$line" 2>/dev/null || true
        fi
      done < "$profile"
    fi
  done
fi

# Check if credentials are set
if [[ -z "$PUSHOVER_USER_KEY" ]] || [[ -z "$PUSHOVER_APP_TOKEN" ]]; then
  echo "[$(date)] Pushover credentials not configured, skipping." >> "$LOG"
  exit 0
fi

# Read stdin (hook context)
input=$(cat)

# Extract info from hook context
stop_reason=$(echo "$input" | jq -r '.stop_reason // .stop_hook_name // "unknown"' 2>/dev/null || echo "unknown")
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""' 2>/dev/null || echo "")
cwd=$(echo "$input" | jq -r '.cwd // ""' 2>/dev/null || echo "$PWD")
project_name=$(basename "$cwd" 2>/dev/null || echo "project")

# Get conversation name and last assistant message from transcript (JSONL format)
last_message=""
conversation_name=""
if [[ -n "$transcript_path" ]] && [[ -f "$transcript_path" ]]; then
    # Get conversation name from custom-title entry
    conversation_name=$(grep '"type":"custom-title"' "$transcript_path" 2>/dev/null | tail -1 | jq -r '.customTitle // empty' 2>/dev/null || echo "")

    # Cross-platform reverse: tac (Linux) or tail -r (macOS)
    if command -v tac &>/dev/null; then
        reverse_cmd="tac"
    else
        reverse_cmd="tail -r"
    fi
    last_message=$($reverse_cmd "$transcript_path" 2>/dev/null | while IFS= read -r line; do
        msg_type=$(echo "$line" | jq -r '.type // empty' 2>/dev/null)
        if [[ "$msg_type" == "assistant" ]]; then
            echo "$line" | jq -r '
                if .message.content | type == "array" then
                    [.message.content[] | select(.type == "text") | .text] | join(" ")
                else
                    .message.content // ""
                end
            ' 2>/dev/null | head -c 400
            break
        fi
    done || echo "")
fi

# Extract session_id from hook context
session_id=$(echo "$input" | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")
short_session_id="${session_id:0:8}"

# Build title based on stop reason with conversation name and session ID
case "$stop_reason" in
    "end_turn"|"session_end") base_title="Task Complete" ;;
    "max_turns_reached")      base_title="Max Turns Reached" ;;
    "interrupt")              base_title="Interrupted" ;;
    *)                        base_title="Session Ended" ;;
esac

if [[ -n "$conversation_name" ]]; then
    title="Claude: ${base_title} - ${conversation_name} (${short_session_id})"
else
    title="Claude: ${base_title} (${short_session_id})"
fi

if [[ -z "$last_message" ]]; then
    last_message="No details available"
fi

message="${project_name}: ${last_message:0:350}"

result=$(curl -s \
    --form-string "token=${PUSHOVER_APP_TOKEN}" \
    --form-string "user=${PUSHOVER_USER_KEY}" \
    --form-string "title=${title}" \
    --form-string "message=${message}" \
    --form-string "priority=0" \
    --form-string "sound=pushover" \
    "https://api.pushover.net/1/messages.json" 2>&1 || true)

echo "[$(date)] Pushover API result: $result" >> "$LOG"

exit 0
