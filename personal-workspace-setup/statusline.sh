#!/bin/bash
# Claude Code Status Line
# Shows: directory, git, model, duration, messages, context usage

input=$(cat)

# Parse JSON input
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty' 2>/dev/null)
dir_name=$(basename "$cwd" 2>/dev/null || echo "?")
model=$(echo "$input" | jq -r '.model.display_name // "?"' 2>/dev/null)
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0' 2>/dev/null)
transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)

# Get session ID from JSON input
session_id=$(echo "$input" | jq -r '.session_id // empty' 2>/dev/null)

# Extract session name from transcript JSONL file
# Priority: customTitle (user-set via /rename) > slug (auto-generated) > empty
# Use tail -1 to get the LAST occurrence (most recent)
session_name=""
if [[ -n "$transcript" ]] && [[ -f "$transcript" ]]; then
    # Try to get customTitle first (user-set session name from /rename command)
    session_name=$(grep -o '"customTitle":"[^"]*"' "$transcript" 2>/dev/null | tail -1 | sed 's/"customTitle":"//;s/"$//')

    # If no customTitle, fall back to slug (auto-generated name)
    if [[ -z "$session_name" ]]; then
        session_name=$(grep -o '"slug":"[^"]*"' "$transcript" 2>/dev/null | tail -1 | sed 's/"slug":"//;s/"$//')
    fi
fi

# Context limit based on model (tokens)
# Opus/Sonnet/Haiku: 200K standard
MAX_TOKENS=200000

# Format duration (ms to minutes:seconds)
if [[ "$duration_ms" =~ ^[0-9]+$ ]] && [[ "$duration_ms" -gt 0 ]]; then
    total_secs=$((duration_ms / 1000))
    mins=$((total_secs / 60))
    secs=$((total_secs % 60))
    duration_fmt="${mins}m${secs}s"
else
    duration_fmt="0m0s"
fi

# Count messages and estimate tokens from transcript
msg_count=0
context_pct="0"
tokens_k="0"
if [[ -n "$transcript" ]] && [[ -f "$transcript" ]]; then
    msg_count=$(grep -c '"type":"user"\|"type":"assistant"' "$transcript" 2>/dev/null || echo "0")

    # File size as base (transcript has ~60% overhead from JSON/metadata)
    file_size=$(stat -f%z "$transcript" 2>/dev/null || wc -c < "$transcript" 2>/dev/null | tr -d ' ')

    # Estimate: file_size * 0.4 (40% is actual content) / 4 chars per token
    estimated_tokens=$((file_size / 10))
    tokens_k=$((estimated_tokens / 1000))

    # Calculate percentage
    if [[ $estimated_tokens -gt 0 ]]; then
        context_pct=$(LC_ALL=C awk "BEGIN {printf \"%.0f\", ($estimated_tokens/$MAX_TOKENS)*100}" 2>/dev/null || echo "0")
    fi
fi

# Create progress bar for context usage
# Using: Gray background, White/Orange foreground based on progress
BAR_WIDTH=20
filled_chars=$((context_pct * BAR_WIDTH / 100))
[[ $filled_chars -gt $BAR_WIDTH ]] && filled_chars=$BAR_WIDTH

# Colors: Gray (dim white), White (bright), Orange (Claude's orange #E87C4C)
GRAY='\033[2;37m'      # Dim white/gray
WHITE='\033[1;37m'     # Bright white
ORANGE='\033[38;5;208m' # Claude orange (closest ANSI 256 color to #E87C4C)
RESET='\033[0m'

# Build progress bar
progress_bar=""
for ((i=0; i<BAR_WIDTH; i++)); do
    if [[ $i -lt $filled_chars ]]; then
        # Use orange for filled portion
        progress_bar="${progress_bar}${ORANGE}━${RESET}"
    else
        # Use gray for empty portion
        progress_bar="${progress_bar}${GRAY}━${RESET}"
    fi
done

# Git info
git_info=""
if [[ -n "$cwd" ]] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || echo "detached")
    if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
       ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
        dirty="*"
    else
        dirty=""
    fi
    git_info="($branch$dirty)"
fi

# Colors
CYAN='\033[0;36m'
BLUE='\033[1;34m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'

# Get terminal width to calculate spacing
term_width=$(tput cols 2>/dev/null || echo 80)

# Build left side: ➜ dir git:(branch) | model | ⏱ duration | 💬 msgs | [progress bar] ~Kk
left_side=$(printf "${CYAN}➜${RESET} ${BLUE}%s${RESET} ${YELLOW}%s${RESET} ${RESET}│${RESET} ${MAGENTA}%s${RESET} ${RESET}│${RESET} ${GREEN}⏱ %s${RESET} ${RESET}│${RESET} ${CYAN}💬 %s${RESET} ${RESET}│${RESET} %b ${WHITE}~%sk${RESET}" \
    "$dir_name" \
    "$git_info" \
    "$model" \
    "$duration_fmt" \
    "$msg_count" \
    "$progress_bar" \
    "$tokens_k")

# Build right side: session info
# Format: "session-name: {name} - [{id}]" if name exists, otherwise "[{id}]"
if [[ -n "$session_name" ]]; then
    right_side=$(printf "${GRAY}session-name: ${RESET}${CYAN}%s${RESET}${GRAY} - [${RESET}${CYAN}%s${RESET}${GRAY}]${RESET}" "$session_name" "$session_id")
else
    right_side=$(printf "${GRAY}[${RESET}${CYAN}%s${RESET}${GRAY}]${RESET}" "$session_id")
fi

# Calculate visible lengths (strip ANSI codes for accurate counting)
# Using perl for accurate character counting without newlines
left_visible=$(echo -n "$left_side" | perl -pe 's/\x1b\[[0-9;]*m//g' | wc -c | tr -d ' ')
right_visible=$(echo -n "$right_side" | perl -pe 's/\x1b\[[0-9;]*m//g' | wc -c | tr -d ' ')

# Calculate padding (ensure at least 2 spaces between left and right)
padding_needed=$((term_width - left_visible - right_visible))
[[ $padding_needed -lt 2 ]] && padding_needed=2

# Build padding
padding=$(printf "%${padding_needed}s" "")

# Output final status line
printf "%b%s%b" "$left_side" "$padding" "$right_side"
