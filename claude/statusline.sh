#!/bin/bash
# Read JSON data that Claude Code sends to stdin
input=$(cat)

# Presence/notify helpers (sourced — defines cn_* functions, reads no stdin)
source ~/.claude/lib/claude-notify.sh

# Extract fields using jq
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
# The "// 0" provides a fallback if the field is null
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Publish the 5h-window rate-limit usage for the tmux status bar (read by
# config/tmux/claude-usage.sh). Account-wide, so one shared file for all sessions.
RL=$(echo "$input" | jq -r '.rate_limits.five_hour | select(. != null) | "\(.used_percentage // 0 | floor) \(.resets_at // 0)"')
if [ -n "$RL" ]; then
	mkdir -p "$HOME/.cache/claude"
	printf '%s\n' "$RL" > "$HOME/.cache/claude/session-usage"
fi

# Git info (run in the context of DIR; silence errors when not a repo)
GIT_DIR=$(git -C "$DIR" rev-parse --git-dir 2>/dev/null)
BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
# Fall back to a short SHA when in detached HEAD state
[ -z "$BRANCH" ] && BRANCH=$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null)

# When inside a linked worktree, git-dir looks like .../worktrees/<name>.
# Show that worktree name; otherwise fall back to the folder name.
case "$GIT_DIR" in
	*/worktrees/*)
		NAME=${GIT_DIR##*/worktrees/}
		NAME=${NAME%%/*}
		;;
	*)
		NAME=${DIR##*/}
		;;
esac

# ANSI styles ($'...' expands the escape sequences at assignment time)
RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
BLUE=$'\033[34m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
MAGENTA=$'\033[35m'

# Focus glyph: 👀 when this pane is the one you're viewing, 💤 otherwise
cn_watching_fast && FOCUS="${GREEN}👀${RESET}" || FOCUS="${DIM}💤${RESET}"

# Color-code the context percentage: green (plenty), yellow (getting full), red (nearly full)
if [ "$PCT" -ge 80 ]; then
	CTX_COLOR=$RED
elif [ "$PCT" -ge 50 ]; then
	CTX_COLOR=$YELLOW
else
	CTX_COLOR=$GREEN
fi

# Build a progress bar for the context: filled blocks in the percent's color, empty in dim
BAR_WIDTH=20
FILLED=$(( PCT * BAR_WIDTH / 100 ))
# Show at least one block for any non-zero usage so small percentages stay visible
[ "$FILLED" -eq 0 ] && [ "$PCT" -gt 0 ] && FILLED=1
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
EMPTY=$(( BAR_WIDTH - FILLED ))
FILL_BAR=""
EMPTY_BAR=""
[ "$FILLED" -gt 0 ] && FILL_BAR=$(printf '█%.0s' $(seq 1 "$FILLED"))
[ "$EMPTY" -gt 0 ] && EMPTY_BAR=$(printf '░%.0s' $(seq 1 "$EMPTY"))
BAR="${CTX_COLOR}${FILL_BAR}${DIM}${EMPTY_BAR}${RESET}"

# Git status markers, mirroring the symbols Powerlevel10k shows
GIT_STATUS=""
if [ -n "$BRANCH" ]; then
	# Commits ahead of / behind the upstream branch
	AHEAD=0
	BEHIND=0
	COUNTS=$(git -C "$DIR" rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
	if [ -n "$COUNTS" ]; then
		BEHIND=${COUNTS%%[[:space:]]*}
		AHEAD=${COUNTS##*[[:space:]]}
	fi

	# Stashes
	STASHES=$(git -C "$DIR" stash list 2>/dev/null | wc -l | tr -d '[:space:]')

	# Index / working-tree counts, parsed from one porcelain pass
	STAGED=0
	UNSTAGED=0
	UNTRACKED=0
	CONFLICTED=0
	while IFS= read -r line; do
		xy=${line:0:2}
		case "$xy" in
			'??') UNTRACKED=$((UNTRACKED + 1)); continue ;;
			DD|AU|UD|UA|DU|AA|UU) CONFLICTED=$((CONFLICTED + 1)); continue ;;
		esac
		[ "${xy:0:1}" != ' ' ] && STAGED=$((STAGED + 1))
		[ "${xy:1:1}" != ' ' ] && UNSTAGED=$((UNSTAGED + 1))
	done < <(git -C "$DIR" status --porcelain 2>/dev/null)

	# Assemble in p10k order: <behind >ahead *stashes ~conflicts +staged !unstaged ?untracked
	[ "$BEHIND"     -gt 0 ] && GIT_STATUS+=" ${DIM}<${BEHIND}${RESET}"
	[ "$AHEAD"      -gt 0 ] && GIT_STATUS+=" ${DIM}>${AHEAD}${RESET}"
	[ "$STASHES"    -gt 0 ] && GIT_STATUS+=" ${CYAN}*${STASHES}${RESET}"
	[ "$CONFLICTED" -gt 0 ] && GIT_STATUS+=" ${RED}~${CONFLICTED}${RESET}"
	[ "$STAGED"     -gt 0 ] && GIT_STATUS+=" ${GREEN}+${STAGED}${RESET}"
	[ "$UNSTAGED"   -gt 0 ] && GIT_STATUS+=" ${YELLOW}!${UNSTAGED}${RESET}"
	[ "$UNTRACKED"  -gt 0 ] && GIT_STATUS+=" ${DIM}?${UNTRACKED}${RESET}"
fi

# Output the status line
# Line 1: model, context (bar + percent), and name (worktree or folder)
echo "${BOLD}${CYAN}${MODEL}${RESET} ${DIM}│${RESET} ${BAR} ${CTX_COLOR}${BOLD}${PCT}%${RESET}${DIM} context${RESET} ${DIM}│${RESET} 📁 ${BOLD}${BLUE}${NAME}${RESET} ${DIM}│${RESET} ${FOCUS}"
# Line 2: git info, only when in a git repo
if [ -n "$BRANCH" ]; then
	echo "  ${MAGENTA}🌿 ${BOLD}${BRANCH}${RESET}${GIT_STATUS}"
fi
