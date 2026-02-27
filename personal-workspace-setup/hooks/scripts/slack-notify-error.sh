#!/bin/bash
# Slack error notification hook for Claude Code
# Sends notification to Slack when errors occur

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

# Read stdin (hook context)
input=$(cat)

# Extract error information
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
cwd=$(echo "$input" | jq -r '.cwd // "'$PWD'"')
project_name=$(basename "$cwd")
short_session_id="${session_id:0:8}"

# Build Slack message
payload=$(cat <<EOF
{
    "channel": "${SLACK_CHANNEL_ID}",
    "text": "⚠️ Claude Code Error",
    "blocks": [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": "⚠️ Claude Code Error (${short_session_id})",
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
        }
    ]
}
EOF
)

# Post message to Slack
curl -s -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d "$payload" > /dev/null 2>&1 || true

exit 0
