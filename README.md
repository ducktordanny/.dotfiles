# Dotfiles

> All my config files for tmux, nvim, yabai and skhd can be found here. Some of these were originally in separate repositories though I thought it would be easier to manage all of them from one single repository, so here it is.

## Old repositories

As mentioned some of the configs had separate repos, those got archived, but can be seen here:

- [NeoVim](https://github.com/ducktordanny/nvim-config)
- [tmux](https://github.com/ducktordanny/tmux-config)

## Install

1. Get the install script:

`curl https://raw.githubusercontent.com/ducktordanny/.dotfiles/master/install.sh >> install.sh`

2. Run with bash:

`bash install.sh`

3. You might need to provide your password for brew installs, and press ENTER sometimes. After a few minutes the install should finish and then follow the prompted points.

### After install steps

1. You can close the default Terminal app and open WezTerm.
2. You should see the powerlevel10k configurator, choose your options as you like.
3. Go to the `~/.config/.dotfiles` folder and run `bash apply-dotfiles.sh`. After this, WezTerm might need to be restarted.
4. Open tmux by running the `tmux` command the install tmux plugins by `<C-Space>I`.
5. Open NeoVim by running `nvim`, then it should install the configured plugins, and LSPs.
   - After it finished you might need to do a `:TransparentEnable` to get a transparent background.
6. Open Karabiner-Elements, follow its access requets, then:
   - go to "Simple Modifications" and add mappings for "caps_lock" -> "left_control" and "left_control" -> "caps_lock"
   - go to "Complex Modifications" and add a rule for caps_lock to be mapped to command+control+option+shift. This will be your hyper key
7. In the `~/.config/.dotfiles` run: `git remote set-url origin git@github.com:ducktordanny/.dotfiles.git` and set an SSH key.
8. For other things and Mac OS system settings see the `~/.config/.dotfiles/MacOS.settings.md` (also see [here](https://github.com/ducktordanny/.dotfiles/blob/master/MacOS.settings.md)) file.
