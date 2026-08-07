#!/bin/bash
# tmux status module: dev-server indicators (clickable → jump to the pane).
# Each entry is a #[range=user|devport-<port>] hotspot; MouseDown1Status routes
# clicks to tmux-goto-port.sh. Foam = listening, muted = down.
# Icons are Nerd Font glyphs written as \x byte escapes so the source stays ASCII.

up="#9ccfd8"
down="#6e6a86"

labels=(portal api mock ai storybook)
ports=(4200 8001 3000 4300 4400)
icons=(
	$'\xef\x82\xac' #  globe   (portal)
	$'\xef\x88\xb3' #  server  (api)
	$'\xef\x83\x83' #  flask   (mock)
	$'\xf3\xb0\x9a\xa9' # 󰚩 robot (ai)
	$'\xef\x80\xad' #  book    (storybook)
)

# One snapshot of all TCP listeners — catches IPv4, IPv6 (e.g. storybook on [::1])
# and docker-proxied (*:port) binds alike, matching what tmux-goto-port.sh resolves.
listeners=$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null)

out=""
for index in "${!labels[@]}"; do
	port=${ports[$index]}
	if printf '%s\n' "$listeners" | grep -q ":$port (LISTEN)"; then
		color=$up
	else
		color=$down
	fi
	out+="#[range=user|devport-$port]#[fg=$color]${icons[$index]} ${labels[$index]}#[fg=default]#[norange] "
done

printf '%s' "$out"
