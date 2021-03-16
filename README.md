# debian-fpi
A modified version of archfi for Debian, which I called Debian Fast Post-Installer, or Debian FPI, where you can install a desktop enviroment (currently GNOME and KDE Plasma); tools, drivers, applications, fix common issues and/or setup virtualization capabilities.

## Stuff to consider for a correct usage
There are a few requirements which you have to do in order to use this script correctly or to even make it work correctly (this may change in the future):

You explicitly need to:  
- **Use any filesystem except BTRFS for swapfile support.**  
- **Not include a swap partition.**  
- **To have a working root account upon the installation or the script will fail.**  
- **Deselect everything from the tasksel part. The script will handle that after.**  

## How to use
Compile it first using `make` and launch it using `./debian-fpi`
