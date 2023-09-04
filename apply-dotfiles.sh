#!/bin/bash

# NOTE: This script collects the config folders from this repo and copies them under ~/.config/ folder, and then restart some of their services or reattach them.

script_path="$(readlink -f "$0")"
script_directory="$(dirname "$script_path")"

folders=()
for item in */; do
    if [ -d "$item" ]; then
        folders+=("$item")
    fi
done
for folder in "${folders[@]}"; do
    cp -r $script_directory/$folder ~/.config/$folder
done

tmux source ~/.config/tmux/tmux.conf
yabai --restart-service
skhd --restart-service
