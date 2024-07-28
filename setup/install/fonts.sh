#!/bin/bash

echo "Installing fonts..."
mkdir ~/.fonts
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output ~/.fonts/MesloLGS%20NF%20Regular.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output ~/.fonts/MesloLGS%20NF%20Bold.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output ~/.fonts/MesloLGS%20NF%20Italic.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output ~/.fonts/MesloLGS%20NF%20Bold%20Italic.ttf

brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install font-sf-pro
brew install --cask sf-symbols

echo "Done. ✅"
