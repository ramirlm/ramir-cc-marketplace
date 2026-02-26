#!/bin/bash
# Install all plugins from this marketplace
# Properly wires hooks and statusLine into ~/.claude/settings.json
# and copies skills/commands/agents to the correct Claude Code directories.

set -e

PLUGINS_SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Code Plugins - Installation"
echo "====================================="
echo ""

# Ensure base dirs exist
mkdir -p "$CLAUDE_DIR/plugins"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/agents"

# ---------------------------------------------------------------------------
# Helper: merge JSON with jq (requires jq)
# ---------------------------------------------------------------------------
if ! command -v jq &>/dev/null; then
    echo "ERROR: jq is required but not installed. Install it and re-run."
    exit 1
fi

SETTINGS="$CLAUDE_DIR/settings.json"

# Ensure settings.json exists with minimal structure
if [[ ! -f "$SETTINGS" ]]; then
    echo '{}' > "$SETTINGS"
fi

# ---------------------------------------------------------------------------
# 1. personal-workspace-setup — hooks + statusLine
# ---------------------------------------------------------------------------
PLUGIN_DIR="$CLAUDE_DIR/plugins/personal-workspace-setup"
PLUGIN_SRC="$PLUGINS_SRC_DIR/personal-workspace-setup"

echo "Installing personal-workspace-setup..."
cp -r "$PLUGIN_SRC" "$CLAUDE_DIR/plugins/"
chmod +x "$PLUGIN_DIR/hooks/scripts/"*.sh 2>/dev/null || true
chmod +x "$PLUGIN_DIR/statusline.sh" 2>/dev/null || true

# -- statusLine ---------------------------------------------------------------
# Write statusLine entry into settings.json, replacing ${CLAUDE_PLUGIN_ROOT}
STATUSLINE_CMD="$PLUGIN_DIR/statusline.sh"

SETTINGS_TMP=$(mktemp)
jq --arg cmd "$STATUSLINE_CMD" \
    '.statusLine = {"type": "command", "command": $cmd}' \
    "$SETTINGS" > "$SETTINGS_TMP" && mv "$SETTINGS_TMP" "$SETTINGS"
echo "  statusLine -> $STATUSLINE_CMD"

# -- hooks -------------------------------------------------------------------
# Read hooks.json from the plugin, resolve ${CLAUDE_PLUGIN_ROOT} to actual path,
# then merge each hook event type into settings.json
HOOKS_JSON="$PLUGIN_DIR/hooks/hooks.json"

if [[ -f "$HOOKS_JSON" ]]; then
    # Replace ${CLAUDE_PLUGIN_ROOT} with the real installed path
    RESOLVED_HOOKS=$(sed "s|\${CLAUDE_PLUGIN_ROOT}|$PLUGIN_DIR|g" "$HOOKS_JSON")

    # For each event type in the plugin hooks.json, append entries to settings.json
    EVENT_TYPES=$(echo "$RESOLVED_HOOKS" | jq -r 'keys[]')
    for event in $EVENT_TYPES; do
        NEW_ENTRIES=$(echo "$RESOLVED_HOOKS" | jq --arg ev "$event" '.[$ev]')
        SETTINGS_TMP=$(mktemp)
        jq --arg ev "$event" --argjson entries "$NEW_ENTRIES" '
            .hooks[$ev] = ((.hooks[$ev] // []) + $entries)
        ' "$SETTINGS" > "$SETTINGS_TMP" && mv "$SETTINGS_TMP" "$SETTINGS"
        echo "  hooks.$event -> merged $(echo "$NEW_ENTRIES" | jq length) rule(s)"
    done
fi

echo "  personal-workspace-setup installed"
echo ""

# ---------------------------------------------------------------------------
# 2. coding-skills — copy skills to ~/.claude/skills/
# ---------------------------------------------------------------------------
SKILL_SRC="$PLUGINS_SRC_DIR/coding-skills/skills"
if [[ -d "$SKILL_SRC" ]]; then
    echo "Installing coding-skills..."
    cp -r "$SKILL_SRC"/. "$CLAUDE_DIR/skills/"
    echo "  skills copied to $CLAUDE_DIR/skills/"
    echo ""
fi

# ---------------------------------------------------------------------------
# 3. productivity-skills — copy skills to ~/.claude/skills/
# ---------------------------------------------------------------------------
SKILL_SRC="$PLUGINS_SRC_DIR/productivity-skills/skills"
if [[ -d "$SKILL_SRC" ]]; then
    echo "Installing productivity-skills..."
    cp -r "$SKILL_SRC"/. "$CLAUDE_DIR/skills/"
    echo "  skills copied to $CLAUDE_DIR/skills/"
    echo ""
fi

# ---------------------------------------------------------------------------
# 4. dev-commands — copy commands to ~/.claude/commands/
# ---------------------------------------------------------------------------
CMD_SRC="$PLUGINS_SRC_DIR/dev-commands/commands"
if [[ -d "$CMD_SRC" ]]; then
    echo "Installing dev-commands..."
    cp -r "$CMD_SRC"/. "$CLAUDE_DIR/commands/"
    echo "  commands copied to $CLAUDE_DIR/commands/"
    echo ""
fi

# ---------------------------------------------------------------------------
# 5. e2e-test-agent — copy agent to ~/.claude/agents/
# ---------------------------------------------------------------------------
AGENT_SRC="$PLUGINS_SRC_DIR/e2e-test-agent/agents"
if [[ -d "$AGENT_SRC" ]]; then
    echo "Installing e2e-test-agent..."
    cp -r "$AGENT_SRC"/. "$CLAUDE_DIR/agents/"
    echo "  agent copied to $CLAUDE_DIR/agents/"
    echo ""
fi

# ---------------------------------------------------------------------------
# 6. unit-test-agent — copy agent to ~/.claude/agents/
# ---------------------------------------------------------------------------
AGENT_SRC="$PLUGINS_SRC_DIR/unit-test-agent/agents"
if [[ -d "$AGENT_SRC" ]]; then
    echo "Installing unit-test-agent..."
    cp -r "$AGENT_SRC"/. "$CLAUDE_DIR/agents/"
    echo "  agent copied to $CLAUDE_DIR/agents/"
    echo ""
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo "Installation complete!"
echo ""
echo "What was configured in ~/.claude/settings.json:"
echo "  - statusLine: $PLUGIN_DIR/statusline.sh"
echo "  - hooks: merged from personal-workspace-setup/hooks/hooks.json"
echo ""
echo "What was installed:"
echo "  Skills  -> $CLAUDE_DIR/skills/"
echo "  Commands-> $CLAUDE_DIR/commands/"
echo "  Agents  -> $CLAUDE_DIR/agents/"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code for changes to take effect"
echo "  2. Optional — set env vars for notifications:"
echo "     export SLACK_BOT_TOKEN=\"xoxb-your-token\""
echo "     export PUSHOVER_USER_KEY=\"your-user-key\""
echo "     export PUSHOVER_APP_KEY=\"your-app-key\""
