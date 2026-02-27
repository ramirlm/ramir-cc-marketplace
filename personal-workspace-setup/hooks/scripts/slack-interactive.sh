#!/bin/bash
# Slack interactive hook for Claude Code
# Posts context to Slack when Claude asks a question and injects reply as input

set -euo pipefail

# Credentials - Set these environment variables in your shell profile or .env file
# export SLACK_BOT_TOKEN="xoxb-your-bot-token-here"
# export SLACK_CHANNEL_ID="C0XXXXXXXXX"
export SLACK_BOT_TOKEN="${SLACK_BOT_TOKEN:-}"
export SLACK_CHANNEL_ID="${SLACK_CHANNEL_ID:-}"

# Check if credentials are set
if [[ -z "$SLACK_BOT_TOKEN" ]] || [[ -z "$SLACK_CHANNEL_ID" ]]; then
  # Silently exit if credentials not configured
  exit 0
fi

# Configuration
POLL_INTERVAL=3
POLL_TIMEOUT=300
LOG_FILE="$HOME/.claude/slack_hook.log"

log() {
    echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
}

# Read stdin (hook context)
input=$(cat)
log "Hook triggered"

# Extract info from hook context
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')
cwd=$(echo "$input" | jq -r '.cwd // "'$PWD'"')
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
project_name=$(basename "$cwd")

# For PreToolUse, get the question from tool_input
tool_input=$(echo "$input" | jq -r '.tool_input // {}')
current_question=$(echo "$tool_input" | jq -r '.questions[0].question // "Aguardando resposta..."')

log "Session: $session_id, Tool: $tool_name"

# Get conversation name and recent context from transcript (JSONL format)
conversation_name=""
recent_context=""
if [[ -n "$transcript_path" ]] && [[ -f "$transcript_path" ]]; then
    log "Reading transcript: $transcript_path"

    # Get conversation name from custom-title entry
    conversation_name=$(grep '"type":"custom-title"' "$transcript_path" 2>/dev/null | tail -1 | jq -r '.customTitle // empty' 2>/dev/null || echo "")

    # Get last 5 messages from JSONL (each line is a JSON object)
    recent_context=$(tail -10 "$transcript_path" 2>/dev/null | while read -r line; do
        msg_type=$(echo "$line" | jq -r '.type // empty' 2>/dev/null)
        if [[ "$msg_type" == "user" ]] || [[ "$msg_type" == "assistant" ]]; then
            role=$(echo "$line" | jq -r '.type' 2>/dev/null)
            content=$(echo "$line" | jq -r '
                if .message.content | type == "array" then
                    [.message.content[] | select(.type == "text") | .text] | join("\n")
                else
                    .message.content // ""
                end
            ' 2>/dev/null | head -c 500)

            if [[ -n "$content" ]]; then
                if [[ "$role" == "user" ]]; then
                    echo "👤 *Você:* ${content:0:300}"
                else
                    echo "🤖 *Claude:* ${content:0:300}"
                fi
                echo "---"
            fi
        fi
    done | tail -20)
fi

# Escape for JSON
escape_json() {
    python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))" | sed 's/^"//;s/"$//'
}

question_escaped=$(echo "$current_question" | escape_json)
context_escaped=$(echo "$recent_context" | escape_json)

# Use short session ID (first 8 chars) for display
short_session_id="${session_id:0:8}"

# Build header title with conversation name and session ID
if [[ -n "$conversation_name" ]]; then
    header_title="Claude Code - ${conversation_name} (${short_session_id})"
else
    header_title="Claude Code - Pergunta (${short_session_id})"
fi

log "Question: ${current_question:0:50}..."

# Build Slack message
payload=$(cat <<EOF
{
    "channel": "${SLACK_CHANNEL_ID}",
    "text": "Claude Code precisa da sua resposta",
    "blocks": [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": "${header_title}",
                "emoji": true
            }
        },
        {
            "type": "context",
            "elements": [
                {
                    "type": "mrkdwn",
                    "text": "*Projeto:* \`${project_name}\`"
                }
            ]
        },
        {
            "type": "divider"
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*Pergunta:*\n${question_escaped}"
            }
        },
        {
            "type": "divider"
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*Contexto recente:*\n${context_escaped:0:2000}"
            }
        },
        {
            "type": "divider"
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "💬 *Responda nesta thread* - sua resposta será digitada automaticamente no terminal."
            }
        }
    ]
}
EOF
)

log "Posting to Slack..."

# Post message to Slack
response=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d "$payload")

if [[ $(echo "$response" | jq -r '.ok') != "true" ]]; then
    error=$(echo "$response" | jq -r '.error // "unknown"')
    log "Failed to post to Slack: $error"
    exit 0  # Don't block Claude, just log the error
fi

thread_ts=$(echo "$response" | jq -r '.ts')
channel=$(echo "$response" | jq -r '.channel')
log "Message posted. Thread: $thread_ts"

# Poll for replies
start_time=$(date +%s)
while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [[ $elapsed -ge $POLL_TIMEOUT ]]; then
        log "Timeout after ${POLL_TIMEOUT}s"
        curl -s -X POST "https://slack.com/api/chat.postMessage" \
            -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
            -H "Content-Type: application/json; charset=utf-8" \
            -d "{\"channel\":\"${channel}\",\"thread_ts\":\"${thread_ts}\",\"text\":\"⏰ Timeout - nenhuma resposta em 5 minutos.\"}" > /dev/null
        exit 0
    fi

    # Get replies in thread
    replies=$(curl -s -G "https://slack.com/api/conversations.replies" \
        -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
        -d "channel=${channel}" \
        -d "ts=${thread_ts}" 2>/dev/null)

    if [[ $(echo "$replies" | jq -r '.ok') == "true" ]]; then
        # Get first user reply (not bot)
        user_reply=$(echo "$replies" | jq -r '
            .messages |
            map(select(.thread_ts != .ts and (.bot_id | not))) |
            first |
            .text // empty
        ')

        if [[ -n "$user_reply" ]]; then
            log "Reply received: ${user_reply:0:50}..."

            # Confirm in Slack
            curl -s -X POST "https://slack.com/api/chat.postMessage" \
                -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
                -H "Content-Type: application/json; charset=utf-8" \
                -d "{\"channel\":\"${channel}\",\"thread_ts\":\"${thread_ts}\",\"text\":\"✅ Enviando resposta...\"}" > /dev/null

            # Use AppleScript to type the response into the terminal
            osascript -e "
                tell application \"System Events\"
                    delay 0.3
                    keystroke \"${user_reply//\"/\\\"}\"
                    delay 0.1
                    keystroke return
                end tell
            " 2>/dev/null && {
                log "Response injected via AppleScript"
                curl -s -X POST "https://slack.com/api/chat.postMessage" \
                    -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
                    -H "Content-Type: application/json; charset=utf-8" \
                    -d "{\"channel\":\"${channel}\",\"thread_ts\":\"${thread_ts}\",\"text\":\"✅ Resposta enviada!\"}" > /dev/null
            } || {
                log "AppleScript failed, copying to clipboard"
                echo "$user_reply" | pbcopy
                curl -s -X POST "https://slack.com/api/chat.postMessage" \
                    -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
                    -H "Content-Type: application/json; charset=utf-8" \
                    -d "{\"channel\":\"${channel}\",\"thread_ts\":\"${thread_ts}\",\"text\":\"⚠️ AppleScript falhou. Resposta copiada (Cmd+V).\"}" > /dev/null
            }

            exit 0
        fi
    fi

    sleep $POLL_INTERVAL
done
