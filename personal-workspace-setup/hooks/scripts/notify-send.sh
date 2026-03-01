#!/bin/bash
# Multi-backend notification script for Claude Code hooks
# Usage: notify-send.sh <context>
#   where <context> is one of: stop, question, notification
# Reads hook JSON from stdin
# Cross-platform (macOS + Linux)
#
# Config: ~/.claude/notifications.json
# Falls back to env vars (PUSHOVER_USER_KEY/PUSHOVER_APP_TOKEN or PUSHOVER_USER/PUSHOVER_TOKEN)
# then shell profile scraping for backward compat

CONTEXT="${1:-notification}"
CONFIG_FILE="$HOME/.claude/notifications.json"

# --- Read stdin (hook context JSON) ---
input=$(cat)

session_id=$(echo "$input" | jq -r '.session_id // ""' 2>/dev/null)
cwd=$(echo "$input" | jq -r '.cwd // ""' 2>/dev/null)
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""' 2>/dev/null)
project_name=$(basename "$cwd" 2>/dev/null || echo "Claude")
short_id="${session_id:0:8}"

# --- Build title and message based on context ---
title=""
message=""

case "$CONTEXT" in
  stop)
    stop_reason=$(echo "$input" | jq -r '.stop_reason // .stop_hook_name // "unknown"' 2>/dev/null)
    case "$stop_reason" in
      "end_turn"|"session_end") label="Task Complete" ;;
      "max_turns_reached")      label="Max Turns Reached" ;;
      "interrupt")              label="Interrupted" ;;
      *)                        label="Session Ended" ;;
    esac

    # Get last assistant message from transcript
    body=""
    if [[ -n "$transcript_path" ]] && [[ -f "$transcript_path" ]]; then
      if command -v tac &>/dev/null; then reverse_cmd="tac"; else reverse_cmd="tail -r"; fi
      body=$($reverse_cmd "$transcript_path" 2>/dev/null | while IFS= read -r line; do
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

    # Get conversation name
    conv_name=""
    if [[ -n "$transcript_path" ]] && [[ -f "$transcript_path" ]]; then
      conv_name=$(grep '"type":"custom-title"' "$transcript_path" 2>/dev/null | tail -1 | jq -r '.customTitle // empty' 2>/dev/null || echo "")
    fi

    if [[ -n "$conv_name" ]]; then
      title="Claude: ${label} - ${conv_name} (${short_id})"
    else
      title="Claude: ${label} (${short_id})"
    fi
    message="${project_name}: ${body:-No details available}"
    ;;

  question)
    question=$(echo "$input" | jq -r '.tool_input.questions[0].question // "Your response is needed"' 2>/dev/null)
    title="Claude needs attention: ${project_name} (${short_id})"
    message="${question}"
    ;;

  notification)
    msg=$(echo "$input" | jq -r '.message // "Awaiting your input"' 2>/dev/null)
    title="Claude: ${project_name} (${short_id})"
    message="${msg}"
    ;;
esac

# --- Send to backends ---

send_pushover() {
  local user_key="$1"
  local app_token="$2"

  curl -s \
    --form-string "token=${app_token}" \
    --form-string "user=${user_key}" \
    --form-string "title=${title}" \
    --form-string "message=${message:0:500}" \
    --form-string "priority=0" \
    "https://api.pushover.net/1/messages.json" > /dev/null 2>&1 || true
}

sent=false

# 1) Try config file first
if [[ -f "$CONFIG_FILE" ]]; then
  backend_count=$(jq -r '.backends | length' "$CONFIG_FILE" 2>/dev/null || echo "0")

  for ((i=0; i<backend_count; i++)); do
    backend_type=$(jq -r ".backends[$i].type" "$CONFIG_FILE" 2>/dev/null)

    case "$backend_type" in
      pushover)
        pk=$(jq -r ".backends[$i].user_key" "$CONFIG_FILE" 2>/dev/null)
        pt=$(jq -r ".backends[$i].app_token" "$CONFIG_FILE" 2>/dev/null)
        if [[ -n "$pk" && "$pk" != "null" && -n "$pt" && "$pt" != "null" ]]; then
          send_pushover "$pk" "$pt"
          sent=true
        fi
        ;;
      # Future backends go here:
      # telegram) ... ;;
      # slack)    ... ;;
      # email)    ... ;;
    esac
  done
fi

# 2) Fallback: env vars (supports both naming conventions)
if [[ "$sent" != "true" ]]; then
  po_user="${PUSHOVER_USER_KEY:-$PUSHOVER_USER}"
  po_token="${PUSHOVER_APP_TOKEN:-$PUSHOVER_TOKEN}"

  # 3) Fallback: scrape shell profiles
  if [[ -z "$po_user" || -z "$po_token" ]]; then
    for profile in "$HOME/.local.zsh" "$HOME/.zprofile" "$HOME/.zshenv" "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
      if [[ -f "$profile" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
          if [[ "$line" =~ ^export\ PUSHOVER_ ]]; then
            eval "$line" 2>/dev/null || true
          fi
        done < "$profile"
      fi
    done
    po_user="${PUSHOVER_USER_KEY:-$PUSHOVER_USER}"
    po_token="${PUSHOVER_APP_TOKEN:-$PUSHOVER_TOKEN}"
  fi

  if [[ -n "$po_user" && -n "$po_token" ]]; then
    send_pushover "$po_user" "$po_token"
  fi
fi

exit 0
