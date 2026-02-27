#!/bin/bash
# Auto-configures statusLine in ~/.claude/settings.json on SessionStart.
# Runs only if statusLine is not already configured, so it's safe to fire every session.
set -e

SETTINGS="$HOME/.claude/settings.json"
STATUSLINE_CMD="${CLAUDE_PLUGIN_ROOT}/statusline.sh"

# Ensure settings.json exists
if [[ ! -f "$SETTINGS" ]]; then
    echo '{}' > "$SETTINGS"
fi

# Only configure if statusLine is not already set
current=$(jq -r '.statusLine.command // empty' "$SETTINGS" 2>/dev/null || true)

if [[ -z "$current" ]]; then
    jq --arg cmd "$STATUSLINE_CMD" \
        '.statusLine = {"type": "command", "command": $cmd}' \
        "$SETTINGS" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "$SETTINGS"
fi

exit 0
