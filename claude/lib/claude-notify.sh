#!/bin/bash
# Presence checks + desktop notification. Source for functions, or run directly as a hook.

# Fast presence check (tmux only) — cheap enough for every statusline render.
cn_watching_fast() {
	[ -z "${TMUX:-}" ] && return 1
	local args=(-p)
	[ -n "${TMUX_PANE:-}" ] && args+=(-t "$TMUX_PANE")
	case "$(tmux display-message "${args[@]}" \
		'#{window_active}:#{pane_active}:#{session_attached}' 2>/dev/null)" in
		1:1:0) return 1 ;;   # active pane but nobody attached
		1:1:*) return 0 ;;   # active pane + window + client attached
		*)     return 1 ;;   # some other window/pane
	esac
}

# Full presence check — adds the macOS frontmost-app test (uses osascript; hook-only).
cn_watching() {
	cn_watching_fast || return 1
	case "$(osascript -e 'tell application "System Events" to get bundle identifier of first application process whose frontmost is true' 2>/dev/null)" in
		com.googlecode.iterm2|com.apple.Terminal|com.mitchellh.ghostty|\
		com.github.wez.wezterm|net.kovidgoyal.kitty|org.alacritty|\
		dev.warp.Warp|co.zeit.hyper|com.microsoft.VSCode) return 0 ;;
	esac
	return 1
}

# cn_location [dir] — linked-worktree name if in one, else the directory basename.
cn_location() {
	local dir="${1:-$PWD}" gitdir
	gitdir=$(git -C "$dir" rev-parse --git-dir 2>/dev/null)
	case "$gitdir" in
		*/worktrees/*) gitdir=${gitdir##*/worktrees/}; printf '%s' "${gitdir%%/*}" ;;
		*)             printf '%s' "${dir##*/}" ;;
	esac
}

# cn_sound_file <name> — resolve a sound name to a file across the standard
# locations (user sounds win) and formats. Drop e.g. Breeze.aiff in ~/Library/Sounds
# and "Breeze" just works. Prints the path, or nothing if not found.
cn_sound_file() {
	local name="$1" dir ext
	for dir in "$HOME/Library/Sounds" "/Library/Sounds" "/System/Library/Sounds"; do
		for ext in aiff caf m4a m4r wav; do
			[ -f "$dir/$name.$ext" ] && { printf '%s' "$dir/$name.$ext"; return 0; }
		done
	done
	return 1
}

# cn_notify <title> <body> <sound> [subtitle]   (sound resolved by cn_sound_file)
cn_notify() {
	local title="$1" body="$2" sound="${3:-Glass}" sub="${4:-}" file
	osascript - "$title" "$body" "$sub" >/dev/null 2>&1 <<'OSA'
on run argv
	set {t, b, sub} to argv
	if sub is "" then
		display notification b with title t
	else
		display notification b with title t subtitle sub
	end if
end run
OSA
	file=$(cn_sound_file "$sound")
	[ -n "$file" ] && afplay "$file" >/dev/null 2>&1 &
}

# Deferred "finished" notifier — re-invoked detached by the Stop path below.
# Waits until the transcript stops changing for CN_QUIET seconds, so a Stop that
# is immediately followed by more thinking/output coalesces into ONE notification
# at the true end instead of firing "finished" while Claude keeps working.
cn_deferred_stop() {
	local sid="$1" tok="$2" transcript="$3" loc="$4"
	local ef="${TMPDIR:-/tmp}/claude-notify/stop-$sid"
	local quiet="${CN_QUIET:-2}" busy=0 max="${CN_MAX_WAIT:-300}"
	local last now
	last=$(stat -f %m "$transcript" 2>/dev/null || echo 0)
	while :; do
		sleep "$quiet"
		[ "$(cat "$ef" 2>/dev/null)" = "$tok" ] || return 0   # a newer Stop superseded us
		now=$(stat -f %m "$transcript" 2>/dev/null || echo 0)
		[ "$now" = "$last" ] && break                          # transcript quiet -> truly idle
		last="$now"
		busy=$(( busy + 1 ))
		[ "$busy" -ge "$max" ] && return 0                     # still busy after a long time -> skip
	done
	cn_watching && return 0
	cn_notify "Claude Code — your turn" "${loc:+$loc — }Finished responding" Blow
}

# Run directly (not sourced) = hook mode.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
	# Detached second stage: wait for quiescence, then maybe notify.
	if [ "$1" = "--deferred-stop" ]; then
		cn_deferred_stop "$2" "$3" "$4" "$5"
		exit 0
	fi

	input=$(cat)
	event=$(printf '%s' "$input" | jq -r '.hook_event_name // empty')
	msg=$(printf '%s' "$input" | jq -r '.message // empty')
	cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
	sid=$(printf '%s' "$input" | jq -r '.session_id // empty')
	transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
	loc=$(cn_location "$cwd")

	case "$event" in
		Notification)
			# Drop the idle "waiting for your input" nudge (fires ~60s after a turn
			# ends): the Stop notification already said "your turn", nothing new to answer.
			case "$msg" in
				*"waiting for your input"*) exit 0 ;;
			esac
			# Otherwise a genuine "needs you now" (e.g. a permission prompt) — fire at once.
			cn_watching && exit 0
			cn_notify "Claude Code — needs you" "${loc:+$loc — }${msg:-Waiting for you}" Blow
			;;
		Stop)
			[ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = true ] && exit 0
			state_dir="${TMPDIR:-/tmp}/claude-notify"
			mkdir -p "$state_dir"
			tok="$$-${RANDOM}"   # unique per Stop; a later Stop overwrites and wins
			printf '%s' "$tok" > "$state_dir/stop-${sid:-default}"
			nohup "$0" --deferred-stop "${sid:-default}" "$tok" "$transcript" "$loc" \
				</dev/null >/dev/null 2>&1 &
			;;
	esac
fi
