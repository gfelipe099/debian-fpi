#!/bin/bash

#
# Created by Liam Powell (gfelipe099)
# A fork from MatMoul's https://github.com/MatMoul/archfi
# debian-fpi--non-free.sh file
# For Debian GNU/Linux 10.2.0/10.3.0 (buster) desktop amd64
#
appTitle="Debian Fast Post-Installer Setup v20200506.0-sid (Sid/Unstable Build)"

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
	#
	# credits to: https://stackoverflow.com/users/1343979/bass
	# source: https://stackoverflow.com/questions/46619539/changing-colours-in-whiptail
	#
	export NEWT_COLORS='root=,red'

	if (whiptail --title "${txtdisclaimer}" --fb --yes-button "${txtaccept}" --no-button "${txtrefuse}" --yesno "${txtdisclaimerdesc}" 14 90 --defaultno); then
		if [[ "$distroSystem" = "Debian GNU/Linux 10 (buster)" ]]; then
			if [[ "$distroInfo" = "Debian 10.2 4.19.0-6-amd64" || "Debian 10.3 4.19.0-8-amd64" ]]; then
				mainMenu
   			else
    			whiptail --title "${txtnotsupportedyet}" --fb --ok-button "${txtok}" --msgbox "${txtnotsupportedyetdesc}" 10 65
        		exit 0
			fi
		else
			whiptail --title "${txtunsupportedsystem}" --fb --ok-button "${txtok}" --msgbox "${txtunsupportedsystemdesc}" 13 90
        	exit 1
		fi
	else
	    exit 0
	fi
}

chooseLanguage(){
	#
	# credits to: https://stackoverflow.com/users/1343979/bass
	# source: https://stackoverflow.com/questions/46619539/changing-colours-in-whiptail
	#
	export NEWT_COLORS='root=,black'
	language=$(whiptail --inputbox "${chooselanguage}" 12 85 en --fb --ok-button "${txtok}" --nocancel --title "Choose Language - Elegir idioma" 3>&1 1>&2 2>&3)
	if [ $language = en ]; then
		loadstrings_us
		root
	elif [ $language = es ]; then
		loadstrings_es
		root
	fi
}

 changeLanguage(){
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtlanguage}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${lang_us}" "${langdesc}" \
		"${lang_es}" "${langdesc}" \
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
		"${txtbase}" "${txtbasedesc}" \
		"${txtextras}" "${txtextrasdesc}" \
		"${txtvirtualization}" "${txtvirtualizationdesc}" \
		"" "" \
		"${txtfixes}" "${txtfixesdesc}" \
		"${txtreboot}" "${txtrebootdesc}" 3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtlanguage}")
				changeLanguage
				nextitem="${txtbase}"
			;;
			"${txtbase}")
				baseSetup
				nextitem="${txtextras}"
			;;
			"${txtextras}")
				extrasSetup
				nextitem="${txtvirtualization}"
			;;
			"${txtvirtualization}")
				virtualizationSetup
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
		rm -rf *.deb
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
		echo -e "XXX\n5\nInstalling dependencies... \nXXX"
		apt install -yy gnupg gnupg1 gnupg2 &>/dev/null
		sleep 11.5

		echo -e "XXX\n13\nMaking '/usr/share/desktop-directories/' directory... \nXXX"
		mkdir /usr/share/desktop-directories/ &>/dev/null
		sleep 0.5

		echo -e "XXX\n20\nAdding 32-bit architecture to APT... \nXXX"		
		dpkg --add-architecture i386 &>/dev/null
		sleep 4

		echo -e "XXX\n29\nChecking for updates and installing them if any...\nXXX"
		apt update -yy &>/dev/null
		sleep 16.5

		echo -e "XXX\n36\nInstalling package gdebi...\nXXX"
		apt install -yy gdebi &>/dev/null
		sleep 11.5

		echo -e "XXX\n44\nInstalling package curl...\nXXX"
		apt install -yy curl &>/dev/null
		sleep 11.5

		echo -e "XXX\60\nInstalling package wget...\nXXX"
		apt install -yy wget &>/dev/null
		sleep 11.5

		echo -e "XXX\n79\nAdding and trusting third-party keyrings...\nXXX"
		curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - &>/dev/null
		curl -sS https://download.spotify.com/debian/pubkey.gpg | apt-key add - &>/dev/null
		wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_10/Release.key -O- | apt-key add - &>/dev/null
		sleep 10

		echo -e "XXX\n87\nDownloading Google Chrome package...\nXXX"
		wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &>/dev/null
		sleep 21.5

		echo -e "XXX\n91\nDownloading Visual Studio Code package...\nXXX"
		wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O code_amd64.deb &>/dev/null
		sleep 21.5

		echo -e "XXX\n94\nDownloading Vivaldi web browser...\nXXX"
		wget -q https://downloads.vivaldi.com/stable/vivaldi-stable_3.0.1874.23-1_amd64.deb &>/dev/null
		sleep 21.5

		echo -e "XXX\n96\nDownloading Popcorn Time...\nXXX"
		wget -q https://github.com/popcorn-official/popcorn-desktop/releases/download/v0.4.4/Popcorn-Time-0.4.4-amd64.deb &>/dev/null
		sleep 21.5

		echo -e "XXX\99\nAdding third-party repositories to APT and updating cache...\nXXX"
		printf '#
# THIRD-PARTY REPOSITORIES
#
deb http://repository.spotify.com stable non-free
deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main
deb http://download.opensuse.org/repositories/home:/strycore/Debian_10/ ./' > /etc/apt/sources.list.d/thirdparty.list &>/dev/null
		apt update -yy &>/dev/null
		sleep 10.5

		echo -e "XXX\n100\nDone. Starting script...\nXXX"
		sleep 5

		break
	} | whiptail --backtitle "${txtsysreadiness}" --gauge "Please wait..." 8 70 0
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
				echo "/swapfile swap swap sw 0 0" >> /etc/fstab &>/dev/null
				sleep 1
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
				echo "/swapfile swap swap sw 0 0" >> /etc/fstab &>/dev/null
				sleep 1
			} | whiptail --backtitle "${appTitle}" --title "${txtsetupbaseswapfile8g}" --gauge "Please wait..." 8 70 0
			nextitem="."
		fi
		if [ "${sel}" = "${txtsetupbaseinstalldesktop}" ]; then
			options=()
			options+=("GNOME" "${txtmadeby}")
			options+=("KDE Plasma" "${txtmadeby}")
			options+=("Xfce" "${txtmadeby_helpwanted}")
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
					echo -e "XXX\n100\nGNOME Display Manager was installed successfully. \nXXX"
					sleep 5
				} | whiptail --backtitle "${appTitle}" --title "GNOME" --gauge "Please wait..." 8 70 0
				nextitem="."
			elif [ "${sel}" = "KDE Plasma" ]; then
				{
					sleep 1
					echo -e "XXX\n50\nInstalling KDE Display Manager... \nXXX"
					apt-get install -yy sddm* &>/dev/null
					apt-get purge -yy discover plasma-discover kinfocenter xterm --autoremove &>/dev/null
					sleep 50
					echo -e "XXX\n100\nKDE Display Manager was installed successfully. \nXXX"
					sleep 5
				} | whiptail --backtitle "${appTitle}" --title "${txtsetupbaseinstalldesktop}" --gauge "Please wait..." 8 70 0
				nextitem="."
			elif [ "${sel}" = "Xfce" ]; then
				{
					sleep 1
					echo -e "XXX\n50\nInstalling Xfce Display Manager... \nXXX"
					apt install -yy xfwm4 xfdesktop4 xfce4-panel xfce4-panel xfce4-settings xfce4-power-manager xfce4-session xfconf xfce4-notifyd &>/dev/null
					sleep 60
					echo -e "XXX\n100\Xfce Display Manager was installed successfully. \nXXX"
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
	options+=("${txtextrassetup_sysreadiness}" "(Required by third-party applications)")
	options+=("${txtextrassetup_bsystools_gnome}" "(Install GNOME basic tools)")
	options+=("${txtextrassetup_bsystools_kde}" "(Install KDE basic tools)")
	options+=("${txtextrassetup_bsystools_xfce}" "(Install XFCE basic tools)")
	options+=("${txtextrassetup_bsystools_xfce_plugins}" "(Install XFCE basic plugins)")
	options+=("${txtextrassetup_webbrowser}" "(Install a web browser)")
	options+=("${txtextrassetup_officesuite}" "(Install LibreOffice)")
	options+=("${txtextrassetup_gaming}" "(Install software made to play games)")
	options+=("${txtextrassetup_multimedia}" "(Install software for multimedia purposes)")
	options+=("${txtextrassetup_developer}" "(Install developer software)")
	options+=("${txtextrassetup_nvidia}" "(Install NVIDIA propietary drivers)")
	options+=("${txtextrassetup_amd_intel}" "(Install Mesa and VULKAN open source drivers)")
	options+=("${txtextrassetup_material_debian}" "(Install a set of themes, icons and font families)")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup}" --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtextrassetup_sysreadiness}" ]; then
			systemReadiness
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_bsystools_gnome}" ]; then
			pkgs=""
			options=()
			options+=("nautilus" "GNOME File Manager" on)
			options+=("htop" "Command Line System Monitor" off)
			options+=("network-manager-openvpn-gnome" "OpenVPN plugin GNOME GUI" off)
			options+=("gnome-terminal" "GNOME Terminal" on)
			options+=("gedit" "GNOME Text Editor" on)
			options+=("terminator" "Terminator Terminal" off)
			options+=("neofetch" "Command-line System Information Tool" off)
			options+=("gnome-disk-utility" "GNOME Disk Utility" on)
			options+=("gnome-system-monitor" "GNOME System Monitor" on)
			options+=("gufw" "Uncomplicated Firewall with GUI" on)
			options+=("clamtk" "Graphical Front-end for Clam Antivirus" on)
			options+=("gcc" "GNU Compiler Collection" on)
			options+=("make" "Building Utility" on)
			options+=("curl" "Command-Line Tool for Transferring Data" on)
			options+=("linux-headers-$(uname -r)" "Linux Headers Files" on)
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
				echo -e "XXX\n0\Checkinf for updates and installing them if any... \nXXX"
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
			options+=("dolphin" "KDE File Manager" on)
			options+=("konsole" "KDE Terminal" on)
            options+=("kate" "KDE's Advanced Text Editor" on)
            options+=("kwin-x11" "Window Manager for X11" on)
            options+=("kwin-wayland" "Window Manager for Wayland" on)
			options+=("terminator" "Terminator Terminal" off)
			options+=("gnome-disk-utility" "GNOME Disk Utility" on)
			options+=("neofetch" "Command-line System Information Tool" off)
			options+=("htop" "Command-line System Monitor" off)
			options+=("ksysguard" "KDE System Monitor" on)
			options+=("gufw" "Uncomplicated Firewall with GUI" on)
			options+=("clamtk" "Graphical Front-end for Clam Antivirus" on)
			options+=("gcc" "GNU Compiler Collection" on)
			options+=("make" "Building Utility" on)
			options+=("curl" "Command-Line Tool for Transferring Data" on)
			options+=("linux-headers-$(uname -r)" "Linux Headers Files" on)
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
				apt-get -yy upgrade &>/dev/null
				sleep 20

				echo -e "XXX\n50\nInstalling and configuring KDE Basic System Tools... \nXXX"
				apt-get install -yy ${pkgs} &>/dev/null
				sleep 50

				echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
				sleep 5
			} | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_kde}" --gauge "Loading..." 8 70 0
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_bsystools_xfce}" ]; then
			pkgs=""
			options=()
			options+=("thunar" "File Manager for Xfce" on)
			options+=("mousepad" "Xfce Text Editor" on)
			options+=("ristretto" "Lightweight Picture-Viewer for Xfce" on)
			options+=("xfce4-taskmanager" "Process Manager for Xfce" on)
			options+=("xfce4-screenshooter" "Screenshots Utility for Xfce" off)
			options+=("xfce4-terminal" "Xfce Terminal Emulator" on)
			options+=("xfce4-notes" "Notes application for Xfce" off)
			options+=("xfce4-goodies" "Enhancements for Xfce" on)
			options+=("xfce4-appfinder" "Application finder for Xfce" off)
			options+=("xfce4-clipman" "Clipboard History Utility for Xfce" off)
			options+=("xfwm4-themes" "Theme files for xfwm4" on)
			options+=("xfburn" "CD-burner Application for Xfce" off)
			options+=("orage" "Calendar for Xfce" off)
			options+=("terminator" "Terminator Terminal" off)
			options+=("neofetch" "Command-line System Information Tool" off)
			options+=("htop" "Command-line System Monitor" off)
			options+=("gufw" "Uncomplicated Firewall with GUI" on)
			options+=("clamtk" "Graphical Front-end for Clam Antivirus" on)
			options+=("gcc" "GNU Compiler Collection" on)
			options+=("make" "Building Utility" on)
			options+=("curl" "Command-Line Tool for Transferring Data" on)
			options+=("linux-headers-$(uname -r)" "Linux Headers Files" on)
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

				echo -e "XXX\n50\nInstalling and configuring Xfce Basic System Tools... \nXXX"
				apt-get install -yy ${pkgs} &>/dev/null
				sleep 50

				echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
				sleep 5
			} | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_bsystools_xfce}" --gauge "Loading..." 8 70 0
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_sysreadiness}" ]; then
			systemReadiness
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_webbrowser}" ]; then
			pkgs=""
			options=()
			options+=("firefox-esr" "Firefox Extended Support Release (GTK)" on)
			options+=("brave-browser" "Chromium Based Privacy-Focused Web Browser (GTK)" off)
			options+=("chromium" "Chromium Web Browser (GTK)" off)
			options+=("vivaldi" "Chromium Based Web Browser (GTK)" off)
			options+=("google-chrome-stable" "Google Chrome Web Browser (GTK)" off)
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

				if  [[ ${pkgs} == *"brave-browser"* ]]; then
					apt-get install -yy apt-transport-https
				elif [[ ${pkgs} == *"google-chrome-stable"* ]]; then
					gdebi -n google-chrome-stable_current_amd64.deb
				elif [[ ${pkgs} == *"vivaldi"* ]]; then
					gdebi -n vivaldi-stable_3.0.1874.23-1_amd64.deb
				fi
				
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
			options+=("steam" "Valve Video Game Digital Platform (GTK)" off)
			options+=("pcsx2" "PlayStation 2 (PS2) Emulator (GTK)" off)
			options+=("lutris" "Open Gaming Platform (GTK)" off)
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

				echo -e "XXX\n50\nInstalling and configuring gaming software(s)... \nXXX"
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
			options+=("spotify-client" "Music Streaming Application (GTK)" off)
			options+=("vlc" "VideoLAN's Media Player (VLC) (QT)" off)
			options+=("vlc-data" "Common data for VLC" off)
			options+=("totem" "GNOME Video Player (QT)" off)
			options+=("popcorn" "BitTorrent Client to watch films" off)
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
			if [[ ${pkgs} == *"popcorn"* ]]; then
				echo "gdebi -n Popcorn-Time-0.4.4-amd64.deb"
				gdebi -n Popcorn-Time-0.4.4-amd64.deb
			fi
			{
				sleep 5
				echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
				apt-get -yy upgrade &>/dev/null
				sleep 20

				echo -e "XXX\n50\nInstalling and configuring multimedia software... \nXXX"
				apt-get install -yy ${pkgs} &>/dev/null

				if [[ ${pkgs} == *"popcorn"* ]]; then
					echo "gdebi -n Popcorn-Time-0.4.4-amd64.deb"
					gdebi -n Popcorn-Time-0.4.4-amd64.deb
				fi
				
				sleep 30
				echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
				sleep 5
			} | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_multimedia}" --gauge "Loading..." 8 70 0
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_developer}" ]; then
			pkgs=""
			options=()
			options+=("code" "Microsoft Visual Studio Code (GTK)" off)
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup_developer}" --fb --ok-button "${txtok}" --checklist "" 0 0 0 \
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

				echo -e "XXX\n50\nInstalling and configuring developer software... \nXXX"
				apt-get install -yy ${pkgs} &>/dev/null

				if [[ ${pkgs} == *"code"* ]]; then
					echo "gdebi -n code_amd64.deb"
					apt-get install -yy $pkgs
					gdebi -n code_amd64.deb
				fi
				
				sleep 30
				echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
				sleep 5
			} | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_developer}" --gauge "Loading..." 8 70 0
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_nvidia}" ]; then
    			while true; do
        			read -p "${txtextrassetup_nvidia_dialog}" input
        			case $input in
            				[Yy]* ) {
										sleep 5
										echo -e "XXX\n0\Checking for updates and installing them if any... \nXXX"
										apt-get -yy upgrade &>/dev/null
										sleep 20

										echo -e "XXX\n50\nInstalling and configuring NVIDIA propietary drivers... \nXXX"
										apt-get install -yy nvidia-driver &>/dev/null
				
										sleep 30
										echo -e "XXX\n100\nInstallation done. Returning to main menu...\nXXX"
										sleep 5
									} | whiptail --backtitle "${appTitle}" --title "${txtextrassetup_nvidia}" --gauge "Loading..." 8 70 0; break;;
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

virtualizationSetup(){
	# select menu
	# credits to https://askubuntu.com/users/877/paused-until-further-notice
	# source: https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
	clear
	cpubrand=$(whiptail --inputbox "${txtvirtualizationprompt}" 12 85 --fb --ok-button "${txtok}" --cancel-button "${txtreturn}" --title "${txtvirtualization}" 3>&1 1>&2 2>&3)
	if [ ${cpubrand} = "intel" ]; then
		apt-get install -yy qemu-kvm virt-manager bridge-utils ovmf &>/dev/null; cp /etc/default/grub /etc/default/grub.backup && cp /etc/apt/sources.list /etc/apt/sources.list.backup && cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
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
options kvm-intel ept=1' > /etc/modprobe.d/kvm.conf; update-grub &>/dev/null; update-initramfs -u -k all &>/dev/null
		mainMenu
	fi
	if [ ${cpubrand} = "amd" ]; then
		apt-get install -yy qemu-kvm virt-manager bridge-utils ovmf &>/dev/null; cp /etc/default/grub /etc/default/grub.backup && cp /etc/apt/sources.list /etc/apt/sources.list.backup && cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup; printf '# If you change this file, run "update-grub" afterwards to update
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
options kvm-amd ept=1' > /etc/modprobe.d/kvm.conf; update-grub &>/dev/null; update-initramfs -u -k all &>/dev/null
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

	txtbase="Base"
    txtbasedesc="(Install a desktop enviroment, create a swap file)"
	txtbasesetup="Base Setup"	
	txtsetupbaseselectdesktop="Select Desktop Enviroment"
	txtsetupbaseinstalldesktop="Install desktop enviroment"
	txtsetupbaseinstalldesktopdesc="(Install GNOME, KDE or Xfce)"
	txtsetupbaseswapfile4g="Create a 4 GiB swap file"
	txtsetupbaseswapfile4gdesc="(Optimal for systems with <=16 GiB of RAM)"
	txtsetupbaseswapfile8g="Create a 8 GiB swap file"
	txtsetupbaseswapfile8gdesc="(Optimal for systems with >16 GiB of RAM)"

	txtsysreadiness="System Readiness"

	txtextras="Extras"
	txtextrasdesc="(Tools, drivers and applications for Debian)"
	txtextrassetup="Extras Setup"
	txtextrassetup_sysreadiness="Run system readiness"
	txtextrassetup_bsystools_gnome="Install Basic System Tools (GNOME)"
	txtextrassetup_bsystools_kde="Install Basic System Tools (KDE)"
	txtextrassetup_bsystools_xfce="Install Basic System Tools (Xfce)"
	txtextrassetup_bsystools_xfce_plugins="Install Basic Plugins (Xfce)"
	txtextrassetup_webbrowser="1.- Install Web Browser"
	txtextrassetup_officesuite="2.- Install Office Suite"
	txtextrassetup_gaming="3.- Install Gaming Software"
	txtextrassetup_multimedia="4.- Install Multimedia Software"
	txtextrassetup_developer="5.- Install Developer Software"
	txtextrassetup_nvidia="6.- Install NVIDIA Propietary Drivers"
	txtextrassetup_nvidia_dialog="You are about to install drivers for NVIDIA graphics cards. Are you sure? (reboot required) [Y/N]: "
	txtextrassetup_amd_intel="7.- Install Mesa and VULKAN Drivers"
	txtextrassetup_amd_intel_dialog="You are about to install Mesa and Vulkan drivers for AMD/Intel. Are you sure? [Y/N]: "
	txtextrassetup_material_debian="8.- Install Material Debian for GNOME"
	txtextrassetup_material_debian_dialog="You are about to install Material Debian for GNOME. Are you sure? [Y/N]: "
	
	txtvirtualization="Virtualization"
	txtvirtualizationdesc="(Setup CPU pinning, nested virtualization, etc.)"
	txtvirtualizationprompt="Before beginning with the setup, I need to know which brand is your CPU from: intel or amd\n\nPlease, write it down below [intel/amd]: "

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
	txtmadeby_helpwanted="(Help Wanted)"

	txtpressanykey="PRESS ANY KEY TO CONTINUE..."

}

loadstrings_es(){
	locale="es_ES.UTF-8"

	txtyoursys="Tu sistema: "

	txtdisclaimer="DESCARGO DE RESPONSABILIDAD"
	txtdisclaimerdesc="Este script esta en etapa sid/inestable y quizá rompa cosas o el sistema entero.\n\nDicho esto, te aviso: NO USES este script en tu ordenador del día a día hasta que sea declarado estable como una roca.\n\nContinúa bajo tu propio riesgo."

	txtaccept="Aceptar"
	txtrefuse="Rechazar"

	txtyoursys="Tu sistema: "

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

	txtbase="Base"
    txtbasedesc="(Instalar entorno de escritorio, crear archivo de intercambio)"
	txtbasesetup="Configuración base"	
	txtsetupbaseselectdesktop="Elegir entorno de escritorio"
	txtsetupbaseinstalldesktop="Instalar entorno de escritorio"
	txtsetupbaseinstalldesktopdesc="(Instalar GNOME, KDE o Xfce)"
	txtsetupbaseswapfile4g="Crear archivo de intercambio de 4 GiB"
	txtsetupbaseswapfile4gdesc="(Óptimo para sistemas con >16 GiB de RAM)"
	txtsetupbaseswapfile8g="Crear archivo de intercambio de 8 GiB"
	txtsetupbaseswapfile8gdesc="(Óptimo para sistemas con <16 GiB de RAM)"

	txtsysreadiness="Preparación del sistema"

	txtextras="Extras"
	txtextrasdesc="(Herramientas, controladores y aplicaciones para Debian)"
	txtextrassetup="Configuración de extras extras"
	txtextrassetup_sysreadiness="Ejecutar preparación del sistema"
	txtextrassetup_bsystools_gnome="Instalar herramientas básicas del sistema (GNOME)"
	txtextrassetup_bsystools_kde="Instalar herramientas básicas del sistema (KDE)"
	txtextrassetup_bsystools_xfce="Instalar herramientas básicas del sistema (Xfce)"
	txtextrassetup_bsystools_xfce_plugins="Instalar complementos básicos (Xfce)"
	txtextrassetup_webbrowser="1.- Instalar navegador web"
	txtextrassetup_officesuite="2.- Instalar suite ofimática"
	txtextrassetup_gaming="3.- Instalar software para jugar"
	txtextrassetup_multimedia="4.- Instalar software multimedia"
	txtextrassetup_developer="5.- Instalar software para desarrolladores"
	txtextrassetup_nvidia="6.- Instalar controladores propietarios de NVIDIA"
	txtextrassetup_nvidia_dialog="Estás apunto de instalar los controladores para tarjetas gráficas NVIDIA. ¿Estás seguro? (reinicio requerido) [Y/N]: "
	txtextrassetup_amd_intel="7.- Install Mesa and VULKAN Drivers"
	txtextrassetup_amd_intel_dialog="Estás apunto de instalar los controladores MESA y Vulkan para AMD/Intel. ¿Estás seguro? (reinicio requerido) [Y/N]: "
	txtextrassetup_material_debian="8.- Instalar Material Debian para GNOME"
	txtextrassetup_material_debian_dialog="Estás apunto de instalar Material Debian para GNOME. ¿Estás seguro? (reinicio requerido) [Y/N]: "
	
	txtvirtualization="Virtualización"
	txtvirtualizationdesc="(Configurar afinidad de CPU, virtualización anidada, etc.)"
	txtvirtualizationprompt="Antes de empezar a configurar la virtualización, necesito saber de qué marca es tu CPU, Intel o AMD\n\nPor favor, escríbelo abajo [intel/amd]: "

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
	txtrebootdesc="(Apaga el ordenador y entonces inícialo de nuevo)"

	txtmadeby="(Por gfelipe099)"
	txtmadeby_helpwanted="(Se busca ayuda)"

	txtpressanykey="PRESIONA ALGUNA TECLA PARA CONTINUAR..."

}
	rm -rf *.deb
	loadstrings_us
	systemReadiness
	chooseLanguage
# ------------------------------------------------- script end ------------------------------------------------- #
