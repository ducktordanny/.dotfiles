# Dotfiles

> All my config files for tmux, nvim, yabai and skhd can be found here. Some of these were originally in separate repositories though I thought it would be easier to manage all of them from one single repository, so here it is.

## Old repositories

As mentioned some of the configs had separate repos, those got archived, but can be seen here:

- [NeoVim](https://github.com/ducktordanny/nvim-config)
- [tmux](https://github.com/ducktordanny/tmux-config)

## Install

1. Get the install script:

`curl https://raw.githubusercontent.com/ducktordanny/.dotfiles/master/setup/install/install.sh >> install.sh`

2. Run with bash:

`bash install.sh`

3. After the install script finishes follow the prompted steps and run the setup other scripts.

### Some steps after install & setup

- Open tmux by running the `tmux` command the install tmux plugins by `<C-Space>I`.
- Open NeoVim by running `nvim`, then it should install the configured plugins, and LSPs.
  - After it finished you might need to do a `:TransparentEnable` to get a transparent background.
- Open Karabiner-Elements, follow its access requets, then:
  - go to "Simple Modifications" and add mappings for "caps_lock" -> "left_control" and "left_control" -> "caps_lock"
  - go to "Complex Modifications" and add a rule for caps_lock to be mapped to command+control+option+shift. This will be your hyper key
- For other things and Mac OS system settings see the `~/.config/.dotfiles/MacOS.settings.md` (also see [here](https://github.com/ducktordanny/.dotfiles/blob/master/setup/MacOS.settings.md)) file.
