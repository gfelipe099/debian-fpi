# debian-fpi
A modified version of archfi for Debian, which I called Debian Fast Post-Installer, or Debian FPI, where you can install a desktop enviroment (currently GNOME and KDE Plasma (under testing)); tools, drivers, applications and the ability to setup virtualization stuff.

## Statement before using Debian FPI
There are a few requirements which you have to do in order to use this script correctly or to even make it work correctly (this may change in the future):

You explicitly need to:
> **Use the EXT4 filesystem in order to use a swap file.**

> **Not include a swap partition in your favorite or preferred partition scheme.**

> **Disallow, not use or disable the root account upon the installation or the script will fail in some areas.**

> **Allow the use of non-free and contrib software.**

> **Deselect everything from the tasksel part: Debian desktop enviroment, printer software and basic system utilities. The script will handle that after.**

## How to use
Copy and paste this command which will get you up and running:
> sudo apt update && sudo apt install git && git clone https://github.com/gfelipe099/debian-fpi && cd debian-fpi/ && chmod a+x debian-fpi.sh && sudo ./debian-fpi.sh

## Why execute the script as sudo?
Sudo permissions are required, because it modifies system related stuff. Although, I encourage you **to not use this script in your daily driver machine until it's declared "rock solid" stable**.
