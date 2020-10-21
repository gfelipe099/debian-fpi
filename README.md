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
With a recent update now it requires two arguments to run:  
**language** and **repository**
  - For **language** there are two options:  
    - `es`, `en` or `fr`  
    
    [Spanish (Spain), English (US) and Français (France) respectively]  
  
  - For **repository** there are two options:  
    - `free` and `nonfree`

Knowing this type this command into the terminal, changing the arguments to your liking. These are the defaults:  
`wget -q https://git.io/JJKen && sudo sh debian-fpi.sh en free`


## Why to execute the script as sudo?
Sudo permissions are required, because it modifies system settings.
