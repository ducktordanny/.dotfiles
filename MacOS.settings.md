# Mac OS (Ventura) System Settings

> Some of my System Settings that I'm using for Mac OS and they are pretty handy.

## No fancy background

Go to `System Settings/Wallpaper` and set a full black background from the Colors section. (This way I can't see the notch, and I don't really look at my Desktop anyway soooooo yeah...)

## Repeat those keys...

Go to `System Settings/Keyboard` and set "Key repeat rate" to Fast (fully right) and "Delay until repeat" to Short (fully right). This way it can be faster to move around in NeoVim.

## Use those shortcuts and that Mission Control...

Use `C-Up` or your TrackPad and add new virtual Desktops up to 10. Then go to `System Settings/Keyboard/Keyboard Shortcuts.../Mission Control` and open down "Mission Control" in the list and enable all the option with "Switch to Desktop X". This will allow to jump between Desktops real fast, e.g.: to go to the first space press `C-1` and so on (C-0 will go to the 10th).

I usually use the first Desktop to have there my browser, then the second for iTerm third usually Teams, forth for other things like Discord, Messenger, etc.

## Spell check, why?

Go to `System Settings/Keyboard/Text Input/Input Source (US)/Edit...` and disable "Correct spelling automatically", "Capitalise words automatically", "Add full stop with double-space" and "Use smart quotes and dashes". Then enable "Show input menu in menu bar".

## Turn off those annoying ANIMATIONS..

Go to `System Settings/Accessibility/Display` and enable "Reduce motion". I just don't need those fancy animations... This makes Desktop switches much much faster.

## No Dock, just nooo

Go to `System Settings/Desktop & Dock` and:

- set "Size" to ~1/4
- enable "Automatically hide and show the Dock"
- disable "Animate opening applications"
- disable "Show recent applications in Dock"
- default web browser should be "Arc"
- disable "Automatically rearrange Spaces based on most recent use" (it is just stupid..)

## Hide default Menu Bar

Go to `System Settings/Desktop & Dock` and at the Menu Bar section set "Automatically hide and show the menu bar" to "Always". Since we have sketchybar installed and configured, the default one should not be shown.

## HOT

Go to `System Settings/Desktop & Dock/Hot Corners...` and remove "Quick Note" then add "Lock Screen" to the left bottom corner.

## Turn off display??

Go to `System Settings/Lock Screen` and set all the three options at the top to "Never".

## Finder finding things..

Go to `Finder/Settings/General` and enable "Hard disks", "External disks" and "Connected servers", then disable "CDs, DVDs and iPods". And at last, set the `$HOME` folder for "New Finder windows show:"
Go to `Finder/Settings/Tags` and remove everything.
Go to `Finder/Settings/Sidebar` and add the `$HOME` and "Pictures" folders to favorites
Open `Finder` and create a folder "Developer" inside the `$HOME` folder, then drag it to "Favorites" on the side

## Brew installed apps

<!-- TODO: Should finish this part as well, should add Alfred, etc. -->

### STATS

Open `iStat Menus` app enable "Combined" and there set it to: "CPU & GPU", "Memory", "Network". With "Register" you can add your license.

## App Store

Open `App Store` and install the following apps (you need to login to iCloud first):

- Yoink
- Final Cut Pro
- Hidden Bar
- Microsoft Remote Desktop
- Messenger (Optional)
