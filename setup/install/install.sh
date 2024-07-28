#!/bin/bash

# Minimal install script to get started

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile 
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing basic packages..."
brew install git

echo "Clone dotfiles repo..."
git clone https://github.com/ducktordanny/.dotfiles ~/.config/.dotfiles
cd ~/.config/.dotfiles
git remote set-url origin git@github.com:ducktordanny/.dotfiles.git

echo "Done. ✅"

echo "Next steps:"
echo "Run other setup scripts in `~/.config/.dotfiles/setup/install/`, there may be some dependencies between the scripts. Recommended order:"
echo -e "\t- terminal.sh"
echo -e "\t- fonts.sh"
echo -e "\t- gui.sh"
echo -e "\t- config.sh"
