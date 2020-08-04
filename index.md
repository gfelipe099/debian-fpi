# debian-fpi

A modified version of archfi for Debian, which I called Debian Fast Post-Installer, or Debian FPI, where you can install a desktop enviroment (currently GNOME and KDE Plasma); tools, drivers, applications, fix common issues and/or setup virtualization capabilities.

**All of the packages are delivered within Debian main repository only, 'contrib' and 'non-free' repositories were removed from the open-source edition.**

> Looking for the open-source version? Click <a href="https://github.com/gfelipe099/debian-fpi">here</a></p>

> Looking for the non-free version? Click <a href="https://github.com/gfelipe099/debian-fpi/tree/nonfree">here</a></p>

> Looking for testing branch? Click <a href="https://github.com/gfelipe099/debian-fpi/tree/testing">here</a>

## Statement before using Debian FPI
There are a few requirements which you have to do in order to use this script correctly or to even make it work correctly (this may change in the future):

For the **open-source version**, you explicitly need to:
> **Use the EXT4 filesystem in order to use a swap file.**

> **Not include a swap partition in your favorite or preferred partition scheme.**

> **Disallow, not use or disable the root account upon the installation or the script will fail in some areas.**

> **Disallow the use of non-free and contrib software.**

> **Deselect everything from the tasksel part: Debian desktop enviroment, printer software and basic system utilities. The script will handle that after.**

For the **nonfree** version, you explicitly need to:
> **Use the EXT4 filesystem in order to use a swap file.**

> **Not include a swap partition in your favorite or preferred partition scheme.**

> **Disallow, not use or disable the root account upon the installation or the script will fail in some areas.**

> **Allow the use of non-free and contrib software.**

> **Deselect everything from the tasksel part: Debian desktop enviroment, printer software and basic system utilities. The script will handle that after.**

## How to use
Copy and paste this command which will get you up and running:

Open-source version:
> wget -q https://git.io/JJKen && chmod a+x debian-fpi.sh && sudo ./debian-fpi.sh

Non-free version:
> wget -q https://git.io/JJKel && chmod a+x debian-fpi-nonfree.sh && sudo ./debian-fpi-nonfree.sh

## Why to execute the script as sudo?
Sudo permissions are required, because it modifies system settings.
