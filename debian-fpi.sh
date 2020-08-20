#!/bin/bash

#
# Created by Liam Powell (gfelipe099)
# A fork from MatMoul's https://github.com/MatMoul/archfi
# debian-fpi.sh file
# For Debian GNU/Linux 10.2/10.3/10.4/10.5 (buster) desktop amd64
#
appTitle="Debian Fast Post-Installer Setup v202000816.0-stable (Release Build)"

#
# text formatting codes
# source https://github.com/nbros652/LUKS-guided-manual-partitioning/blob/master/LGMP.sh
#
normalText='\e[0m'
boldText='\e[1m'
yellow='\e[93m'
green='\e[92m'
red='\e[91m'

#
# check if running as root
#
if [ "$(whoami)" != "root" ]; then
    echo -e "${boldText}${red}This script must be executed as root."${normalText}
    exit 0
fi

#
# install this package to check which OS is running
#
apt install -yy lsb-release &>/dev/null

#
# check if the OS is Debian
# credits to https://unix.stackexchange.com/users/33967/joeytwiddle, https://danielgibbs.co.uk
# source: https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script, https://danielgibbs.co.uk/2013/04/bash-how-to-detect-os/
#

distroInfo="Debian $(cat /etc/debian_version) $(uname -r)"
distroSystem="$(lsb_release -ds)"

root(){
        if [[ "$distroSystem" = "Debian GNU/Linux 10 (buster)" ]]; then
            if [[ "$distroInfo" = "Debian 10.2 4.19.0-6-amd64" || "Debian 10.3 4.19.0-8-amd64" || "Debian 10.4 4.19.0-9-amd64" || "Debian 10.5 4.19.0-10-amd64" ]]; then
                mainMenu
            else
                whiptail --title "${txtnotsupportedyet}" --fb --ok-button "${txtok}" --msgbox "${txtnotsupportedyetdesc}" 10 65
                exit 0
            fi
        else
            whiptail --title "${txtunsupportedsystem}" --fb --ok-button "${txtok}" --msgbox "${txtunsupportedsystemdesc}" 13 90
            exit 1
        fi
}

chooseLanguage(){
    #
    # credits to: https://stackoverflow.com/users/1343979/bass
    # source: https://stackoverflow.com/questions/46619539/changing-colours-in-whiptail
    #
    export NEWT_COLORS='root=,black'
    language=$(whiptail --inputbox "${chooselanguage}" 12 85 en --fb --ok-button "${txtok}" --nocancel --title "Choose Language - Elegir idioma" 3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
        clear
        if [ ${language} = "en" ]; then
            loadstrings_us
            root
        elif [ ${language} = "es" ]; then
            loadstrings_es
            root
        fi
    fi
}

 changeLanguage(){
    sel=$(whiptail --backtitle "${appTitle}" --title "${txtlanguage}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
        "${lang_us}" "${langdesc}" \
        "${lang_es}" "${langdesc}" \
        3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
        clear
        if [ "${sel}" = "${lang_us}" ]; then
            loadstrings_us
        elif [ "${sel}" = "${lang_es}" ]; then
            loadstrings_es
        fi
    fi
}

# ------------------------------------------------- script beginning ------------------------------------------------- #

mainMenu(){
    #
    # credits to: https://stackoverflow.com/users/1343979/bass
    # source: https://stackoverflow.com/questions/46619539/changing-colours-in-whiptail
    #
    export NEWT_COLORS='root=,blue'
    sel=$(whiptail --backtitle "${appTitle}" --title "${txtmainmenu}" --fb --ok-button "${txtok}" --menu "${txtyoursys}${distroInfo}" --cancel-button "${txtexit}" 0 0 0 \
        "${txtlanguage}" "${txtlanguagedesc}" \
        "" "" \
        "${txtbasesetup}" "${txtbasedesc}" \
        "${txtextrassetup}" "${txtextrasdesc}" \
        "" "" \
        "${txtbasicvirtualization}" "${txtbasicvirtualizationdesc}" \
        "${txtvirtualization}" "${txtvirtualizationdesc}" \
        "" "" \
        "${txtfixes}" "${txtfixesdesc}" \
        "${txtreboot}" "${txtrebootdesc}" 3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
        case ${sel} in
            "${txtlanguage}")
                changeLanguage
                nextitem="${txtbasesetup}"
            ;;
            "${txtbasesetup}")
                baseSetup
                nextitem="${txtextrassetup}"
            ;;
            "${txtextrassetup}")
                extrasSetup
                nextitem="${txtvirtualization}"
            ;;
            "${txtvirtualization}")
                virtualizationSetup
                nextitem="${txtfixes}"
            ;;
            "${txtbasicvirtualization}")
                basicVirtualizationSetup
                nextitem="${txtfixes}"
            ;;
            "${txtfixes}")
                fixesSetup
                nextitem="${txtreboot}"
            ;;
            "${txtreboot}")
                reboot
                nextitem="${txtreboot}"
            ;;
        esac
        mainMenu "${nextitem}"
    else
        clear
    fi
}

reboot(){
    if (whiptail --backtitle "${appTitle}" --title "${txtreboottitle}" --fb --yesno "${txtreboot}?" --defaultno 10 20); then
        clear
        sudo reboot
    fi
}

systemReadiness(){
    #
    # credits to: https://stackoverflow.com/users/1343979/bass
    # source: https://stackoverflow.com/questions/46619539/changing-colours-in-whiptail
    #
    export NEWT_COLORS='root=,black'
    {
        sleep 1
        echo -e "XXX\49\nChecking for updates and installing them if any...\nXXX"
        apt-get update -yy &>/dev/null
        apt-get upgrade -yy &>/dev/null
        sleep 16.5

        echo -e "XXX\81\nGenerating clean APT file '/etc/apt/sources.list'...\nXXX"
        printf '#
# DEBIAN REPOSITORIES
#
deb http://deb.debian.org/debian/ buster main
deb-src http://deb.debian.org/debian/ buster main
deb http://security.debian.org/debian-security buster/updates main
deb-src http://security.debian.org/debian-security buster/updates main
deb http://deb.debian.org/debian/ buster-updates main
deb-src http://deb.debian.org/debian/ buster-updates main
deb http://deb.debian.org/debian/ buster-backports main
deb-src http://deb.debian.org/debian/ buster-backports main' > /etc/apt/sources.list

        echo -e "XXX\n100\nDone. Starting script...\nXXX"
        sleep 5

        break
    } | whiptail --backtitle "${txtextrassetup_sysreadiness}" --gauge "Please wait..." 8 70 0
}

baseSetup(){
    options=()
    options+=("${txtsetupbaseinstalldesktop}" "${txtsetupbaseinstalldesktopdesc}")
    options+=("${txtsetupbaseswapfile4g}" "${txtsetupbaseswapfile4gdesc}")
    options+=("${txtsetupbaseswapfile8g}" "${txtsetupbaseswapfile8gdesc}")
    sel=$(whiptail --backtitle "${appTitle}" --title "${txtbasesetup}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
        "${options[@]}" \
        3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
        clear
        if [ "${sel}" = "${txtsetupbaseswapfile4g}" ]; then
            {
                sleep 0.5
                echo -e "XXX\n20\nAllocating 4 GiB to the new file '/swapfile'... \nXXX"
                fallocate -l 4G /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n40\nSecuring file '/swapfile' with permissions 0600... \nXXX"
                chmod 0600 /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n60\nMaking swap with label 'swap' on file '/swapfile'... \nXXX"
                mkswap -L swap /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n80\Activating swap on file '/swapfile'... \nXXX"
                swapon /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n100\nAdding swap entry to '/etc/fstab'... \nXXX"
                echo "/swapfile swap swap sw 0 0" >> /etc/fstab
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtsetupbaseswapfile4g}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtsetupbaseswapfile8g}" ]; then
            {
                sleep 1
                echo -e "XXX\n20\nAllocating 8 GiB to the new file '/swapfile'... \nXXX"
                fallocate -l 8G /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n40\nSecuring file '/swapfile' with permissions 0600... \nXXX"
                chmod 0600 /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n60\nMaking swap with label 'swap' on file '/swapfile'... \nXXX"
                mkswap -L swap /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n80\Activating swap on file '/swapfile'... \nXXX"
                swapon /swapfile &>/dev/null
                sleep 1

                echo -e "XXX\n100\nAdding swap entry to '/etc/fstab'... \nXXX"
                echo "/swapfile swap swap sw 0 0" >> /etc/fstab
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtsetupbaseswapfile8g}" --gauge "Please wait..." 8 70 0
            nextitem="."
        fi
        if [ "${sel}" = "${txtsetupbaseinstalldesktop}" ]; then
            options=()
            options+=("GNOME" "${txtmadeby}")
            options+=("KDE Plasma" "${txtmadeby}")
            options+=("Xfce" "${txtmadeby_wip}")
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtsetupbaseselectdesktop}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
            "${options[@]}" \
            3>&1 1>&2 2>&3)
        if [ "$?" = "0" ]; then
            clear
            if [ "${sel}" = "GNOME" ]; then
                {
                    sleep 1
                    echo -e "XXX\n50\nInstalling GNOME Display Manager... \nXXX"
                    apt-get install -yy gdm3* &>/dev/null
                    sleep 60
                    echo -e "XXX\n100\nGNOME Display Manager was installed successfully. Returning to main menu\nXXX"
                    sleep 5
                } | whiptail --backtitle "${appTitle}" --title "GNOME" --gauge "Please wait..." 10 70 0
                nextitem="."
            elif [ "${sel}" = "KDE Plasma" ]; then
                {
                    sleep 1
                    echo -e "XXX\n50\nInstalling KDE Display Manager... \nXXX"
                    apt-get install -yy sddm* &>/dev/null
                    apt-get purge -yy discover plasma-discover kinfocenter xterm --autoremove &>/dev/null
                    sleep 50

                    echo -e "XXX\n100\nKDE Display Manager was installed successfully. Returning to main menu\nXXX"
                    sleep 5
                } | whiptail --backtitle "${appTitle}" --title "${txtsetupbaseinstalldesktop}" --gauge "Please wait..." 10 70 0
                nextitem="."
            elif [ "${sel}" = "Xfce" ]; then
                {
                    sleep 1
                    echo -e "XXX\n50\nInstalling Xfce core packages... \nXXX"
                    apt-get install -yy xfwm4 xfdesktop4 xfce4-panel xfce4-panel xfce4-settings xfce4-power-manager xfce4-session xfconf xfce4-notifyd &>/dev/null
                    sleep 60
                    echo -e "XXX\n100\Xfce core packages were successfully installed. \nXXX"
                    sleep 5
                } | whiptail --backtitle "${appTitle}" --title "${txtsetupbaseinstalldesktop}" --gauge "Please wait..." 8 70 0
                nextitem="."
            fi
        fi
    fi
fi
}

extrasSetup(){
    options=()
    options+=("${txtextrassetup_sysreadiness}" "(Required for the latest updates)")
    options+=("${txtextrassetup_bsystools}" "(Install basic system tools)")
    options+=("${txtextrassetup_bsystools_gnome}" "(Install GNOME basic tools)")
    options+=("${txtextrassetup_bsystools_kde}" "(Install KDE basic tools)")
    options+=("${txtextrassetup_bsystools_xfce}" "(Install XFCE basic tools)")
    options+=("${txtextrassetup_bsystools_xfce_plugins}" "(Install XFCE basic plugins)")
    options+=("${txtextrassetup_webbrowser}" "(Install a web browser)")
    options+=("${txtextrassetup_officesuite}" "(Install LibreOffice)")
    options+=("${txtextrassetup_gaming}" "(Install software made to play games)")
    options+=("${txtextrassetup_multimedia}" "(Install software for multimedia purposes)")
    options+=("${txtextrassetup_amd_intel}" "(Install Mesa and Vulkan open source drivers)")
    options+=("${txtextrassetup_material_debian}" "(Installs material focused themes, icons and fonts)")
    sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
        "${options[@]}" \
        3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
        clear
        if [ "${sel}" = "${txtextrassetup_sysreadiness}" ]; then
            systemReadiness
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_bsystools}" ]; then
            pkgs=""
            options=()
            options+=("fail2ban" "Network monitoring tool which bans hosts that cause multiple authentication errors" on)
            options+=("selinux-basics" "Basic SELinux stuff for easier installation" on)
            options+=("selinux-policy-default" "SELinux default policies" on)
            options+=("htop" "Command-line system monitor" off)
            options+=("terminator" "Terminator terminal" off)
            options+=("neofetch" "Command-line system information tool" off)
            options+=("gufw" "Graphical uncomplicated firewall" on)
            options+=("clamtk" "Graphical front-end for Clam Antivirus" on)
            options+=("gcc" "GNU C Compiler" on)
            options+=("make" "Building utility" on)
            options+=("firmware-linux" "Open-source firmware for devices" on)
            options+=("curl" "Command-line tool to transferring data" on)
            options+=("linux-headers-$(uname -r)" "Linux headers files" on)
            options+=("build-essentials" "Tools required for building from source" on)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_gnome}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get update -yy &>/dev/null
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring GNOME Basic System Tools... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null
                sleep 50
                
                if [[ ${pkgs} = *"selinux-basics"* ]]; then
                    if [[ ${pkgs} = *"selinux-policy-default"* ]]; then
                        cp /etc/selinux/config /etc/selinux/config.backup
                        printf '# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# enforcing - SELinux security policy is enforced.
# permissive - SELinux prints warnings instead of enforcing.
# disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of these two values:
# default - equivalent to the old strict and targeted policies
# mls     - Multi-Level Security (for military and educational use)
# src     - Custom policy built from source
SELINUXTYPE=mls

# SETLOCALDEFS= Check local definition changes
SETLOCALDEFS=0' > /etc/selinux/config
                    fi
                fi

                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_gnome}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_bsystools_gnome}" ]; then
            pkgs=""
            options=()
            options+=("nautilus" "GNOME file manager" on)
            options+=("network-manager-openvpn-gnome" "OpenVPN plugin for GNOME" off)
            options+=("gnome-terminal" "GNOME terminal" on)
            options+=("gedit" "GNOME text editor" on)
            options+=("clamtk-gnome" "ClamTk integration with GNOME" on)
            options+=("gnome-disk-utility" "GNOME disk utility" on)
            options+=("gnome-system-monitor" "GNOME system monitor" on)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_gnome}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring GNOME Basic System Tools... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null
                sleep 50

                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_gnome}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_bsystools_kde}" ]; then
            pkgs=""
            options=()
            options+=("plasma-nm" "Plasma applet for managing network connections" on)
            options+=("dolphin" "KDE file manager" on)
            options+=("konsole" "KDE terminal" on)
            options+=("kate" "KDE advanced text editor" on)
            options+=("kwin-x11" "Window manager for X11" on)
            options+=("kwin-wayland" "Window manager for Wayland" on)
            options+=("gparted" "GNOME partition editor" off)
            options+=("ksysguard" "KDE system monitor" on)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_kde}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get update &>/dev/null
                apt-get upgrade -yy &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring KDE basic system tools... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null
                sleep 50

                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_kde}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_bsystools_xfce}" ]; then
            pkgs=""
            options=()
            options+=("thunar" "File manager for Xfce" on)
            options+=("mousepad" "Xfce text editor" on)
            options+=("ristretto" "Lightweight picture-viewer for Xfce" on)
            options+=("xfce4-taskmanager" "Process manager for Xfce" on)
            options+=("xfce4-screenshooter" "Screenshots utility for Xfce" off)
            options+=("xfce4-terminal" "Xfce terminal emulator" on)
            options+=("xfce4-notes" "Notes application for Xfce" off)
            options+=("xfce4-goodies" "Enhancements for Xfce" on)
            options+=("xfce4-appfinder" "Application finder for Xfce" on)
            options+=("xfce4-clipman" "Clipboard history utility for Xfce" off)
            options+=("xfwm4-themes" "Theme files for xfwm4" on)
            options+=("xfburn" "CD-burner application for Xfce" off)
            options+=("orage" "Calendar for Xfce" off)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_xfce}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring Xfce basic system tools... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null
                sleep 50

                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_xfce}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_webbrowser}" ]; then
            pkgs=""
            options=()
            options+=("firefox-esr" "Mozilla's official web browser (Extended Support Release) (GTK)" on)
            options+=("chromium" "Chromium open-source web browser (GTK)" off)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_webbrowser}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring web browser(s)... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null

                sleep 30
                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_webbrowser}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_officesuite}" ]; then
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring office suite software... \nXXX"
                apt-get install -yy libreoffice &>/dev/null
                sleep 50
                
                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_officesuite}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_gaming}" ]; then
            pkgs=""
            options=()
            options+=("pcsx2" "PlayStation 2 (PS2) Emulator (GTK)" off)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_gaming}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring gaming software... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null

                sleep 30
                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_gaming}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_multimedia}" ]; then
            pkgs=""
            options=()
            options+=("gimp" "GNU Image Manipulation Image (GTK)" off)
            options+=("obs-studio" "Software for recording and streaming" off)
            sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_multimedia}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if [ ! "$?" = "0" ]; then
                return 1
            fi
            for itm in $sel; do
                pkgs="$pkgs $(echo $itm | sed 's/"//g')"
            done
            clear
            {
                sleep 5
                echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                apt-get update &>/dev/null
                apt-get -yy upgrade &>/dev/null
                sleep 20

                echo -e "XXX\n50\nInstalling and configuring multimedia software... \nXXX"
                apt-get install -yy ${pkgs} &>/dev/null

                sleep 30
                echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_multimedia}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_amd_intel}" ]; then
                while true; do
                    read -p "${txtextrassetup_amd_intel_dialog}" input
                    case $input in
                            [Yy]* ) {
                                        sleep 5
                                        echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                                        apt-get -yy upgrade &>/dev/null
                                        sleep 20

                                        echo -e "XXX\n50\nInstalling and configuring Mesa/Vulkan open-source drivers... \nXXX"
                                        apt-get install -yy libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 &>/dev/null
                                        sleep 30

                                        echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                                        sleep 5
                                    } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_amd_intel}" --gauge "Loading..." 8 70 0; break;;
                            [Nn]* ) break;;
                            * ) echo -e ${red}"Error. '$input' is out of range. Try again with Y or N."${normalText};;
                    esac
                done
            nextitem="."
        elif [ "${sel}" = "${txtextrassetup_material_debian}" ]; then
                while true; do
                    read -p "${txtextrassetup_material_debian_dialog}" input
                    case $input in
                            [Yy]* ) {
                                        sleep 5
                                        echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
                                        apt-get -yy upgrade &>/dev/null
                                        sleep 20

                                        echo -e "XXX\n50\nInstalling and configuring Material Debian... \nXXX"
                                        apt-get install -yy materia-gtk-theme papirus-icon-theme gnome-tweaks gnome-shell-extensions fonts-roboto
                                        rm -rf /usr/share/gnome-shell/extensions/alternate-tab@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/auto-move-windows@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/drive-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/launch-new-instance@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/native-window-placement@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/windowsNavigator@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com/
                                        sleep 30

                                        echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
                                        sleep 5
                                    } | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_material_debian}" --gauge "Loading..." 8 70 0; break;;
                            [Nn]* ) break;;
                            * ) echo -e ${red}"Error. '$input' is out of range. Try again with Y or N."${normalText};;
                    esac
                done
            nextitem="."
        fi
    fi
}

basicVirtualizationSetup(){
    # select menu
    # credits to https://askubuntu.com/users/877/paused-until-further-notice
    # source: https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
    clear
    consent=$(whiptail --inputbox "${txtvirtualizationprompt_warning}" 15 85 --fb --ok-button "${txtok}" --cancel-button "${txtabort}" --title "${txtvirtualization}" 3>&1 1>&2 2>&3)
    if [ ${consent} = "yes" ]; then
            cpubrand=$(whiptail --inputbox "${txtvirtualizationprompt}" 15 85 --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --title "${txtvirtualization}" 3>&1 1>&2 2>&3)
            if [ ${cpubrand} = "intel" ]; then
                apt-get install -yy qemu-kvm virt-manager bridge-utils ovmf &>/dev/null; cp /etc/default/grub /etc/default/grub.backup && cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n "Simple configuration"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on iommu=pt"
GRUB_CMDLINE_LINUX=""
# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console
# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command "vbeinfo"
#GRUB_GFXMODE=640x480
# Uncomment if you do not want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true
# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"
# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub; printf 'options kvm_intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1' > /etc/modprobe.d/kvm.conf; update-grub &>/dev/null; update-initramfs -u -k all &>/dev/null
        fi

        if [ ${cpubrand} = "amd" ]; then
            apt-get install -yy qemu-kvm virt-manager bridge-utils ovmf &>/dev/null; cp /etc/default/grub /etc/default/grub.backup && cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n "Simple configuration"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_iommu=on iommu=pt"
GRUB_CMDLINE_LINUX=""
# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console
# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command "vbeinfo"
#GRUB_GFXMODE=640x480
# Uncomment if you do not want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true
# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"
# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub; printf 'options kvm_amd nested=1
options kvm-amd enable_shadow_vmcs=1
options kvm-amd enable_apicv=1
options kvm-amd ept=1' > /etc/modprobe.d/kvm.conf; update-grub &>/dev/null; update-initramfs -u -k all &>/dev/null
        fi
        mainMenu
    elif [ ${consent} = "no" ]; then
        mainMenu
    fi
    nextitem="${txtreboot}"
}

fullVirtualizationSetup(){
    # select menu
    # credits to https://askubuntu.com/users/877/paused-until-further-notice
    # source: https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
    clear
    consent=$(whiptail --inputbox "${txtvirtualizationprompt_warning}" 15 85 --fb --ok-button "${txtok}" --cancel-button "${txtabort}" --title "${txtvirtualization}" 3>&1 1>&2 2>&3)
    if [ ${consent} = "yes" ]; then
            cpubrand=$(whiptail --inputbox "${txtvirtualizationprompt}" 15 85 --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --title "${txtvirtualization}" 3>&1 1>&2 2>&3)
            if [ ${cpubrand} = "intel" ]; then
                apt-get install -yy qemu-kvm virt-manager bridge-utils ovmf &>/dev/null; cp /etc/default/grub /etc/default/grub.backup && cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n "Simple configuration"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on iommu=pt isolcpus=2,3,4,5 nohz_full=2,3,4,5 rcu_nocbs=2,3,4,5 default_hugepagesz=1G hugepagesz=1G hugepages=16 rd.driver.pre=vfio-pci video=efifb:off"
GRUB_CMDLINE_LINUX=""
# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console
# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command "vbeinfo"
#GRUB_GFXMODE=640x480
# Uncomment if you do not want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true
# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"
# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub; printf 'options kvm_intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1' > /etc/modprobe.d/kvm.conf; printf 'options vfio-pci ids=' > /etc/modprobe.d/vfio.conf; update-grub &>/dev/null; update-initramfs -u -k all &>/dev/null
        fi

        if [ ${cpubrand} = "amd" ]; then
            apt-get install -yy qemu-kvm virt-manager bridge-utils ovmf &>/dev/null; cp /etc/default/grub /etc/default/grub.backup && cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n "Simple configuration"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_iommu=on iommu=pt isolcpus=2,3,4,5 nohz_full=2,3,4,5 rcu_nocbs=2,3,4,5 default_hugepagesz=1G hugepagesz=1G hugepages=16 rd.driver.pre=vfio-pci video=efifb:off"
GRUB_CMDLINE_LINUX=""
# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console
# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command "vbeinfo"
#GRUB_GFXMODE=640x480
# Uncomment if you do not want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true
# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"
# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub; printf 'options kvm_amd nested=1
options kvm-amd enable_shadow_vmcs=1
options kvm-amd enable_apicv=1
options kvm-amd ept=1' > /etc/modprobe.d/kvm.conf; printf 'options vfio-pci ids=' > /etc/modprobe.d/vfio.conf; update-grub &>/dev/null; update-initramfs -u -k all &>/dev/null
        fi
        mainMenu
    elif [ ${consent} = "no" ]; then
        mainMenu
    fi
    nextitem="${txtreboot}"
}

fixesSetup(){
    options=()
    options+=("${txtfixes_fixwiredunmanaged}" "${txtfixes_fixwiredunmanageddesc}")
    options+=("${txtfixes_disablebluetoothertm}" "${txtfixes_disablebluetoothertmdesc}")
    options+=("${txtfixes_disablepulseaudioflatvolumes}" "${txtfixes_disablepulseaudioflatvolumesdesc}")
    sel=$(whiptail --backtitle "${appTitle}" --title "${txtfixes}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
        "${options[@]}" \
        3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
        clear
        if [ "${sel}" = "${txtfixes_fixwiredunmanaged}" ]; then
            {
                sleep 1
                echo -e "XXX\n50\Applying settings... \nXXX"
            printf '[main]
plugins=keyfile,ifupdown

[ifupdown]
managed=true' > /etc/NetworkManager/NetworkManager.conf
            systemctl restart NetworkManager

                sleep 2
                echo -e "XXX\n100\Settings applied. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtfixes_disablebluetoothertm}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtfixes_disablebluetoothertm}" ]; then
            {
                sleep 1

                echo -e "XXX\n50\Applying settings... \nXXX"
                printf 'options bluetooth disable_ertm=1' > /etc/modprobe.d/bluetooth.conf
                sleep 0.5

                echo -e "XXX\n100\Settings applied. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtfixes_disablebluetoothertm}" --gauge "Loading..." 8 70 0
            nextitem="."
        elif [ "${sel}" = "${txtfixes_disablepulseaudioflatvolumes}" ]; then
            {
                sleep 1

                echo -e "XXX\n50\Applying settings... \nXXX"
printf '# This file is part of PulseAudio.
#
# PulseAudio is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# PulseAudio is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with PulseAudio; if not, see <http://www.gnu.org/licenses/>.

## Configuration file for the PulseAudio daemon. See pulse-daemon.conf(5) for
## more information. Default values are commented out.  Use either ; or # for
## commenting.

; daemonize = no
; fail = yes
; allow-module-loading = yes
; allow-exit = yes
; use-pid-file = yes
; system-instance = no
; local-server-type = user
; enable-shm = yes
; enable-memfd = yes
; shm-size-bytes = 0 # setting this 0 will use the system-default, usually 64 MiB
; lock-memory = no
; cpu-limit = no

; high-priority = yes
; nice-level = -11

; realtime-scheduling = yes
; realtime-priority = 5

; exit-idle-time = 20
; scache-idle-time = 20

; dl-search-path = (depends on architecture)

; load-default-script-file = yes
; default-script-file = /etc/pulse/default.pa

; log-target = auto
; log-level = notice
; log-meta = no
; log-time = no
; log-backtrace = 0

; resample-method = speex-float-1
; avoid-resampling = false
; enable-remixing = yes
; remixing-use-all-sink-channels = yes
; enable-lfe-remixing = no
; lfe-crossover-freq = 0

flat-volumes = no

; rlimit-fsize = -1
; rlimit-data = -1
; rlimit-stack = -1
; rlimit-core = -1
; rlimit-as = -1
; rlimit-rss = -1
; rlimit-nproc = -1
; rlimit-nofile = 256
; rlimit-memlock = -1
; rlimit-locks = -1
; rlimit-sigpending = -1
; rlimit-msgqueue = -1
; rlimit-nice = 31
; rlimit-rtprio = 9
; rlimit-rttime = 200000

; default-sample-format = s16le
; default-sample-rate = 44100
; alternate-sample-rate = 48000
; default-sample-channels = 2
; default-channel-map = front-left,front-right

; default-fragments = 4
; default-fragment-size-msec = 25

; enable-deferred-volume = yes
; deferred-volume-safety-margin-usec = 8000
; deferred-volume-extra-delay-usec = 0' > /etc/pulse/daemon.conf
                sleep 0.5

                echo -e "XXX\n100\Settings applied. Returning to main menu...\nXXX"
                sleep 5
            } | whiptail --backtitle "${appTitle}" --title "${txtfixes_disablepulseaudioflatvolumes}" --gauge "Loading..." 8 70 0
            nextitem="."
        fi
    fi
}

pressanykey(){
    read -n1 -p "${txtpressanykey}"
}

loadstrings_us(){
    locale="en_US.UTF-8"

    txtyoursys="Your system: "

    txtdisclaimer="DISCLAIMER"
    txtdisclaimerdesc="This script is in sid/unstable stage and may brake things up or the system entirely.\n\nThat being said, I warn you: DO NOT use this script in your daily driver machine until it's declared rock solid stable.\n\nContinue at your risk."

    txtaccept="Accept"
    txtrefuse="Refuse"
    txtabort="Abort"

    txtnotsupportedyet="Unsupported Version"
    txtnotsupportedyetdesc="Sorry, the version ${distroInfo} is not supported yet."

    txtunsupportedsystem="Unsupported System"
    txtunsupportedsystemdesc="Sorry, this script cannot proceed. Your system: ${distroSystem}\n\nDistributions are bulky and unstable, and so they are not supported and won't be in the future.\n\nVOldoldstable, oldstable versions; and testing, sid/unstable branches from Debian, are not supported."

    chooselanguage="This script contains two languages: [en/es]. Write down below which one do you prefer.\n\nEste script contiene dos idiomas: [en/es]. Escribe abajo cuál prefieres."
    lang_us="English (US)"
    lang_es="Spanish (Spain)"
    langdesc="(By gfelipe099)"

    txtok="OK"
    txtexit="Exit"
    txtreturn="Return"
    txtignore="Ignore"

    txtmainmenu="Main Menu"
    txtlanguage="Change Language"
    txtlanguagedesc="(Default Language: English US)"

    txtbasesetup="Base Setup"
    txtbasedesc="(Install a desktop enviroment, create a swap file)"
    txtsetupbaseselectdesktop="Select Desktop Enviroment"
    txtsetupbaseinstalldesktop="Install desktop enviroment"
    txtsetupbaseinstalldesktopdesc="(Install GNOME, KDE or Xfce)"
    txtsetupbaseswapfile4g="Create a 4 GiB swap file"
    txtsetupbaseswapfile4gdesc="(Optimal for systems with >=16 GiB of RAM)"
    txtsetupbaseswapfile8g="Create a 8 GiB swap file"
    txtsetupbaseswapfile8gdesc="(Optimal for systems with <16 GiB of RAM)"

    txtextrassetup="Extras Setup"
    txtextrasdesc="(Tools, drivers and applications for Debian)"
    txtextrassetup_sysreadiness="System Readiness"
    txtextrassetup_sysreadinessdesc="Run system readiness"
    txtextrassetup_bsystools="Install basic system tools"
    txtextrassetup_bsystools_gnome="Install Basic System Tools (GNOME)"
    txtextrassetup_bsystools_kde="Install basic system tools (KDE)"
    txtextrassetup_bsystools_xfce="Install basic system tools (Xfce)"
    txtextrassetup_bsystools_xfce_plugins="Install basic plugins (Xfce)"
    txtextrassetup_webbrowser="1.- Install web browser"
    txtextrassetup_officesuite="2.- Install office suite"
    txtextrassetup_gaming="3.- Install gaming software"
    txtextrassetup_multimedia="4.- Install multimedia software"
    txtextrassetup_amd_intel="5.- Install Mesa and Vulkan drivers"
    txtextrassetup_amd_intel_dialog="You are about to install Mesa and Vulkan drivers for AMD/Intel. Are you sure? [Y/N]: "
    txtextrassetup_material_debian="6.- Install Material Debian for GNOME"
    txtextrassetup_material_debian_dialog="You are about to install Material Debian for GNOME. Are you sure? [Y/N]: "
    
    txtbasicvirtualization="Virtualization (Basic)"
    txtbasicvirtualizationdesc="(Setup nested virtualization without CPU pinning)"
    txtvirtualizationprompt="Before beginning with the setup, please write down who is the manufacturer of your CPU [intel/amd]:"

    txtvirtualization="Virtualization (Full)"
    txtvirtualizationdesc="(Setup nested virtualization and CPU pinning)"
    txtvirtualizationprompt_warning="WARNING!!!\n\nCPU pinning only works with hexacore CPUs without HyperThreading/SMT currently. Abort now if your system is superior or inferior.\n\nDo you want to proceed? [yes/no]:"
    txtvirtualizationprompt="Before beginning with the setup, please write down who is the manufacturer of your CPU [intel/amd]:"

    txtfixes="Fixes"
    txtfixesdesc="(Common fixes for Debian)"
    txtfixes_fixwiredunmanaged="Fix Wired Unmanaged"
    txtfixes_fixwiredunmanageddesc="(Restores Ethernet manual configuration)"
    txtfixes_disablebluetoothertm="Disable Bluetooth's ERTM"
    txtfixes_disablebluetoothertmdesc="(Makes Xbox controllers to work wirelessly)"
    txtfixes_disablepulseaudioflatvolumes="Disable PulseAudio's flat volumes"
    txtfixes_disablepulseaudioflatvolumesdesc="(Avoid physical damage to your hearing)"

    txtreboottitle="Reboot System"
    txtreboot="Reboot"
    txtrebootdesc="(Shutdown the computer and then start it up again)"

    txtmadeby="(by gfelipe099)"
    txtmadeby_helpwanted="(WIP)"

    txtpressanykey="PRESS ANY KEY TO CONTINUE..."

}

loadstrings_es(){
    locale="es_ES.UTF-8"

    txtyoursys="Tu sistema: "

    txtdisclaimer="DESCARGO DE RESPONSABILIDAD"
    txtdisclaimerdesc="Este script esta en etapa sid/inestable y quizá rompa cosas o el sistema entero.\n\nDicho esto, te aviso: NO USES este script en tu ordenador del día a día hasta que sea declarado estable como una roca.\n\nContinúa bajo tu propio riesgo."

    txtaccept="Aceptar"
    txtrefuse="Rechazar"
    txtaboirt="Abortar"

    txtnotsupportedyet="Versión no soportada"
    txtnotsupportedyetdesc="Lo siento, la versión: ${distroInfo} aún no está soportada."

    txtunsupportedsystem="Sistema no soportado"
    txtunsupportedsystemdesc="Lo siento, este script no puede continuar. Tu sistema: ${distroSystem}\n\nLas distribuciones son voluminosas e inestables, y por ello no están soportadas y no lo estarán en el futuro.\n\nVLas versiones: estables antiguas, estables más antiguas; y las distribuciones: en pruebas e inestable de Debian, no están soportadas."

    lang_us="Inglés (EE.UU.)"
    lang_es="Español (España)"
    langdesc="(Por gfelipe099)"

    txtok="Aceptar"
    txtexit="Salir"
    txtreturn="Volver"
    txtignore="Ignorar"

    txtmainmenu="Menú principal"
    txtlanguage="Cambiar idioma"
    txtlanguagedesc="[Idioma por defecto: (Inglés (EE.UU.)]"

    txtbasesetup="Configuración base"
    txtbasedesc="(Instalar entorno de escritorio, crear archivo de intercambio)"
    txtsetupbaseselectdesktop="Elegir entorno de escritorio"
    txtsetupbaseinstalldesktop="Instalar entorno de escritorio"
    txtsetupbaseinstalldesktopdesc="(Instalar GNOME, KDE o Xfce)"
    txtsetupbaseswapfile4g="Crear archivo de intercambio de 4 GiB"
    txtsetupbaseswapfile4gdesc="(Óptimo para sistemas con >=16 GiB de RAM)"
    txtsetupbaseswapfile8g="Crear archivo de intercambio de 8 GiB"
    txtsetupbaseswapfile8gdesc="(Óptimo para sistemas con <16 GiB de RAM)"

    txtsysreadiness="Preparación del sistema"

    txtextras="Extras"
    txtextrasdesc="(Herramientas, controladores y aplicaciones para Debian)"
    txtextrassetup="Configuración de extras"
    txtextrassetup_sysreadiness="Ejecutar preparación del sistema"
    txtextrassetup_bsystools="Instalar herramientas básicas del sistema"
    txtextrassetup_bsystools_gnome="Instalar herramientas básicas del sistema (GNOME)"
    txtextrassetup_bsystools_kde="Instalar herramientas básicas del sistema (KDE)"
    txtextrassetup_bsystools_xfce="Instalar herramientas básicas del sistema (Xfce)"
    txtextrassetup_bsystools_xfce_plugins="Instalar complementos básicos (Xfce)"
    txtextrassetup_webbrowser="1.- Instalar navegador web"
    txtextrassetup_officesuite="2.- Instalar suite ofimática"
    txtextrassetup_gaming="3.- Instalar software para jugar"
    txtextrassetup_multimedia="4.- Instalar software multimedia"
    txtextrassetup_amd_intel="5.- Instalar los controladores de Mesa y Vulkan"
    txtextrassetup_amd_intel_dialog="Estás a punto de instalar los controladores MESA y Vulkan para AMD/Intel. ¿Estás seguro? (reinicio requerido) [Y/N]: "
    txtextrassetup_material_debian="6.- Instalar Material Debian para GNOME"
    txtextrassetup_material_debian_dialog="Estás apunto de instalar Material Debian para GNOME. ¿Estás seguro? (reinicio requerido) [Y/N]: "
    
    txtbasicvirtualization="Virtualización (Básica)"
    txtbasicvirtualizationdesc="(Configurar virtualización anidada sin afinidad de CPU)"
    txtvirtualizationprompt="Antes de empezar con la configuración, por favor, escribe abajo quién es el fabricante de tu CPU [intel/amd]:"

    txtvirtualization="Virtualización (Completa)"
    txtvirtualizationdesc="(Configurar virtualización anidada con afinidad de CPU)"
    txtvirtualizationprompt_warning="¡¡¡ AVISO !!! La afinidad de la CPU solo funciona con CPUs de 6 núcleos sin HyperThreading/SMT. Aborta ahora si tu sistema es superior o inferior.\n\n¿Quieres proceder? [yes/no]:"
    txtvirtualizationprompt="Antes de empezar con la configuración, por favor, escribe abajo quién es el fabricante de tu CPU [intel/amd]:"
    
    txtfixes="Arreglos"
    txtfixesdesc="(Arreglos comunes para Debian)"
    txtfixes_fixwiredunmanaged="Arreglar Ethernet sin manejar"
    txtfixes_fixwiredunmanageddesc="(Restaura la configuración manual de Ethernet)"
    txtfixes_disablebluetoothertm="Deshabilitar ERTM del Bluetooth"
    txtfixes_disablebluetoothertmdesc="(Hace que los mandos de Xbox funcionen inalámbricamente)"
    txtfixes_disablepulseaudioflatvolumes="Deshabilitar 'flat-volumes' de PulseAudio"
    txtfixes_disablepulseaudioflatvolumesdesc="(Evita daño físico a tus oídos)"


    txtreboottitle="Reiniciar sistema"
    txtreboot="Reiniciar"
    txtrebootdesc="(Apaga el ordenador y lo inicia de nuevo)"

    txtmadeby="(Por gfelipe099)"
    txtmadeby_wip="(WIP)"

    txtpressanykey="PRESIONA ALGUNA TECLA PARA CONTINUAR..."

}
    loadstrings_us
    chooseLanguage
# ------------------------------------------------- script end ------------------------------------------------- #
