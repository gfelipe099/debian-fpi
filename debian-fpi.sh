#!/bin/bash

#
# Created by Liam Powell (gfelipe099)
# A fork from MatMoul's https://github.com/MatMoul/archfi
# debian-fpi.sh file
# For Debian GNU/Linux 10.2.0/10.3.0 (buster) desktop amd64
#
appTitle="Debian Fast Post-Installer Setup v20200423.4-sid (Sid/Unstable Build)"

#
# text formatting codes
# source https://github.com/nbros652/LUKS-guided-manual-partitioning/blob/master/LGMP.sh
#
normalText='\e[0m'
boldText='\e[1m'
yellow='\e[93m'
green='\e[92m'
red='\e[91m'

# check if running as root
if [ "$(whoami)" != "root" ]; then
    echo -e "${boldText}${red}This script must be executed as root."${normalText}
    exit 0
fi

# install this package to check which OS is running
apt install -yy lsb-release &>/dev/null

# check if the OS is Debian
# credits to https://unix.stackexchange.com/users/33967/joeytwiddle, https://danielgibbs.co.uk
# source: https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script, https://danielgibbs.co.uk/2013/04/bash-how-to-detect-os/
distroInfo="Debian $(cat /etc/debian_version) $(uname -r)"
distroSystem="$(lsb_release -ds)"

if [[ "$distroSystem" = "Debian GNU/Linux 10 (buster)" ]]; then

	if [[ "$distroInfo" = "Debian 10.2 4.19.0-6-amd64" || "Debian 10.3 4.19.0-8-amd64" ]]; then
# ------------------------------------------------- script beginning ------------------------------------------------- #
root(){
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtlanguage}" "${txtlanguagedesc}")
	options+=("" "")
	options+=("${txtbase}" "${txtbasedesc}")
	options+=("${txtextras}" "${txtextrasdesc}")
	options+=("${txtvirtualization}" "${txtvirtualizationdesc}")
	options+=("" "")
	options+=("${txtfixes}" "${txtfixesdesc}")
	options+=("" "")
	options+=("${txtreboot}" "${txtrebootdesc}")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtmainmenu}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtlanguage}")
				changeLanguage
				nextitem="."
			;;
			"${txtbase}")
				baseSetup
				nextitem="."
			;;
			"${txtextras}")
				extrasSetup
				nextitem="."
			;;
			"${txtvirtualization}")
				virtualizationSetup
				nextitem="."
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
		root "${nextitem}"
	else
		clear
	fi
}

reboot(){
	if (whiptail --backtitle "${appTitle}" --title "${txtreboot}" --yesno "${txtreboot} ?" --defaultno 0 0) then
		clear
		rm -rf *.deb
		sudo reboot
	fi
}

changeLanguage(){
	options=()
	options+=("${lang_us}" "${langdesc}")
	options+=("${lang_es}" "${langdesc}")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtlanguage}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
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

prepareSystem(){
		echo "apt install -yy gnupg gnupg1 gnupg2"
    	echo "mkdir /usr/share/desktop-directories/"
		echo "dpkg --add-architecture i386"
		echo "apt update -yy"
		echo "apt install -yy gdebi"
		echo "apt install -yy curl"
		echo "apt install -yy wget"
		echo "curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -"
		echo "curl -sS https://download.spotify.com/debian/pubkey.gpg | apt-key add -"
		echo "wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_10/Release.key -O- | apt-key add -"
		echo "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
		echo "wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code_amd64.deb"
		echo "wget https://downloads.vivaldi.com/stable/vivaldi-stable_3.0.1874.23-1_amd64.deb"
		echo "apt update -yy"
		echo "printf '#
# THIRD-PARTY REPOSITORIES
#
deb http://repository.spotify.com stable non-free
deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main
deb http://download.opensuse.org/repositories/home:/strycore/Debian_10/ ./' > /etc/apt/sources.list.d/thirdparty.list"
		apt install -yy gnupg gnupg1 gnupg2
		mkdir /usr/share/desktop-directories/
		dpkg --add-architecture i386
		apt update -yy
		apt install -yy gdebi
		apt install -yy curl
		apt install -yy wget
		curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
		curl -sS https://download.spotify.com/debian/pubkey.gpg | apt-key add -
		wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_10/Release.key -O- | apt-key add -
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code_amd64.deb
		wget https://downloads.vivaldi.com/stable/vivaldi-stable_3.0.1874.23-1_amd64.deb
		printf '#
# THIRD-PARTY REPOSITORIES
#
deb http://repository.spotify.com stable non-free
deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main
deb http://download.opensuse.org/repositories/home:/strycore/Debian_10/ ./' > /etc/apt/sources.list.d/thirdparty.list
		apt update -yy
		pressanykey
}

baseSetup(){
	options=()
	options+=("${txtsetupbaseinstalldesktop}" "")
	options+=("${txtsetupbaseswapfile4g}" "${txtsetupbaseswapfile4gdesc}")
	options+=("${txtsetupbaseswapfile8g}" "${txtsetupbaseswapfile8gdesc}")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtbasesetup}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtsetupbaseswapfile4g}" ]; then
			echo "fallocate -l 4G /swapfile"
			echo "chmod 0600 /swapfile"
			echo "mkswap -L swap /swapfile"
			echo "swapon /swapfile"
			echo "echo "/swapfile swap swap defaults" 0 0 >> /etc/fstab"
			fallocate -l 4G /swapfile
			chmod 0600 /swapfile
			mkswap -L swap /swapfile
			swapon /swapfile
			echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtsetupbaseswapfile8g}" ]; then
			echo "fallocate -l 8G /swapfile"
			echo "chmod 0600 /swapfile"
			echo "mkswap -L swap /swapfile"
			echo "swapon /swapfile"
			echo "echo "/swapfile swap swap defaults" 0 0 >> /etc/fstab"
			fallocate -l 8G /swapfile
			chmod 0600 /swapfile
			mkswap -L swap /swapfile
			swapon /swapfile
			echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
			pressanykey
			nextitem="."
		fi
		if [ "${sel}" = "${txtsetupbaseinstalldesktop}" ]; then
			options=()
			options+=("GNOME" "${txtmadeby}")
			options+=("KDE Plasma" "${txtmadeby}")
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtsetupbaseselectdesktop}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
			"${options[@]}" \
			3>&1 1>&2 2>&3)
		if [ "$?" = "0" ]; then
			clear
				if [ "${sel}" = "GNOME" ]; then
					echo "apt install -yy gdm3*"
					apt install -yy gdm3*
					pressanykey
					nextitem="."
				elif [ "${sel}" = "KDE Plasma" ]; then
					echo "apt install -yy sddm*"
					echo "apt purge -yy discover*"
					apt install -yy sddm*
					apt purge -yy discover*
					pressanykey
					nextitem="."
				fi
		fi
	fi
fi
}

extrasSetup(){
	options=()
	options+=("${txtextrassetupx86_packages}" "(Required by some third-party applications)")
	options+=("${txtextrassetup_bsystools_gnome}" "(Installs GNOME basic tools)")
	options+=("${txtextrassetup_bsystools_kde}" "(Installs KDE basic tools)")
	options+=("${txtextrassetup_webbrowser}" "(Install a web browser)")
	options+=("${txtextrassetup_officesuite}" "(Installs LibreOffice)")
	options+=("${txtextrassetup_gaming}" "(Install software made to play games)")
	options+=("${txtextrassetup_multimedia}" "(Install software for multimedia purposes)")
	options+=("${txtextrassetup_developer}" "(Install developer software)")
	options+=("${txtextrassetup_nvidia}" "(Installs NVIDIA propietary drivers)")
	options+=("${txtextrassetup_amd_intel}" "(Installs Mesa and VULKAN open source drivers)")
	options+=("${txtextrassetup_material_debian}" "(Install Material Design themes, icons and font families)")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtextrassetupx86_packages}" ]; then
			prepareSystem
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_bsystools_gnome}" ]; then
			pkgs=""
			options=()
			options+=("nautilus" "GNOME File Manager" on)
			options+=("htop" "Command Line System Monitor" off)
			options+=("gnome-terminal" "GNOME Terminal" on)
			options+=("gedit" "GNOME Text Editor" on)
			options+=("terminator" "Terminator Terminal" off)
			options+=("gnome-disk-utility" "GNOME Disk Utility" on)
			options+=("gnome-system-monitor" "GNOME System Monitor" on)
			options+=("gufw" "Uncomplicated Firewall with GUI" on)
			options+=("clamtk" "Graphical Front-end for Clam Antivirus" on)
			options+=("gcc" "GNU Compiler Collection" on)
			options+=("make" "Building Utility" on)
			options+=("curl" "Command-Line Tool for Transferring Data" on)
			options+=("linux-headers-$(uname -r)" "Linux Headers Files" on)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_gnome}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update"
			echo "apt install -yy ${pkgs}"
			apt update
			apt install -yy ${pkgs}
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_bsystools_kde}" ]; then
			pkgs=""
			options=()
			options+=("plasma-nm" "Plasma applet for managing network connections" on)
			options+=("dolphin" "KDE File Manager" on)
			options+=("konsole" "KDE Terminal" on)
            options+=("kate" "KDE's Advanced Text Editor" on)
            options+=("kwin-x11" "Window Manager for X11" on)
            options+=("kwin-wayland" "Window Manager for Wayland" on)
			options+=("terminator" "Terminator Terminal" off)
			options+=("gnome-disk-utility" "GNOME Disk Utility" on)
			options+=("htop" "Command Line System Monitor" off)
			options+=("ksysguard" "KDE System Monitor" on)
			options+=("gufw" "Uncomplicated Firewall with GUI" on)
			options+=("clamtk" "Graphical Front-end for Clam Antivirus" on)
			options+=("gcc" "GNU Compiler Collection" on)
			options+=("make" "Building Utility" on)
			options+=("curl" "Command-Line Tool for Transferring Data" on)
			options+=("linux-headers-$(uname -r)" "Linux Headers Files" on)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_kde}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update"
			echo "apt install -yy ${pkgs}"
			apt update
			apt install -yy ${pkgs}
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetupx86_packages}" ]; then
			prepareSystem
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_webbrowser}" ]; then
			pkgs=""
			options=()
			options+=("firefox-esr" "Firefox Extended Support Release (GTK)" on)
			options+=("brave-browser" "Chromium Based Privacy-Focused Web Browser (GTK)" off)
			options+=("chromium" "Chromium Web Browser (GTK)" off)
			options+=("vivaldi" "Chromium Based Web Browser (GTK)" off)
			options+=("google-chrome-stable" "Google Chrome Web Browser (GTK)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_webbrowser}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update"
			echo "apt install -yy ${pkgs}"
			apt update
			apt install -yy ${pkgs}
			if [[ ${pkgs} == *"google-chrome-stable"* ]]; then
				echo "gdebi google-chrome-stable_current_amd64.deb"
				gdebi -n google-chrome-stable_current_amd64.deb
			fi
			if [[ ${pkgs} == *"vivaldi"* ]]; then
				echo "gdebi vivaldi-stable_3.0.1874.23-1_amd64.deb"
				gdebi -n vivaldi-stable_3.0.1874.23-1_amd64.deb
			fi
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_officesuite}" ]; then
			echo apt install -yy libreoffice
			apt install -yy libreoffice
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_gaming}" ]; then
			pkgs=""
			options=()
			options+=("steam" "Valve Video Game Digital Platform (GTK)" off)
			options+=("pcsx2" "PlayStation 2 (PS2) Emulator (QT)" off)
			options+=("lutris" "Open Gaming Platform (GTK)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_gaming}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update"
			echo "apt install -yy ${pkgs}"
			apt update
			apt install -yy ${pkgs}
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_multimedia}" ]; then
			pkgs=""
			options=()
			options+=("gimp" "GNU Image Manipulation Image (GTK)" off)
			options+=("spotify-client" "Music Streaming Application (GTK)" off)
			options+=("vlc" "VideoLAN's Media Player (VLC) (QT)" off)
			options+=("vlc-data" "Common data for VLC" off)
			options+=("totem" "GNOME Video Player (QT)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_multimedia}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "su apt update -yy"
			echo "apt install -yy ${pkgs}"
			apt update -yy
			apt install -yy ${pkgs}
			pressanykey
			nextitem="."
				elif [ "${sel}" = "${txtextrassetup_multimedia}" ]; then
			pkgs=""
			options=()
			options+=("gimp" "GNU Image Manipulation Image (GTK)" off)
			options+=("spotify-client" "Music Streaming Application (GTK)" off)
			options+=("vlc" "VideoLAN's Media Player (VLC) (QT)" off)
			options+=("vlc-data" "Common data for VLC" off)
			options+=("totem" "GNOME Video Player (QT)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_multimedia}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update"
			echo "apt install -yy ${pkgs}"
			apt update
			apt install ${pkgs}
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_developer}" ]; then
			pkgs=""
			options=()
			options+=("code" "Microsoft Visual Studio Code (GTK)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_developer}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update -yy"
			echo "apt install -yy ${pkgs}"
			apt update -yy
			apt install ${pkgs}
			if [[ ${pkgs} == *"code" ]]; then
				echo "apt install -yy $pkgs"
				echo "gdebi -n code_amd64.deb"
				apt install -yy $pkgs
				gdebi -n code_amd64.deb
			fi
            if [[ ${pkgs} == *"vivaldi" ]]; then
				echo "apt install -yy $pkgs"
				echo "gdebi -n vivaldi-stable_3.0.1874.23-1_amd64.deb"
				apt install -yy $pkgs
				gdebi -n vivaldi-stable_3.0.1874.23-1_amd64.deb
			fi
			pressanykey
			nextitem="."
				elif [ "${sel}" = "${txtextrassetup_multimedia}" ]; then
			pkgs=""
			options=()
			options+=("gimp" "GNU Image Manipulation Image (GTK)" off)
			options+=("spotify-client" "Music Streaming Application (GTK)" off)
			options+=("vlc" "VideoLAN's Media Player (VLC) (QT)" off)
			options+=("vlc-data" "Common data for VLC" off)
			options+=("mpv" "GNOME Video Player (QT)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_multimedia}" --checklist "" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ ! "$?" = "0" ]; then
				return 1
			fi
			for itm in $sel; do
				pkgs="$pkgs $(echo $itm | sed 's/"//g')"
			done
			clear
			echo "apt update -yy"
			echo "apt install -yy ${pkgs}"
			apt update -yy
			apt install ${pkgs}
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_nvidia}" ]; then
    			while true; do
        			read -p "${txtextrassetup_nvidia_dialog}" input
        			case $input in
            				[Yy]* ) sleep 2; echo "apt update"; echo "apt install -yy nvidia-driver"; apt update; apt install -yy nvidia-driver; break;;
            				[Nn]* ) break;;
            				* ) echo -e ${red}"Error. '$input' is out of range. Try again with Y or N."${normalText};;
        			esac
    			done
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_amd_intel}" ]; then
    			while true; do
        			read -p "${txtextrassetup_amd_intel_dialog}" input
        			case $input in
            				[Yy]* ) sleep 2; echo "apt update -yy"; echo "apt install -yy libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386"; apt update; apt install -yy libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386; break;;
            				[Nn]* ) break;;
            				* ) echo -e ${red}"Error. '$input' is out of range. Try again with Y or N."${normalText};;
        			esac
    			done
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_material_debian}" ]; then
    			while true; do
        			read -p "${txtextrassetup_material_debian_dialog}" input
        			case $input in
            				[Yy]* ) sleep 2; echo "apt update"; echo "apt install -yy materia-gtk-theme papirus-icon-theme gnome-tweaks gnome-shell-extensions fonts-roboto"; echo "rm -rf /usr/share/gnome-shell/extensions/alternate-tab@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/auto-move-windows@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/drive-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/launch-new-instance@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/native-window-placement@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/windowsNavigator@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com/"; apt update; apt install -yy materia-gtk-theme papirus-icon-theme gnome-tweaks gnome-shell-extensions fonts-roboto; rm -rf /usr/share/gnome-shell/extensions/alternate-tab@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/auto-move-windows@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/drive-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/launch-new-instance@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/native-window-placement@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/windowsNavigator@gnome-shell-extensions.gcampax.github.com/ /usr/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com/; break;;
            				[Nn]* ) break;;
            				* ) echo -e ${red}"Error. '$input' is out of range. Try again with Y or N."${normalText};;
        			esac
    			done
			pressanykey
			nextitem="."
		fi
	fi
}

virtualizationSetup(){
	# select menu
	# credits to https://askubuntu.com/users/877/paused-until-further-notice
	# source: https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
	clear
	PS3='Select a brand from above to begin the virtualization setup or abort: '
	options=("Intel" "AMD" "Abort")
	select opt in "${options[@]}"; do
	    case $opt in
        	"Intel")
	            echo "apt install -yy qemu-kvm virt-manager bridge-utils ovmf"; echo "cp /etc/default/grub /etc/default/grub.backup"; echo "cp /etc/apt/sources.list /etc/apt/sources.list.backup"; echo "cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup"; echo "printf '# If you change this file, run "update-grub" afterwards to update
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
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub"; echo "printf 'options kvm_intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1' > /etc/modprobe.d/kvm.conf"; echo "update-grub"; echo "update-initramfs -u -k all"; echo apt install -yy qemu-kvm virt-manager bridge-utils ovmf; cp /etc/default/grub /etc/default/grub.backup; cp /etc/apt/sources.list /etc/apt/sources.list.backup ; cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
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
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub"; echo "printf 'options kvm_intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1' > /etc/modprobe.d/kvm.conf; update-grub; update-initramfs -u -k all; break
            	;;
        	"AMD")
				echo "apt install -yy qemu-kvm virt-manager bridge-utils ovmf"; echo "cp /etc/default/grub /etc/default/grub.backup"; echo "cp /etc/apt/sources.list /etc/apt/sources.list.backup"; echo "cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup"; echo "printf '# If you change this file, run "update-grub" afterwards to update
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
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub"; echo "printf 'options kvm_amd nested=1
options kvm-amd enable_shadow_vmcs=1
options kvm-amd enable_apicv=1
options kvm-amd ept=1' > /etc/modprobe.d/kvm.conf"; echo "update-grub"; echo "update-initramfs -u -k all"; apt install -yy qemu-kvm virt-manager bridge-utils ovmf; cp /etc/default/grub /etc/default/grub.backup; cp /etc/apt/sources.list /etc/apt/sources.list.backup; cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
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
options kvm-amd ept=1' > /etc/modprobe.d/kvm.conf; update-grub; update-initramfs -u -k all; break
            	;;
        	"Abort")
	            echo "Aborted."
				break
            	;;
        	*) echo -e ${red}"Error. '$input' is out of range. Try again with Y or N."${normalText};;
    	esac
	done
	pressanykey
	nextitem="${txtreboot}"
}

fixesSetup(){
	options=()
	options+=("${txtfixes_fixwiredunmanaged}" "${txtfixes_fixwiredunmanageddesc}")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtfixes}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtfixes_fixwiredunmanaged}" ]; then
			echo "printf '[main]
plugins=keyfile,ifupdown

[ifupdown]
managed=true' > /etc/NetworkManager/NetworkManager.conf" &&
			printf '[main]
plugins=keyfile,ifupdown

[ifupdown]
managed=true' > /etc/NetworkManager/NetworkManager.conf
			echo systemctl restart NetworkManager
			systemctl restart NetworkManager
			pressanykey
			nextitem="."
		fi
	fi
}

pressanykey(){
	read -n1 -p "${txtpressanykey}"
}

loadstrings_us(){
	locale="en_US.UTF-8"

	lang_us="English (US)"
	lang_es="Spanish (Spain)"
	langdesc="(By gfelipe099)"

	txtexit="Exit"
	txtreturn="Return"
	txtignore="Ignore"

	txtmainmenu="Main Menu"
	txtlanguage="Change Language"
	txtlanguagedesc="(Default Language: English US)"

	txtbase="Base"
    txtbasedesc="(Install a desktop enviroment, create a swap file)"
	txtbasesetup="Base Setup"	
	txtsetupbaseselectdesktop="Select Desktop Enviroment"
	txtsetupbaseinstalldesktop="Install Desktop Enviroment"
	txtsetupbaseinstalldesktopdesc="(Install GNOME or KDE as your DE)"
	txtsetupbaseswapfile="Create Swap Sile"
	txtsetupbaseswapfilesize="Select Swap File Size"
	txtsetupbaseswapfile4g="Create a 4G swap file"
	txtsetupbaseswapfile4gdesc="(Optimal for systems with >16G of RAM)"
	txtsetupbaseswapfile8g="Create a 8G swap file"
	txtsetupbaseswapfile8gdesc="(Optimal for systems with <16G of RAM)"

	txtextras="Extras"
	txtextrasdesc="(Tools, drivers and applications for Debian)"
	txtextrassetup="Extras Setup"
	txtextrassetupx86_packages="1.- Add 32-bit support to APT"
	txtextrassetup_bsystools_gnome="2.- Install GNOME Basic System Tools"
	txtextrassetup_bsystools_kde="2.- Install KDE Basic System Tools"
	txtextrassetup_webbrowser="3.- Install Web Browser"
	txtextrassetup_officesuite="4.- Install Office Suite"
	txtextrassetup_gaming="5.- Install Gaming Software"
	txtextrassetup_multimedia="6.- Install Multimedia Software"
	txtextrassetup_developer="7.- Install Developer Software"
	txtextrassetup_nvidia="8.- Install NVIDIA Drivers"
	txtextrassetup_nvidia_dialog="Do you want to install the drivers for your NVIDIA graphics card (if any)? (reboot required) [Y/N]: "
	txtextrassetup_amd_intel="9.- Install Mesa and VULKAN Drivers"
	txtextrassetup_amd_intel_dialog="Do you want to install the Mesa and VULKAN drivers for your AMD graphics card or Intel iGPU (if any)? (restart recommended) [Y/N]: "
	txtextrassetup_material_debian="10.- Install Material Debian for GNOME"
	txtextrassetup_material_debian_dialog="Do you want to install Material Debian? [Y/N]: "
	
	txtvirtualization="Virtualization"
	txtvirtualizationdesc="(Setup cpu pinning, nested virtualization, etc. for your PC)"

	txtfixes="Fixes"
	txtfixesdesc="(Common Fixes for Debian)"
	txtfixes_fixwiredunmanaged="Fix Wired Unmanaged"

	txtreboot="Reboot"
	txtrebootdesc="(Shutdown the computer and then start it up again)"

	txtmadeby="(by gfelipe099)"
	txtmadeby_helpwanted="(Help Wanted)"

	txtpressanykey="PRESS ANY KEY TO CONTINUE..."

}

loadstrings_es(){
	locale="es_ES.UTF-8"

	lang_us="Inglés (EE.UU.)"
	lang_es="Español (España)"
	langdesc="(Por gfelipe099)"

	txtexit="Salir"
	txtreturn="Volver"
	txtignore="Ignorar"

	txtmainmenu="Menú principal"
	txtlanguage="Cambiar idioma"
	txtlanguagedesc="(Idioma por defecto: Inglés EE.UU.)"

	txtbase="Base"
    txtbasedesc="(Instalar entorno de escritorio, crear archivo de intercambio)"
	txtbasesetup="Instalación base"	
	txtsetupbaseselectdesktop="Seleccionar escritorio"
	txtsetupbaseinstalldesktop="Instalar escritorio"
	txtsetupbaseswapfile="Crear archivo de intercambio"
	txtsetupbaseswapfilesize="Seleccionar tamaño del archivo de intercambio"
	txtsetupbaseswapfile4g="Crear archivo de intercambio de 4G"
	txtsetupbaseswapfile4gdesc="(Óptimo para sistemas con >16G de RAM)"
	txtsetupbaseswapfile8g="Crear archivo de intercambio de 8G"
	txtsetupbaseswapfile8gdesc="(Óptimo para sistemas con <16G de RAM)"

	txtextras="Extras"
	txtextrasdesc="(Herramientas, controladores y aplicaciones para Debian)"
	txtextrassetup="Instalación de extras"
	txtextrassetupx86_packages="1.- Añadir soporte de 32-bit a APT"
	txtextrassetup_bsystools="2.- Instalar herramientas del sistema básicas"
	txtextrassetup_webbrowser="3.- Instalar navegador web"
	txtextrassetup_officesuite="4.- Instalar paquete ofimático"
	txtextrassetup_gaming="5.- Instalar programas para jugar"
	txtextrassetup_multimedia="6.- Instalar programas multimedia"
	txtextrassetup_developer="7.- Instalar programas de desarrollador"
	txtextrassetup_nvidia="7.- Instalar controladores de NVIDIA"
	txtextrassetup_nvidia_dialog="¿Quieres instalar los controladores de tu tarjeta gráfica NVIDIA (si la hay)? (reinicio requerido) [Y/N]: "
	txtextrassetup_amd_intel="8.- Instalar controladores de Mesa y VULKAN"
	txtextrassetup_amd_intel_dialog="¿Quieres instalar los controladores de Mesa y VULKAN? (reinicio recomendado) [Y/N]: "
	txtextrassetup_material_debian="9.- Instalar Material Debian para GNOME"
	txtextrassetup_material_debian_dialog="¿Quieres instalar el tema Materia GTK, el tema de iconos Papirus y la familia de fuentes Roboto?"
	

	txtvirtualization="Virtualización"
	txtvirtualizationdesc="(Instalar qemu-kvm, habilitar virtualización anidada, etc.)"
	
	txtfixes="Arreglos"
	txtfixesdesc="(Arreglos comunes para Debian)"
	txtfixes_fixwiredunmanaged="Arreglar Ethernet sin manejar por NetworkManager"

	txtreboot="Reiniciar"
	txtrebootdesc="(Apaga el ordenador y lo inicia otra vez)"

	txtmadeby="(by gfelipe099)"
	txtmadeby_helpwanted="(Se busca ayuda)"

	txtpressanykey="PRESIONA CUALQUIER TECLA PARA CONTINUAR..."

}
	rm -rf *.deb
	loadstrings_us
	prepareSystem
	root
    else
    	echo -e "${boldText}${red}Sorry, ${distroInfo} is not supported yet."${normalText}
        exit 0
fi
   else
        echo -e "${boldText}${red}Sorry, this script cannot proceed. Your system: ${distroSystem}"${normalText}
        echo -e "${boldText}${yellow}For distro users: They are bulky and unstable, and so they are not supported and won't be in the future."${normalText}
        echo -e "${boldText}${yellow}For old(old)stable release Debian users: These versions are not supported because this script only works with the lastest stable version."${normalText}
        exit 1
fi
# ------------------------------------------------- script end ------------------------------------------------- #
