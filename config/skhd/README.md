# skhd

> Custom keymappings mainly for yabai at the moment

## Install

brew install koekeishiya/formulae/skhd

## Service

Start service:

```sh
skhd --start-service
```

Restart service:

```sh
skhd --restart-service
```

After any changes you'll need to restart the service, though if you use the `bash apply-dotfiles.sh` command it will do it automatically.

## Karabiner-Elements

Under the complex modifiers, create a hyper key which converts capslock into ctrl+alt+command+shift.

NOTE: In Karabiner-Elements > Devices there are two keychron instances and the one with two icons should be used
