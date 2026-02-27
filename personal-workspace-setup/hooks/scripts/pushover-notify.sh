#!/bin/bash
# Pushover notification hook for Claude Code
# Sends high-priority notification with context when Claude stops

# Credentials - Set these environment variables in your shell profile or .env file
# export PUSHOVER_USER_KEY="your-user-key-here"
# export PUSHOVER_APP_TOKEN="your-app-token-here"
export PUSHOVER_USER_KEY="${PUSHOVER_USER_KEY:-}"
export PUSHOVER_APP_TOKEN="${PUSHOVER_APP_TOKEN:-}"

# Check if credentials are set
if [[ -z "$PUSHOVER_USER_KEY" ]] || [[ -z "$PUSHOVER_APP_TOKEN" ]]; then
  # Silently exit if credentials not configured
  exit 0
fi

# Read stdin (hook context)
input=$(cat)

# Extract info from hook context
stop_reason=$(echo "$input" | jq -r '.stop_hook_name // "unknown"' 2>/dev/null || echo "unknown")
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""' 2>/dev/null || echo "")
cwd=$(echo "$input" | jq -r '.cwd // ""' 2>/dev/null || echo "$PWD")
project_name=$(basename "$cwd" 2>/dev/null || echo "projeto")

# Get conversation name and last assistant message from transcript (JSONL format)
last_message=""
conversation_name=""
if [[ -n "$transcript_path" ]] && [[ -f "$transcript_path" ]]; then
    # Get conversation name from custom-title entry
    conversation_name=$(grep '"type":"custom-title"' "$transcript_path" 2>/dev/null | tail -1 | jq -r '.customTitle // empty' 2>/dev/null || echo "")

    # Use tail -r for macOS (reverse lines), get last assistant message
    last_message=$(tail -r "$transcript_path" 2>/dev/null | while IFS= read -r line; do
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
# Use short ID (first 8 chars) for display
short_session_id="${session_id:0:8}"

# Build title based on stop reason with conversation name and session ID
base_title=""
case "$stop_reason" in
    "session_end")
        base_title="Sessão Finalizada"
        ;;
    "max_turns_reached")
        base_title="Limite de Turnos"
        ;;
    "interrupt")
        base_title="Interrompido"
        ;;
    *)
        base_title="Tarefa Completa"
        ;;
esac

# Build title with conversation name and session ID
if [[ -n "$conversation_name" ]]; then
    title="Claude: ${base_title} - ${conversation_name} (${short_session_id})"
else
    title="Claude: ${base_title} (${short_session_id})"
fi

# Build message with context (ensure not empty)
if [[ -z "$last_message" ]]; then
    last_message="Sem detalhes disponíveis"
fi

message="${project_name}: ${last_message:0:350}"

# Send notification via Pushover
curl -s \
    --form-string "token=${PUSHOVER_APP_TOKEN}" \
    --form-string "user=${PUSHOVER_USER_KEY}" \
    --form-string "title=${title}" \
    --form-string "message=${message}" \
    --form-string "priority=0" \
    --form-string "sound=pushover" \
    "https://api.pushover.net/1/messages.json" > /dev/null 2>&1 || true

exit 0
