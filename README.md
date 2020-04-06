# debian-fpi
A modified version of archfi for Debian, which I called Debian Fast Post-Installer, or Debian FPI, where you can install a desktop enviroment (currently GNOME and KDE Plasma (under testing)); tools, drivers, applications and the ability to setup virtualization stuff.

## Statement before using Debian FPI
There are a few requirements which you have to do in order to use this script correctly or to even make it work correctly (this will change in the future):

You explicitly need:
> Disallow, not use or disable the root account upon the installation or the script will fail in some areas.
> To allow the use of non-free and contrib software.
> Deselect everything from the tasksel part: Debian desktop enviroment, printer software and basic system utilities. The script will handle that after.

## How to use
Clone the repository:
> git clone https://github.com/gfelipe099/debian-fpi

Go to the repository's folder:
> cd debian/fpi

Make the script executable:
> chmod a+x debian-fpi.sh

And now execute it with sudo*:
> sudo ./debian-fpi.sh

* Sudo permissions are required, because it modifies system related stuff. Although, **do not use this script in your daily driver machine until it's declared stable**.
