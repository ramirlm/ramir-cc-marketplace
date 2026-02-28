#!/usr/bin/env bash
# sync-secrets.sh — Sync hook tokens via a private GitHub Gist
# Usage:
#   ./sync-secrets.sh push   # Upload current tokens to Gist
#   ./sync-secrets.sh pull   # Download tokens from Gist and add to shell profile
#   ./sync-secrets.sh show   # Show current token status

set -euo pipefail

GIST_ID_FILE="$HOME/.claude/.gist-secrets-id"
SHELL_PROFILE="$HOME/.zprofile"
GIST_FILENAME="claude-hook-secrets.env"

# Tokens managed by this script
TOKENS=(PUSHOVER_USER_KEY PUSHOVER_APP_TOKEN SLACK_BOT_TOKEN SLACK_CHANNEL_ID)

color_green="\033[0;32m"
color_red="\033[0;31m"
color_yellow="\033[0;33m"
color_reset="\033[0m"

get_gist_id() {
  if [[ -f "$GIST_ID_FILE" ]]; then
    cat "$GIST_ID_FILE"
  else
    echo ""
  fi
}

save_gist_id() {
  mkdir -p "$(dirname "$GIST_ID_FILE")"
  echo "$1" > "$GIST_ID_FILE"
}

cmd_show() {
  echo "Token status:"
  for token in "${TOKENS[@]}"; do
    val="${!token:-}"
    if [[ -n "$val" ]]; then
      masked="${val:0:4}...${val: -4}"
      echo -e "  $token: ${color_green}SET${color_reset} ($masked)"
    else
      echo -e "  $token: ${color_red}UNSET${color_reset}"
    fi
  done

  local gist_id
  gist_id=$(get_gist_id)
  if [[ -n "$gist_id" ]]; then
    echo -e "\nGist ID: ${color_green}${gist_id}${color_reset}"
    echo "  https://gist.github.com/${gist_id}"
  else
    echo -e "\nGist ID: ${color_yellow}not configured${color_reset} (run 'push' first)"
  fi
}

cmd_push() {
  # Build the secrets file content from current environment
  local content=""
  local count=0

  for token in "${TOKENS[@]}"; do
    val="${!token:-}"
    if [[ -n "$val" ]]; then
      content+="export ${token}=\"${val}\""$'\n'
      ((count++))
    fi
  done

  if [[ $count -eq 0 ]]; then
    echo -e "${color_red}Error: No tokens are set in the current environment.${color_reset}"
    echo "Set them first, e.g.:"
    for token in "${TOKENS[@]}"; do
      echo "  export ${token}=\"your-value\""
    done
    exit 1
  fi

  local gist_id
  gist_id=$(get_gist_id)

  if [[ -n "$gist_id" ]]; then
    # Update existing gist — write to temp file for edit
    local tmpfile
    tmpfile=$(mktemp)
    printf '%s' "$content" > "$tmpfile"
    echo "Updating existing Gist ${gist_id}..."
    gh gist edit "$gist_id" -f "$GIST_FILENAME" "$tmpfile"
    rm -f "$tmpfile"
    echo -e "${color_green}Updated ${count} tokens in Gist.${color_reset}"
  else
    # Create new secret gist — use stdin with -f for correct filename
    echo "Creating new secret Gist..."
    local result
    result=$(printf '%s' "$content" | gh gist create -f "$GIST_FILENAME" -d "Claude Code hook secrets" 2>&1)
    # Extract gist ID from the URL
    gist_id=$(echo "$result" | grep -oE '[a-f0-9]{20,}' | head -1)
    if [[ -z "$gist_id" ]]; then
      echo -e "${color_red}Error creating Gist. Output:${color_reset}"
      echo "$result"
      exit 1
    fi
    save_gist_id "$gist_id"
    echo -e "${color_green}Created Gist with ${count} tokens.${color_reset}"
    echo "Gist ID saved to ${GIST_ID_FILE}"
    echo "URL: https://gist.github.com/${gist_id}"
  fi
}

cmd_pull() {
  local gist_id
  gist_id=$(get_gist_id)

  if [[ -z "$gist_id" ]]; then
    echo -e "${color_yellow}No Gist ID found.${color_reset}"
    echo ""
    read -rp "Enter Gist ID (from another machine): " gist_id
    if [[ -z "$gist_id" ]]; then
      echo "Aborted."
      exit 1
    fi
    save_gist_id "$gist_id"
    echo "Gist ID saved to ${GIST_ID_FILE}"
  fi

  echo "Fetching secrets from Gist ${gist_id}..."
  local content
  content=$(gh gist view "$gist_id" -f "$GIST_FILENAME" 2>&1)

  if [[ $? -ne 0 ]] || [[ -z "$content" ]]; then
    echo -e "${color_red}Error fetching Gist:${color_reset}"
    echo "$content"
    exit 1
  fi

  # Remove old tokens from profile if present
  if [[ -f "$SHELL_PROFILE" ]]; then
    for token in "${TOKENS[@]}"; do
      sed -i '' "/^export ${token}=/d" "$SHELL_PROFILE" 2>/dev/null || true
    done
    # Remove old marker comments
    sed -i '' '/^# -- claude-hook-secrets/d' "$SHELL_PROFILE" 2>/dev/null || true
  fi

  # Append new tokens
  {
    echo ""
    echo "# -- claude-hook-secrets (managed by sync-secrets.sh) --"
    echo "$content"
    echo "# -- claude-hook-secrets end --"
  } >> "$SHELL_PROFILE"

  local count
  count=$(echo "$content" | grep -c "^export " || true)
  echo -e "${color_green}Installed ${count} tokens into ${SHELL_PROFILE}${color_reset}"
  echo ""
  echo "Run this to load them now:"
  echo -e "  ${color_yellow}source ${SHELL_PROFILE}${color_reset}"
}

# --- Main ---
case "${1:-show}" in
  push)  cmd_push ;;
  pull)  cmd_pull ;;
  show)  cmd_show ;;
  *)
    echo "Usage: $0 {push|pull|show}"
    echo ""
    echo "  push  — Upload current env tokens to a private GitHub Gist"
    echo "  pull  — Download tokens from Gist into ${SHELL_PROFILE}"
    echo "  show  — Show current token status"
    exit 1
    ;;
esac
