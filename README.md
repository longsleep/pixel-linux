## Assumptions

 - Chromebook Pixel is already in developer mode.
 - You are willing to shink Chrome OS (this will remove all data).

So just get this repository and extract it into ~/Downloads. You need to be able
to run the various scripts shipped in this repository. Afterwards Ubuntu is
installed alongside to Chrome OS.

## Shrink Chrome OS

  sudo bash shrink-chromeos

## Install Ubuntu

  The Chrome Book Pixel hardware works out of the box with Ubuntu 14.10. No
  extra equipment is required. This repository provides all the gear to install
  Ubuntu along side with Chrome OS. During this process Chrome OS will be
  shrinked and will reset all its data. You have been warned!

  sudo bash install-minimal

## Kernel settings

  - Add line `i915 modeset=1` into /etc/modules.
  - Add `tpm_tis.force=1 tpm_tis.interrupts=0` to GRUB_CMDLINE_LINUX_DEFAULT in
    /etc/default/grub and run `sudo update-grub` afterwards.

## Disable bluetooth on startup

  Edit /etc/rc.local and add `rfkill block bluetooth` before the `exit 0`.

## Hot keys

  - I use the CTRL key to rebind audio hotkeys in keyboard settings.
  - For keyboard backlight i use a custom trigger CTRL+TAB with my
    `pixel-keyboard-brightness` from my [bin-scripts](https://github.com/longsleep/bin-scripts) repository.
  - Display backlight keys can be bound to a custom action using `xdotool`.
    Install `xdotool` with apt-get and bind `xdotool key XF86MonBrightnessUp`
    and `xdotool key XF86MonBrightnessDown` to the designated keys within
    keyboard settings.


## Known issues

  - Chromebooks forget about Dev mode when completely out of battery. This is
    very annoying. See [here](http://dev.chromium.org/chromium-os/developer-information-for-chrome-os-devices/workaround-for-battery-discharge-in-dev-mode) for details.

## Dual boot with Chrome OS

  So now we have Ubuntu. Chrome OS is still there and functional. You can boot
  it from the boot screen with CTRL+D.

## Install Chromebrew

  [Chromebrew](http://skycocker.github.io/chromebrew/) is a package manager for
  Chrome OS which allows to easily install various tools into your Chrome OS
  environment. It installs directly into Chrome OS, no chroot what so ever.

    wget -q -O - https://raw.github.com/skycocker/chromebrew/master/install.sh | bash

  This gives you a decent start for working with Chrome OS on the command line,
  including Git support.

  Then try it out and install vim.

    crew install vim

  Yay!

## Install Chrome Dev editor

  [Chrome Dev Editor](https://chrome.google.com/webstore/detail/chrome-dev-editor-develop/pnoffddplpippgcfjdhbmhkofpnaalpg)
  is a Chrome App which works offline and provides you a Graphical Text editor.
  It supports Git directly (but do no use that) as it works great together with
  commandline Git. I use the Monokai color theme there as this is the theme i
  usually have in Sublime Text too.



