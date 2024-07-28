#!/bin/bash

echo "Apply dotfiles config directories"
bash ~/.config/.dotfiles/setup/apply-config.sh

echo "Run tmux install script"
bash ~/.config/.dotfiles/config/tmux/install.sh

echo "Start services for yabai, skhd, and sketchybar"
yabai --start-service
skhd --start-service
brew services start sketchybar

echo "Adding some magic to zshrc"
echo "fortune | cowsay -f tux" >> ~/.zshrc

echo "Done. ✅"
