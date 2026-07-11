#!/bin/bash
# tmux status module: Claude subscription session usage — the 5h-window
# "Current session" percentage from /usage. State file ("<pct> <resets_at>")
# is published by ~/.claude/statusline.sh on every statusline render.

f="$HOME/.cache/claude/session-usage"
[ -f "$f" ] || exit 0

read -r pct resets < "$f"
case "$pct" in '' | *[!0-9]*) exit 0 ;; esac
[ "$pct" -gt 100 ] && pct=100

# Data captured before the window reset is stale — hide instead of misleading
case "$resets" in
	'' | *[!0-9]*) resets=0 ;;
esac
[ "$resets" -gt 0 ] && [ "$resets" -lt "$(date +%s)" ] && exit 0

# Rose Pine palette: foam (plenty) / gold (getting full) / love (nearly full)
if [ "$pct" -ge 80 ]; then
	color="#eb6f92"
elif [ "$pct" -ge 50 ]; then
	color="#f6c177"
else
	color="#9ccfd8"
fi

width=10
filled=$((pct * width / 100))
[ "$filled" -eq 0 ] && [ "$pct" -gt 0 ] && filled=1
bar=""
for ((i = 0; i < width; i++)); do
	[ "$i" -lt "$filled" ] && bar+="█" || bar+="░"
done

reset_at=""
[ "$resets" -gt 0 ] && reset_at=$(date -r "$resets" '+%H:%M' 2>/dev/null)

printf '✳ #[fg=%s]%s %s%%#[fg=default]%s ' \
	"$color" "$bar" "$pct" "${reset_at:+ #[fg=#6e6a86]↻ $reset_at#[fg=default]}"
