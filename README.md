# debian-fpi
A modified version of archfi for Debian, which I called Debian Fast Post-Installer, or Debian FPI, where you can install a desktop enviroment (currently GNOME and KDE Plasma); tools, drivers, applications, fix common issues and/or setup virtualization capabilities.

**All of the packages are delivered within Debian main repository only, 'contrib' and 'non-free' repositories were removed from this open-source edition.**

> Looking for the non-free version? Click <a href="https://github.com/gfelipe099/debian-fpi/tree/nonfree">here</a></p>
> Looking for the testing branch? Click <a href="https://github.com/gfelipe099/debian-fpi/tree/testing">here</a></p>

## Statement before using Debian FPI
There are a few requirements which you have to do in order to use this script correctly or to even make it work correctly (this may change in the future):

You explicitly need to:
> **Use the EXT4 filesystem in order to use a swap file.**

> **Not include a swap partition in your favorite or preferred partition scheme.**

> **Disallow, not use or disable the root account upon the installation or the script will fail in some areas.**

> **Disallow the use of non-free and contrib software.**

> **Deselect everything from the tasksel part: Debian desktop enviroment, printer software and basic system utilities. The script will handle that after.**

## How to use
Type this command into the terminal. It is large, but it will get you up and running:
> sudo apt update -y && sudo apt install -y wget && wget -q https://raw.githubusercontent.com/gfelipe099/debian-fpi/master/debian-fpi.sh && chmod a+x debian-fpi.sh && sudo ./debian-fpi.sh

## Why to execute the script as sudo?
Sudo permissions are required, because it modifies system settings.
