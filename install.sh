#!/bin/bash

# !!! WIP !!!

# Install most of the apps and packages that I use based on the TOOLS.md file

# install homebrew
echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/testmachine/.zprofile 
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing basic packages..."
brew install node git nvm neovim koekeishiya/formulae/yabai koekeishiya/formulae/skhd ripgrep docker fzf
npm install -g yarn

echo "Installing nerd fonts..."
mkdir ~/.fonts
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output ~/.fonts/MesloLGS%20NF%20Regular.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output ~/.fonts/MesloLGS%20NF%20Bold.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output ~/.fonts/MesloLGS%20NF%20Italic.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output ~/.fonts/MesloLGS%20NF%20Bold%20Italic.ttf

echo "Installing terminal related things..."
brew install --cask iterm2
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

echo "Installing GUI applications..."
brew install --casks istat-menus karabiner-elements alfred insomnia discord arc figma microsoft-teams gimp vlc obs coconutbattery

echo "Clone dotfiles repo..."
git clone https://github.com/ducktordanny/.dotfiles ~/.config/.dotfiles
cd ~/.config/.dotfiles

bash ~/.config/.dotfiles/config/tmux/install.sh

echo "Start services for yabai and skhd"
yabai --start-service
skhd --start-service

echo "Adding some magic to zshrc"
echo "fortune | cowsay -f tux" >> ~/.zshrc

echo "Done. ✅"

echo "Next steps:"
echo -e "\t- Quit current terminal and open iTerm."
echo -e "\t- Set up powerlevel10k preferences (it will come up right away)."
echo -e "\t- Then cd into ~/.config/.dotfiles and run 'bash apply-dotfiles'"

echo "Some other stuff:"
echo -e "\t- Add necessary access to some application like Karabiner-Elements."
echo -e "\t- Create hyper key in Karabiner-Elements under Complex modifications."
