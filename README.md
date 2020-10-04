# debian-fpi
A modified version of archfi for Debian, which I called Debian Fast Post-Installer, or Debian FPI, where you can install a desktop enviroment (currently GNOME and KDE Plasma); tools, drivers, applications, fix common issues and/or setup virtualization capabilities.

## Statement before using Debian FPI
There are a few requirements which you have to do in order to use this script correctly or to even make it work correctly (this may change in the future):

You explicitly need to:  
- **Use the EXT4 filesystem in order to use a swap file.**  
- **Not include a swap partition.**  
- **Have a working root account upon the installation or the script will fail.**  
- **Deselect everything from the tasksel part. The script will handle that after.**  

## How to use
Type this command into the terminal. It is large, but it will get you up and running:  
`wget -q https://git.io/JUd8k && sudo sh debian-fpi en free`

## Why to execute the script as sudo?
Sudo permissions are required, because it modifies system settings.
