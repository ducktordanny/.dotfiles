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

# Claude Code lives in ~/.claude (not ~/.config), and the directory also holds
# live state (history, sessions, plugins), so copy files instead of wiping it.
mkdir -p ~/.claude/lib ~/.claude/themes ~/.claude/output-styles
cp -p ~/.config/.dotfiles/claude/settings.json ~/.claude/settings.json
cp -p ~/.config/.dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
cp -p ~/.config/.dotfiles/claude/keybindings.json ~/.claude/keybindings.json
cp -p ~/.config/.dotfiles/claude/statusline.sh ~/.claude/statusline.sh
cp -p ~/.config/.dotfiles/claude/lib/claude-notify.sh ~/.claude/lib/claude-notify.sh
cp -p ~/.config/.dotfiles/claude/themes/*.json ~/.claude/themes/
cp -p ~/.config/.dotfiles/claude/output-styles/*.md ~/.claude/output-styles/

tmux source ~/.config/tmux/tmux.conf
# yabai --restart-service
# skhd --restart-service
# sketchybar --reload
cd "$current"
