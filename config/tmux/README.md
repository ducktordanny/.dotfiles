# Tmux config

> This repo contains the plugins and preferences of my Tmux config, and also contains a JSON file with my iTerm2 profile that I'm using.

## Setup iTerm2 & Powerlevel10k

1. Install iTerm2

[Download it from here](https://iterm2.com/downloads.html)

2. Use the profile from this repo

You can import the profile by opening iTerm2 preferences (⌘+,) and then navigate to `Profiles` and at the bottom click on the `Other Actions... > Import JSON Profiles`.

[iterm2.profile.json](./iterm2.profile.json)

3. Install and setup Powerlevel10k

[Full manual for installation here](https://github.com/romkatv/powerlevel10k)

While going through its setup you'll be able to select [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts), it is highly recommended to use.

## Setup Tmux

After you went through the main README file and applied dotfiles, do the followings:

1. Clone package manager repository

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. Install tmux

With Homebrew:

```sh
brew install tmux
```

With apt:

```sh
sudo apt install -y tmux
```

3. Start Tmux & install packages

```sh
tmux
```

To install packages, press: `<C-Space>I`
