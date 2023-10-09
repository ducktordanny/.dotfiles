# DucktorDanny NeoVim config

> This repository includes all the configurations that I use.

## Details

I use the LazyNvim package manager to install and use plugins. The used plugins can be found under the `lua/ducktordanny/plugins` folder. In its init file there are some basic plugins and configurations, and the other ones are separated into two other files based on their purposes.

The other settings and remaps can be seen in the `lua/ducktordanny/settings.lua` file and `lua/ducktordanny/remaps` folder.

## Notes

- For telescope to work properly, you'll need to install ripgrep ([https://github.com/BurntSushi/ripgrep#installation](https://github.com/BurntSushi/ripgrep#installation)).
- For lazygit.nvim you may need to install lazygit separately (though I'm not sure about that... 🤷)

## LazyGit

As of right now, when I open LazyGit from NeoVim the selected lines had a pretty bad contrast. However, this can be resolved easily by editing the default config:

Default path for the config file:

- Linux: ~/.config/lazygit/config.yml
- MacOS: ~/Library/Application Support/lazygit/config.yml
- Windows: %APPDATA%\lazygit\config.yml

And then put this there:

```yml
gui:
  theme:
    selectedLineBgColor:
      - reverse
    selectedRangeBgColor:
      - reverse
```

This will set the highlight color to black, which is imo much better than the original one.
