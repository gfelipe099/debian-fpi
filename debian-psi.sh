#!/bin/bash

#
# Created by Liam Powell (gfelipe099)
# A fork from MatMoul's https://github.com/MatMoul/archfi
# debian-fpi.sh file
# For Debian GNU/Linux 10.2.0/10.3.0 (buster) desktop amd64
#
appTitle="Debian Fast Post-Installer Setup v20200404.0-alpha (Early Build)"

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

# check if the OS is Debian
# credits to https://danielgibbs.co.uk
# source: https://danielgibbs.co.uk/2013/04/bash-how-to-detect-os/
distroInfo="Debian $(cat /etc/debian_version) $(uname -r)"

if [[ "$distroInfo" = "Debian 10.2 4.19.0-6-amd64" || "Debian 10.3 4.19.0-8-amd64" ]]; then
    # Fix potential missing applications icons by
    # creating this directory before installing
    # anything.
    mkdir /usr/share/desktop-directories/ 

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
	options+=("${txtreboot}" "(Shutdown the computer and then start it up again)")
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
		reboot
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

baseSetup(){
	options=()
	options+=("${txtsetupbaseinstalldesktop}" "${txtbasedesc}")
	options+=("${txtsetupbaseswapfile4g}" "${txtsetupbaseswapfile4gdesc}")
	options+=("${txtsetupbaseswapfile8g}" "${txtsetupbaseswapfile8gdesc}")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtsetupbase}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtsetupbaseswapfile4g}" ]; then
			fallocate -l 4G /swapfile
			chmod 0600 /swapfile
			mkswap -L swap /swapfile
			swapon swapfile
			echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtsetupbaseswapfile8g}" ]; then
			fallocate -l 8G /swapfile
			chmod 0600 /swapfile
			mkswap -L swap /swapfile
			swapon swapfile
			echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
			pressanykey
			nextitem="."
		fi
		if [ "${sel}" = "${txtsetupbaseinstalldesktop}" ]; then
			options=()
			options+=("GNOME" "(${txttestedworking})")
			options+=("KDE Plasma" "(${txtnottestedyet})")
			sel=$(whiptail --backtitle "${appTitle}" --title "${txtsetupbaseselectdesktop}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
			"${options[@]}" \
			3>&1 1>&2 2>&3)
		if [ "$?" = "0" ]; then
			clear
				if [ "${sel}" = "GNOME" ]; then
					apt install -yy gdm3*
					pressanykey
					nextitem="."
				elif [ "${sel}" = "KDE Plasma" ]; then
					apt install -yy sddm*
					pressanykey
					nextitem="."
				fi
		fi
	fi
fi
}

extrasSetup(){
	options=()
	options+=("${txtextrassetupx86_packages}" "(Required to install Steam or Spotify)")
	options+=("${txtextrassetup_bsystools}" "(Required to install Spotify)")
	options+=("${txtextrassetup_webbrowser}" "(Installs Firefox ESR)")
	options+=("${txtextrassetup_officesuite}" "(Installs LibreOffice)")
	options+=("${txtextrassetup_gaming}" "(Installs Steam, Lutris and PCSX2)")
	options+=("${txtextrassetup_multimedia}" "(Installs GIMP and VLC)")
	options+=("${txtextrassetup_nvidia}" "(Installs NVIDIA propietary drivers)")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtextrassetup}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtextrassetupx86_packages}" ]; then
			dpkg --add-architecture i386 && apt update
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_bsystools}" ]; then
			apt install -yy gdebi nautilus gnome-terminal gnome-disk-utility gnome-system-monitor gedit gcc make perl curl linux-headers-$(uname -r)
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_webbrowser}" ]; then
			apt install -yy firefox-esr
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_officesuite}" ]; then
			apt install -yy libreoffice
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_gaming}" ]; then
			apt install -yy steam lutris pcsx2
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_multimedia}" ]; then
			apt install gimp vlc vlc-data
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtextrassetup_nvidia}" ]; then
    			while true; do
        			read -p "Do you want to install the drivers for your NVIDIA graphics card (if any)? (reboot required): " input
        			case $input in
            				[Yy]* ) sleep 2; sudo apt install -y nvidia-driver; echo -e; break;;
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
	options=()
	options+=("${txtvirtualizationsetup_installpkgs}" "(Installs qemu-kvm, virt-manager, bridge-utils, ovmf)")
	options+=("${txtvirtualizationsetup_backupsysfiles}" "(Backups grub config file, APT sources.list, initramfs-tools/modules)")
	options+=("${txtvirtualizationsetup_enableiommu}" "(Modifies grub.cfg accordingly)")
	options+=("${txtvirtualizationsetup_enablenested}" "(Enables the virtualization of VT-x/AMD-V)")
	options+=("${txtvirtualizationsetup_aptsourcelist}" "(Creates a new and clean APT sources.list file)")
	options+=("${txtvirtualizationsetup_updategrub}" "(Updates GRUB configuration file)")
	options+=("${txtvirtualizationsetup_updateinitramfs}" "(Updates initramfs boot files)")
	sel=$(whiptail --backtitle "${appTitle}" --title "${txtvirtualizationsetup}" --cancel-button "${txtreturn}" --menu "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		if [ "${sel}" = "${txtvirtualizationsetup_installpkgs}" ]; then
			apt install -y qemu-kvm virt-manager bridge-utils ovmf
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtvirtualizationsetup_backupsysfiles}" ]; then
			cp /etc/default/grub /etc/default/grub.backup &&
			cp /etc/apt/sources.list /etc/apt/sources.list.backup &&
			cp /etc/initramfs-tools/modules /etc/initramfs-tools/modules.backup
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtvirtualizationsetup_enableiommu}" ]; then
			printf '# If you change this file, run "update-grub" afterwards to update
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
#GRUB_INIT_TUNE="480 440 1"' > /etc/default/grub
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtvirtualizationsetup_enablenested}" ]; then
			printf 'options kvm_intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1' > /etc/modprobe.d/kvm.conf
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtvirtualizationsetup_aptsourcelist}" ]; then
			echo -n "Generating new APT sources file..."; printf '#
# DEBIAN REPOSITORIES
#
# main repository
deb http://deb.debian.org/debian/ buster main non-free contrib
deb-src http://deb.debian.org/debian/ buster main non-free contrib
# security-updates repositories
deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free
# updates repository
deb http://deb.debian.org/debian/ buster-updates main contrib non-free
deb-src http://deb.debian.org/debian/ buster-updates main contrib non-free
# backports repository
deb http://deb.debian.org/debian/ buster-backports main contrib non-free
deb-src http://deb.debian.org/debian/ buster-backports main contrib non-free
#
# THIRD-PARTY REPOSITORIES
#
deb http://repository.spotify.com stable non-free' > /etc/apt/sources.list
			pressanykey
			nextitem="."
		elif [ "${sel}" = "${txtvirtualizationsetup_updategrub}" ]; then
			update-grub
			pressanykey
			nextitem="."

		elif [ "${sel}" = "${txtvirtualizationsetup_updateinitramfs}" ]; then
			update-initramfs -u -k all
			pressanykey
			nextitem="."
		fi
	fi
}

pressanykey(){
	read -n1 -p "${txtpressanykey}"
}

loadstrings_us(){
	locale=en_US.UTF-8

	lang_us="English (US)"
	lang_es="Spanish (Spain)"
	langdesc="(By Liam Powell)"

	txtexit="Exit"
	txtreturn="Return"
	txtignore="Ignore"

	txtmainmenu="Main Menu"
	txtlanguage="Change Language"
	txtlanguagedesc="(Default Language: English US)"

	txtbase="Base"
        txtbasedesc="[Install a DE (in headless mode)]"
	txtsetupbase="Base Setup"	
	txtsetupbaseselectdesktop="Select Desktop"
	txtsetupbaseinstalldesktop="Install Desktop"
	txtsetupbaseswapfile="Create Swap File"
	txtsetupbaseswapfilesize="Select Swap File Size"
	txtsetupbaseswapfile4g="Create a 4G Swap File"
	txtsetupbaseswapfile4gdesc="(Optimal for systems with >16G of RAM)"
	txtsetupbaseswapfile8g="Create a 8G Swap File"
	txtsetupbaseswapfile8gdesc="(Optimal for systems with >16G of RAM)"

	txtextras="Extras"
	txtextrasdesc="(Tools, Drivers and Applications for Debian)"
	txtextrassetup="Extras Setup"
	txtextrassetupx86_packages="1.- Add 32-bit support to APT"
	txtextrassetup_bsystools="2.- Install Basic System Tools"
	txtextrassetup_webbrowser="3.- Install Web Browser"
	txtextrassetup_officesuite="4.- Install Office Suite"
	txtextrassetup_gaming="5.- Install Gaming Software"
	txtextrassetup_multimedia="6.- Install Multimedia Software"
	txtextrassetup_nvidia="7.- Install NVIDIA Drivers"

	txtvirtualization="Virtualization"
	txtvirtualizationdesc="(Install qemu-kvm, Enable Nested Virtualization, etc.)"
	txtvirtualizationsetup="Virtualization Setup"
	txtvirtualizationsetup_installpkgs="1.- Install Required Packages"
	txtvirtualizationsetup_backupsysfiles="2.- Backup system files"
	txtvirtualizationsetup_enableiommu="3.- Enable IOMMU"
	txtvirtualizationsetup_enablenested="4.- Enable Nested Virtualization"
	txtvirtualizationsetup_aptsourcelist="5.- Create APT sources.list file"
	txtvirtualizationsetup_updategrub="6.- Update GRUB config file"
	txtvirtualizationsetup_updateinitramfs="7.- Update boot files"

	txtreboot="Reboot"

	txttestedworking="Tested and working"
	txtnottestedyet="Not tested yet"

	txtpressanykey="PRESS ANY KEY TO CONTINUE..."
}

loadstrings_es(){
	locale=es_ES.UTF-8

	lang_us="Inglés (EE.UU.)"
	lang_es="Español (España)"
	langdesc="(Por Liam Powell)"

	txtexit="Salir"
	txtreturn="Volver"
	txtignore="Ignorar"

	txtmainmenu="Menú principal"
	txtlanguage="Cambiar idioma"
	txtlanguagedesc="(Idioma por defecto: English US)"

	txtbase="Base"
        txtbasedesc="[Instalar DE (en modo headless)]"
	txtsetupbase="Instalación base"	
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
	txtextrassetup_gaming="5.- Install programas para jugar"
	txtextrassetup_multimedia="6.- Install programas multimedia"
	txtextrassetup_nvidia="7.- Instalar controladores de NVIDIA"

	txtvirtualization="Virtualización"
	txtvirtualizationdesc="(Instalar qemu-kvm, habilitar virtualización anidada, etc.)"
	txtvirtualizationsetup="Instalación de virtualización"
	txtvirtualizationsetup_installpkgs="1.- Instalar paquetes requeridos"
	txtvirtualizationsetup_backupsysfiles="2.- Copia de seguridad de los archivos del sistema"
	txtvirtualizationsetup_enableiommu="3.- Habilitar IOMMU"
	txtvirtualizationsetup_enablenested="4.- Habilitar virtualización anidada"
	txtvirtualizationsetup_aptsourcelist="5.- Crear archivo sources.list de APT"
	txtvirtualizationsetup_updategrub="6.- Actualizar archivo de configuración GRUB"
	txtvirtualizationsetup_updateinitramfs="7.- Actualizar archivos de arranque"

	txtreboot="Reiniciar"

	txttestedworking="Probado y funcionando"
	txtnottestedyet="Aún sin probar"

	txtpressanykey="PRESIONA CUALQUIER TECLA PARA CONTINUAR..."
}

	loadstrings_us
	root
    else
        echo -e "${boldText}${red}Sorry, ${distroInfo} is not supported yet."${normalText}
        exit 1
fi
# ------------------------------------------------- script end ------------------------------------------------- #
