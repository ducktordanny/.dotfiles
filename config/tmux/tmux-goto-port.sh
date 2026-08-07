#!/bin/bash
# tmux MouseDown1Status handler for the dev-ports dots: given a "devport-<port>"
# range name, find the process serving that port and jump to its tmux pane.
#
# Handles two cases:
#   1. native listener — walk the listening PID's process tree to a pane shell.
#   2. published port (docker/podman -p, kubectl port-forward) — the host listener
#      is a proxy daemon (child of launchd, untraceable), so instead trace the
#      publisher CLI process, which is the one actually running in the pane.

range="$1"
port="${range##*-}"
case "$port" in '' | *[!0-9]*) exit 0 ;; esac

panes=$(tmux list-panes -a -F '#{pane_pid} #{session_name}:#{window_index}.#{pane_index}')

# Echo the tmux target of the first ancestor of $1 that owns a pane; else fail.
resolve() {
	local pid="$1" target=""
	while [ -n "$pid" ] && [ "$pid" -gt 1 ] 2>/dev/null; do
		target=$(printf '%s\n' "$panes" | awk -v p="$pid" '$1==p{print $2; exit}')
		[ -n "$target" ] && {
			printf '%s' "$target"
			return 0
		}
		pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
	done
	return 1
}

# Candidates in priority order: port publishers (run in a pane) before native listeners.
# Match the real publish syntax — `docker/podman -p [host:]<port>:` or `kubectl
# port-forward … <port>:` — so unrelated processes can't false-match. The [x] bracket
# tricks keep this awk's own command line from matching itself.
candidates=$(
	ps -Ao pid=,command= | awk -v pt="$port" '
		/[d]ocker|[p]odman/ && $0 ~ ("[-]p[ =]([0-9.]+:)?" pt ":") { print $1; next }
		/[p]ort-forward/ && $0 ~ ("[ =]" pt ":")                   { print $1 }
	'
	lsof -nP -iTCP:"$port" -sTCP:LISTEN -t 2>/dev/null
)

target=""
for pid in $candidates; do
	target=$(resolve "$pid") && break
done

if [ -n "$target" ]; then
	tmux switch-client -t "${target%%:*}"
	tmux select-window -t "$target"
	tmux select-pane -t "$target"
else
	tmux display-message ":$port is up but not traceable to a tmux pane"
fi
