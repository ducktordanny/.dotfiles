#!/bin/bash

# NOTE: This script collects the config folders from this repo and copies them under ~/.config/ folder, and then restart some of their services or reattach them.

current="$PWD"
cd ~/.config/.dotfiles/config

folders=()
for item in */; do
    if [ -d "$item" ]; then
        folders+=("$item")
    fi
done
for folder in "${folders[@]}"; do
    rm -rf ~/.config/$folder/*
    cp -r ~/.config/.dotfiles/config/$folder ~/.config/$folder
done

tmux source ~/.config/tmux/tmux.conf
# yabai --restart-service
# skhd --restart-service
# sketchybar --reload
cd "$current"
