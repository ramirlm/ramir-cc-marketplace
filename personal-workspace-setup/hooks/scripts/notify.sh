#!/bin/bash
# Cross-platform notification hook for Claude Code's Notification event.
# Priority order:
#   1. afplay (macOS) — plays notification.mp3
#   2. paplay / aplay (Linux with PulseAudio / ALSA)
#   3. notify-send (Linux desktop)
#   4. Pushover (headless / remote) — requires PUSHOVER_USER_KEY and PUSHOVER_APP_TOKEN
#   5. Terminal bell (universal fallback)

input=$(cat)
message=$(echo "$input" | jq -r '.message // "Claude Code precisa da sua atenção"' 2>/dev/null || echo "Claude Code precisa da sua atenção")
title=$(echo "$input" | jq -r '.title // "Claude Code"' 2>/dev/null || echo "Claude Code")

SOUND="${CLAUDE_PLUGIN_ROOT}/hooks/sounds/notification.mp3"

notified=0

# 1. macOS — afplay
if command -v afplay &>/dev/null && [[ -f "$SOUND" ]]; then
    afplay "$SOUND" &>/dev/null &
    notified=1
fi

# 2. Linux — PulseAudio
if [[ $notified -eq 0 ]] && command -v paplay &>/dev/null && [[ -f "$SOUND" ]]; then
    paplay "$SOUND" &>/dev/null &
    notified=1
fi

# 3. Linux — ALSA
if [[ $notified -eq 0 ]] && command -v aplay &>/dev/null && [[ -f "$SOUND" ]]; then
    aplay "$SOUND" &>/dev/null &
    notified=1
fi

# 4. Linux desktop — notify-send
if command -v notify-send &>/dev/null; then
    notify-send "$title" "$message" --urgency=normal &>/dev/null &
    notified=1
fi

# 5. Pushover (headless / remote) — only if no local notification worked
if [[ $notified -eq 0 ]] && [[ -n "${PUSHOVER_USER_KEY:-}" ]] && [[ -n "${PUSHOVER_APP_TOKEN:-}" ]]; then
    curl -s \
        --form-string "token=${PUSHOVER_APP_TOKEN}" \
        --form-string "user=${PUSHOVER_USER_KEY}" \
        --form-string "title=${title}" \
        --form-string "message=${message}" \
        --form-string "priority=0" \
        --form-string "sound=pushover" \
        "https://api.pushover.net/1/messages.json" > /dev/null 2>&1 &
    notified=1
fi

# 6. Terminal bell — universal last resort
if [[ $notified -eq 0 ]]; then
    printf '\a'
fi

exit 0
