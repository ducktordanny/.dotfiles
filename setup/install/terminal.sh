#!/bin/bash

# Install basic terminal packages and related stuff

echo "Installing WezTerm"
brew install --cask wezterm

echo "Installing terminal packages..."
brew install node nvm neovim koekeishiya/formulae/yabai koekeishiya/formulae/skhd ripgrep docker fzf fortune cowsay go
npm install -g yarn

echo "Installing other terminal related things..."
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

echo "Install thingies for custom menu bar (SketchyBar)"
brew tap FelixKratz/formulae
brew install sketchybar
brew install jq

echo "Done. ✅"

echo "Next steps:"
echo -e "\t- Quit current terminal and open WezTerm."
echo -e "\t- Set up powerlevel10k preferences (it will come up right away)."
