#!/bin/sh

#
# Debian Fast-Post Installer script
# Created and developed by Liam Powell (gfelipe099)
# debian-fpi file
# For Debian GNU/Linux 10 (buster) amd64
# 

# set config dir
configDir="/root/.config/debian-fpi/"
# set script parameters
language="${1}"
repository="${2}"
if [ -z ${language} ]; then
    echo "Missing required argument: [language] "
    echo "You must specify which language and repository to use." && echo "" && echo ""
    echo "Usage: debian-fpi [language] [repository]" && echo ""
    echo "Options:"
    echo "  Language:"
    echo "    en"
    echo "    es"
    echo "    fr" && echo ""
    echo "  Repository:"
    echo "    free"
    echo "    nonfree" && echo ""
    echo "Example: sh debian-fpi.sh en free" && echo ""
    exit 1
elif [ -z ${repository} ]; then
    echo "Missing required argument: [repository] "
    echo "You must specify which language and repository to use."
    echo "" && echo ""
    echo "Usage: debian-fpi [language] [repository]"
    echo ""
    echo "Options:"
    echo "  Language:"
    echo "    en"
    echo "    es"
    echo "    fr"
    echo ""
    echo "  Repository:"
    echo "    free"
    echo "    nonfree"
    echo ""
    echo "Example: sh debian-fpi.sh en free"
    echo ""
    exit 2
fi
# set language variables
if [ ${language} = "en" ]; then
    mustExecAsRoot="This script must be executed as root"
    PkgManagerNotFound="APT Package Manager was not found in this system, execution aborted."
    NotUsingDebian="You must be using Debian GNU/Linux 10 (buster) to execute this script."
    welcomeToDebianFpi="Welcome to the Debian Fast-Post Installer tool or Debian-FPI!"
    createdBy="Created by Liam Powell (gfelipe099)"
    kernelVersion="Kernel version in use:"
    errorConfigFileNotFound="ERROR: Configuration file "${configDir}"main.conf not found. Creating a new one..."
    configFileFound="Your configuration file was found and loaded successfully!"
	pkgsConfigFileFound="Your packages configuration file was found and loaded successfully, will be used instead of the default packages."
	pkgsNotConfigFileFound="WARNING: Packages configuration file "${configDir}"pkgs.conf not found. Default packages will be used instead."
    pressAnyKeyToBeginSetup="--> Press ENTER to start..."
    desktopEnv="--> Desktop Enviroment"
    desktopEnvPrompt="Which desktop enviroment do you want to use? (Default: gnome): "
    unknownDesktopEnv="Sorry the desktop enviroment you chose is not available or it is not known yet by the script, please change your configuration file parameters and try again."
    installingDesktopEnv="Installing ${desktopEnviroment} minimal desktop enviroment..."
    installingBSysTools="Installing basic system tools..."
	installingBTools="Installing basic tools..."
    installingWebBrowser="Installing web browser..."
    installingOfficeSuite="Installing office suite..."
    installingGamingSoftware="Installing gaming software..."
    installingMultimediaSoftware="Installing multimedia software..."
    installingDeveloperSoftware="Installing developer software..."
    installingLatestNvidiaDrivers="Installing NVIDIA drivers..."
    installingOpenSourceDrivers="Installing open source drivers..."
    webBrowserSoftwareWarning="The following packages and all their dependencies are going to be installed: ${wbPkgs}"
    officeSuiteSoftwareWarning="The following packages and all their dependencies are going to be installed: ${osPkgs}"
    gamingSoftwareWarning="The following packages and all their dependencies are going to be installed: ${gsPkgs}"
    multimediaSoftwareWarning="The following packages and all their dependencies are going to be installed: ${msPkgs}"
    developerSoftwareWarning="The following packages and all their dependencies are going to be installed: ${dsPkgs}"
    gamingSoftwareWarning="The following packages and all their dependencies are going to be installed: ${gsPkgs}"
    nvidiaLatestDriversWarning="The following packages and all their dependencies are going to be installed: ${lndPkgs}"
    openSourceDriversWarning="The following packages and all their dependencies are going to be installed: ${osdPkgs}"
    warningPrompt="Do you accept this? (Default: no) [Y/N]: "
    warningPromptDisagrement="Operation cancelled, because you didn't agree with the warning."
    configuringBSysTools="Configuring basic system tools..."
    applicationsSettings="--> Applications Settings"
    applicationsSettings_bsystools="Do you want to install basic system tools? (Default: yes): "
    applicationsSettings_btools="Do you want to install basic tools? (Default: yes): "
    applicationsSettings_webbrowser="Do you want to install a web browser? (Default: yes): "
    applicationsSettings_officesuite="Do you want to install an office suite? (Default: yes): "
    applicationsSettings_gaming="Do you want to instasll gaming software? (Default: yes): "
    applicationsSettings_multimedia="Do you want to install multimedia software? (Default: yes): "
    applicationsSettings_developer="Do you want to install developer software? (Default: no): "
    applicationsSettings_nvidia_backports="If you use an NVIDIA graphics card, do you want to install the latest drivers from backports? (Default: no): "
    applicationsSettings_opensource_drivers="If you use an AMD/Intel graphics card, do you want to install the open source drivers? (Default: yes): "
    systemSettings="--> System Settings"
    systemSettings_systemReadiness="For non-free software, you need extra repositories, do you want to run debian-fpi's System Readiness? (Default: no): "
    systemSettings_systemReadiness_checkingForUpdates="Checking for updates and installing them if any..."
    systemSettings_systemReadiness_generatingAptSourcesList="Generating clean APT sources list..."
    systemSettings_createSwapFile="Do you want to create a swap file? (Default: no): "
    systemSettings_createSwapFile_fileSize="How much space do you want to allocate for the swap file? (Default: 4G)"
    systemSettings_applyDebianFixes="Do you want to apply debian-fpi's fixes to your system? (Default: yes): "
    systemSettings_applyDebianFixes_pleaseWait="Applying fixes to your system..."
    notInstallingDesktopEnviroment="Will not install a desktop enviroment per user request"
    notInstallingBasicSystemTools="Will not install basic system tools per user request"
    notInstallingBasicTools="Will not install basic tools per user request"
    notInstallingWebBrowser="Will not install a web browser per user request"
    notInstallingOfficeSuite="Will not install an office suite per user request"
    notInstallingGamingSoftware="Will not install gaming software per user request"
    notInstallingMultimediaSoftware="Will not install multimedia software per user request"
    notInstallingDeveloperSoftware="Will not install developer software per user request"
    notInstallingLatestNvidiaDrivers="Will not install NVIDIA drivers per user request"
    notInstallingOpenSourceDrivers="Will not install open source drivers per user request"
    notRunningSystemReadiness="Will not run System Readiness per user request"
    notCreatingSwapFile="Will not create a swap file per user request"
    notApplyingDebianFixes="Will not apply fixes per user request"
    notSettingUpVirtualization="Not setting up virtualization per user request"
elif [ ${language} = "es" ]; then
    mustExecAsRoot="Este script debe ser ejecutado como root"
    PkgManagerNotFound="El administrador de paquetes APT no fue encontrado en este sistema, ejecución abortada."
    NotUsingDebian="Debes estar usando Debian GNU/Linux 10 (buster) para ejecutar este script."
    welcomeToDebianFpi="¡Bienvenido a la herramienta rápida post-instaladora de Debian o Debian-FPI!"
    createdBy="Creado por Liam Powell (gfelipe099)"
    kernelVersion="Versión del núcleo en uso:"
    errorConfigFileNotFound="ERROR: El archivo de configuración "${configDir}"main.conf no se ha encontrado. Creando uno nuevo..."
    configFileFound="¡Tu archivo de configuración fue encontrado y cargado correctamente!"
	pkgsConfigFileFound="¡Tu archivo de configuración de los paquetes fue encontrado y cargado correctamente!"
	pkgsNotConfigFileFound="AVISO: El archivo de configuración de los paquetes "${configDir}"pkgs.conf no se ha encontrado. Se usarán los paquetes por defecto."
    pressAnyKeyToBeginSetup="--> Presiona ENTER para empezar..."
    desktopEnv="--> Entorno de escritorio"
    desktopEnvPrompt="¿Qué entorno de escritorio quieres usar? (Por defecto: gnome): "
    unknownDesktopEnv="Lo siento, el entorno de escritorio que has elegido no está disponible o no es conocido aún por el script, por favor, cambia los parámetros de tu archivo de configuración e inténtalo de nuevo."
    installingDesktopEnv="Instalando el entorno de escritorio mínimo de ${desktopEnviroment}..."
    installingBSysTools="Instalando herramientas básicas del sistema..."
	installingBTools="Instalando herramientas básicas..."
    installingWebBrowser="Instalando navegador web..."
    installingOfficeSuite="Instalando suite ofimática..."
    installingGamingSoftware="Instalando programas gaming..."
    installingMultimediaSoftware="Instalando programas multimedia..."
    installingDeveloperSoftware="Instalando programas para desarrolladores..."
    installingLatestNvidiaDrivers="Instalando controladores de NVIDIA..."
    installingOpenSourceDrivers="Instalando controladores de código abierto..."
    webBrowserSoftwareWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${wbPkgs}"
    officeSuiteSoftwareWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${osPkgs}"
    gamingSoftwareWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${gsPkgs}"
    multimediaSoftwareWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${msPkgs}"
    developerSoftwareWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${dsPkgs}"
    gamingSoftwareWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${gsPkgs}"
    nvidiaLatestDriversWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${lndPkgs}"
    openSourceDriversWarning="Los siguientes paquetes y todas sus dependencias van a ser instaladas: ${osdPkgs}"
    warningPrompt="¿Aceptas esto? (Pordefecto: no) [Y/N]: "
    warningPromptDisagrement="Operación cancelada, porque no estabas deacuerdo con el aviso."
    configuringBSysTools="Configurando las herramientas básicas del sistema..."
    applicationsSettings="--> Configuración de aplicaciones"
    applicationsSettings_bsystools="¿Quieres instalar herramientas básicas del sistema? (Por defecto: si): "
    applicationsSettings_btools="¿Quieres instalar herramientas básicas? (Por defecto: si): "
    applicationsSettings_webbrowser="¿Quieres instalar un navegador web? (Por defecto: si): "
    applicationsSettings_officesuite="¿Quieres instalar una suite de ofimática? (Por defecto: si): "
    applicationsSettings_gaming="¿Quieres instalar programas para juegos? (Por defecto: si): "
    applicationsSettings_multimedia="¿Quieres instalar programas multimedia? (Por defecto: si): "
    applicationsSettings_developer="¿Quieres instalar programas para desarrolladores? (Por defecto: no): "
    applicationsSettings_nvidia_backports="Si usas una tarjeta gráfica NVIDIA, ¿quieres instalar los últimos controladores desde retroimportaciones (backports)? (Por defecto: no): "
    applicationsSettings_opensource_drivers="Si usas una tarjeta gráfica AMD/Intel, ¿quieres instalar los controladores de código abierto? (Por defecto: si): "
    systemSettings="--> Configuración del sistema"
    systemSettings_systemReadiness="Para programas privativos, necesitas repositorios extra, quieres ejecutar la preparación del sistema de debian-fpi? (Por defecto: no): "
    systemSettings_systemReadiness_checkingForUpdates="Comprobando actualizaciones e instalándolas si las hay..."
    systemSettings_systemReadiness_generatingAptSourcesList="Generando lista de repositorios de APT limpia..."
    systemSettings_createSwapFile="¿Quieres crear un archivo de intercambio? (Por defecto: no): "
    systemSettings_applyDebianFixes="¿Quieres aplicar los arreglos de debian-fpi a tu sistema? (Default: yes): "
    systemSettings_applyDebianFixes_pleaseWait="Aplicando arreglos a tu sistema..."
    notInstallingDesktopEnviroment="No se instalará un entorno de escritorio por petición del usuario"
    notInstallingBasicSystemTools="No se instalarán las herramientas básicas del sistema por petición del usuario"
    notInstallingBasicTools="No se instalarán las herramientas básicas por petición del usuario"
    notInstallingWebBrowser="No se instalará un navegador web por petición del usuario"
    notInstallingOfficeSuite="No se instalará una suite ofimática por petición del usuario"
    notInstallingGamingSoftware="No se instalarán programas gaming por petición del usuario"
    notInstallingMultimediaSoftware="No se instalarán programas multimedia por petición del usuario"
    notInstallingDeveloperSoftware="No se instalarán programas para desarrolladores por petición del usuario"
    notInstallingLatestNvidiaDrivers="No se instalarán los controladores de NVIDIA por petición del usuario"
    notInstallingOpenSourceDrivers="No se instalarán los controladores de código abierto por petición del usuario"
    notRunningSystemReadiness="No se ejecutará la preparación del sistema por petición del usuario"
    notCreatingSwapFile="No se creará un archivo de intercambio por petición del usuario"
    notApplyingDebianFixes="No se aplicarán los arreglos de Debian por petición del usuario"
    notSettingUpVirtualization="No se configurará la virtualización por petición del usuario"
fi

# check if running as root
if [ "$(whoami)" != "root" ]; then
    echo "${mustExecAsRoot}"
    exit 0
    else
        # create configuration directory if it does not exist
        if [ ! -d ${configDir} ]; then
            mkdir -p ${configDir}
        fi
fi
# verify Debian GNU/Linux is running
if [ ! -f /usr/bin/apt ]; then
    echo "${PkgManagerNotFound}"
    exit
    else
        apt-get install -yy lsb-release >/dev/null
        os=$(lsb_release -ds | sed 's/"//g')
fi
if [ "${os}" != "Debian GNU/Linux 10 (buster)" ]; then
    echo "${NotUsingDebian}"
    exit 2
fi

welcome() {
    clear
    apt-get install -yy figlet >/dev/null
    figlet -c "Debian"
    figlet -c "FPI"
    apt-get purge -yy figlet --autoremove >/dev/null
    echo "${welcomeToDebianFpi}"
    echo "${createdBy}"
    echo "${kernelVersion} $(uname -r)"
}

root() {
    if [ ! -f ${configDir}pkgs.conf ] >/dev/null; then
        echo "" && echo "${pkgsNotConfigFileFound}"
    fi
    if [ ! -f ${configDir}main.conf ] >/dev/null; then
        echo "" && echo "${errorConfigFileNotFound}"

        echo "" && echo "" && echo "${desktopEnv}"
        read -p "${desktopEnvPrompt}" desktopEnviroment
        if [ -z ${desktopEnviroment} ]; then
            desktopEnviroment=gnome
        fi
        echo "" && echo "" && echo "-${applicationsSettings}"
        read -p "${applicationsSettings_bsystools}" installBasicSystemTools
        if [ -z ${installBasicSystemTools} ]; then
            installBasicSystemTools=yes
        fi
        read -p "${applicationsSettings_btools}" installBasicTools
        if [ -z ${installBasicTools} ]; then
            installBasicTools=yes
        fi
        read -p "${applicationsSettings_webbrowser}" installWebBrowser
        if [ -z ${installWebBrowser} ]; then
            installWebBrowser=yes
        fi
        read -p "${applicationsSettings_officesuite}" installOfficeSuite
        if [ -z ${installOfficeSuite} ]; then
            installOfficeSuite=no
        fi
        read -p "${applicationsSettings_gaming}" installGamingSoftware
        if [ -z ${installGamingSoftware} ]; then
            installGamingSoftware=no
        fi
        read -p "${applicationsSettings_multimedia}" installMultimediaSoftware
        if [ -z ${installMultimediaSoftware} ]; then
            installMultimediaSoftware=no
        fi
        read -p "${applicationsSettings_developer}" installDeveloperSoftware
        if [ -z ${installDeveloperSoftware} ]; then
            installDeveloperSoftware=no
        fi
        read -p "${applicationsSettings_nvidia_backports}" installLatestNvidiaDrivers
        if [ -z ${installLatestNvidiaDrivers} ]; then
            installLatestNvidiaDrivers=no
        fi
        read -p "${applicationsSettings_opensource_drivers}" installOpenSourceDrivers
        if [ -z ${installOpenSourceDrivers} ]; then
            installOpenSourceDrivers=yes
        fi
        echo "" && echo "" && echo "${systemSettings}"
		if [ ${repository} = "nonfree" ]; then
		    read -p "${systemSettings_systemReadiness}" runSystemReadiness
		    if [ -z ${runSystemReadiness} ]; then
		        runSystemReadiness=no
		    fi
		fi
        read -p "${systemSettings_createSwapFile}" createSwapFile
        if [ -z ${createSwapFile} ]; then
            createSwapFile=no
        fi
        read -p "${systemSettings_applyDebianFixes}" applyDebianFixes
        if [ -z ${applyDebianFixes} ]; then
            applyDebianFixes=yes
        fi
        printf "# Desktop Enviroment\ndesktopEnviroment="${desktopEnviroment}"\n\n# Applications Settings\ninstallBasicSystemTools="${installBasicSystemTools}"\ninstallBasicTools="${installBasicTools}"\ninstallWebBrowser="${installWebBrowser}"\ninstallOfficeSuite="${installOfficeSuite}"\ninstallGamingSoftware="${installGamingSoftware}"\ninstallMultimediaSoftware="${installMultimediaSoftware}"\ninstallDeveloperSoftware="${installDeveloperSoftware}"\ninstallLatestNvidiaDrivers="${installLatestNvidiaDrivers}"\ninstallOpenSourceDrivers="${installOpenSourceDrivers}"\n\n# System Settings\nrunSystemReadiness="${runSystemReadiness}"\ncreateSwapFile="${createSwapFile}"\napplyDebianFixes="${applyDebianFixes}"\n" > ${configDir}main.conf
        else
            . ${configDir}main.conf
            echo "" && echo "${configFileFound}" && echo "" && echo "" && echo ""
	fi
    if [ -f ${configDir}pkgs.conf ]; then
        echo "" && echo "${pkgsConfigFileFound}" && echo "" && echo "${pressAnyKeyToBeginSetup}" && read "" && echo "" && echo ""
        . ${configDir}pkgs.conf
    fi
}

setupDesktopEnviroment() {
    echo "${installingDesktopEnv}"
    if [ ${ desktopEnviroment } = "gnome" ]; then
        apt-get install -yy gdm3* >/dev/null
    elif [ ${desktopEnviroment} = "kde" ]; then
        apt-get install -yy sddm* && apt-get purge -yy discover plasma-discover kinfocenter xterm --autoremove >/dev/null
    elif [ ${desktopEnviroment} = "xfce" ]; then
        apt install -yy xfwm4 xfdesktop4 xfce4-panel xfce4-panel xfce4-settings xfce4-power-manager xfce4-session xfconf xfce4-notifyd >/dev/null
        else
            echo "${unknownDesktopEnv}"
            exit 1
    fi
}

setupBasicSystemTools() {
	if [ ! -f ${configDir}pkgs.conf ]; then
		if [ ${repository} = "nonfree" ]; then
			bstPkgs="selinux-basics selinux-policy-default gufw clamtk gcc make firmware-linux-{nonfree,free} curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji"
		elif [ ${repository} = "free" ]; then
		    bstPkgs="selinux-basics selinux-policy-default gufw clamtk gcc make perl firmware-linux-free curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji"
		fi
		else
			. ${configDir}pkgs.conf
	fi
    echo "${installingBSysTools}"
    apt-get install -yy ${bstPkgs} >/dev/null
    echo "${configuringBSysTools}"
    cp /etc/selinux/config /etc/selinux/config.backup
    sed -i "s/SELINUX=permissive/SELINUX=enforcing/g" /etc/selinux/config && sed -i "s/SELINUXTYPE=default/SELINUXTYPE=mls/g" /etc/selinux/config
    ufw enable >/dev/null
}

setupBasicTools() {
    if [ ${desktopEnviroment} = "gnome" ]; then
        if [ ! -f ${configDir}pkgs.conf ]; then
            btPkgs="nautilus gnome-terminal gedit clamtk-gnome"
            else
                . ${configDir}pkgs.conf
        fi
    elif [ ${desktopEnviroment} = "kde" ]; then
        if [ ! -f ${configDir}pkgs.conf ]; then
        btPkgs="plasma-nm dolphin konsole kate kwin-{x11,wayland}"
            else
                . ${configDir}pkgs.conf
        fi
    elif [ ${desktopEnviroment} = "xfce" ]; then
        if [ ! -f ${configDir}pkgs.conf ]; then
        btPkgs="thunar mousepad ristretto xfce4-{screenshooter,terminal,goodies,themes}"
            else
                . ${configDir}pkgs.conf
        fi
    fi
    while true; do
        read -p "${warningPrompt}" btInstallationWarningAccepted
        if [ -z ${btInstallationWarningAccepted} ]; then
            btInstallationWarningAccepted=no
        elif ${btInstallationWarningAccepted} = "N" ]; then
            btInstallationWarningAccepted=no
        elif ${btInstallationWarningAccepted} = "n" ]; then
            btInstallationWarningAccepted=no
        elif ${btInstallationWarningAccepted} = "Y" ]; then
            btInstallationWarningAccepted=yes
        elif ${btInstallationWarningAccepted} = "y" ]; then
            btInstallationWarningAccepted=yes
        fi
        break
    done
    if [ ${wbInstallationWarningAccepted} = "yes" ]; then
        echo "${installingBTools}" && echo ""
        apt-get update >/dev/null && apt-get install -yy ${btPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupWebBrowser() {
	if [ ! -f ${configDir}pkgs.conf ]; then
	    wbPkgs="firefox-esr"
		else
			. ${configDir}pkgs.conf
	fi
    while true; do
        read -p "${warningPrompt}" wbInstallationWarningAccepted
        if [ -z ${osInstallationWarningAccepted} ]; then
            wbInstallationWarningAccepted=no
        elif ${wbInstallationWarningAccepted} = "N" ]; then
            wbInstallationWarningAccepted=no
        elif ${wbInstallationWarningAccepted} = "n" ]; then
            wbInstallationWarningAccepted=no
        elif ${wbInstallationWarningAccepted} = "Y" ]; then
            wbInstallationWarningAccepted=yes
        elif ${wbInstallationWarningAccepted} = "y" ]; then
            wbInstallationWarningAccepted=yes
        fi
        break
    done
    if [ ${wbInstallationWarningAccepted} = "yes" ]; then
        echo "${installingWebBrowser}" && echo ""
        if [ ${wbPkgs} = *"google-chrome-stable"* ]; then
            wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
            apt-get update >/dev/null && apt-get install -yy google-chrome-stable >/dev/null
        elif [ ${wbPkgs} = *"vivaldi-stable"* ]; then
            wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | apt-key add -
            add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main'
        elif [ ${wbPkgs} = *"brave-browser-stable"* ]; then
			apt-get purge --autoremove brave-{beta,nightly} >/dev/null
            apt-get install -yy apt-transport-https curl >/dev/null
            curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - >/dev/null
            echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
        elif [ ${wbPkgs} = *"brave-browser-beta"* ]; then
			apt-get purge --autoremove brave-{stable,nightly} >/dev/null
            apt-get install -yy apt-transport-https curl >/dev/null
            curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-beta.gpg add - >/dev/null
            echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-beta.list >/dev/null
        elif [ ${wbPkgs} = *"brave-browser-nightly"* ]; then
            apt-get purge --autoremove brave-{stable,beta} >/dev/null
            apt-get install -yy apt-transport-https curl >/dev/null
            curl -s https://brave-browser-apt-nightly.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-nightly.gpg add - >/dev/null
            echo "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-nightly.list >/dev/null
        fi
        apt-get update >/dev/null && apt-get install -yy ${wbPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupOfficeSuite() {
	if [ ! -f ${configDir}pkgs.conf ]; then
	    osPkg="libreoffice"
		else
			. ${configDir}pkgs.conf
	fi
    echo "${officeSuiteSoftwareWarning}"
    while true; do
        read -p "${warningPrompt}" osInstallationWarningAccepted
        if [ -z ${osInstallationWarningAccepted} ]; then
            osInstallationWarningAccepted=no
        elif ${osInstallationWarningAccepted} = "N" ]; then
            osInstallationWarningAccepted=no
        elif ${osInstallationWarningAccepted} = "n" ]; then
            osInstallationWarningAccepted=no
        elif ${osInstallationWarningAccepted} = "Y" ]; then
            osInstallationWarningAccepted=yes
        elif ${osInstallationWarningAccepted} = "y" ]; then
            osInstallationWarningAccepted=yes
        fi
        break
    done
    if [ ${osInstallationWarningAccepted} = "yes" ]; then
        echo "${installingOfficeSuite}" && echo ""
        apt-get install -yy libreoffice >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupGamingSoftware() {
	if [ ! -f ${configDir}pkgs.conf ]; then
	    gsPkgs="steam lutris pcsx2 winehq-staging libvulkan1 libvulkan1:i386 libgl1-mesa-dri:i386 mesa-vulkan-drivers:i386 mesa-vulkan-drivers:i386 libegl-mesa0 libgbm1 libgl1-mesa-dri {libglapi,libglu1}-mesa libglx-mesa0 libosmesa6 mesa-{utils,va-drivers,vdpau-drivers,vulkan-drivers} xserver-xorg-video-nouveau"
		else
			. ${configDir}pkgs.conf
	fi
    echo "${gamingSoftwareWarning}"
    while true; do
        read -p "${warningPrompt}" gsInstallationWarningAccepted
        if [ -z ${gsInstallationWarningAccepted} ]; then
            gsInstallationWarningAccepted=no
        elif ${gsInstallationWarningAccepted} = "N" ]; then
            gsInstallationWarningAccepted=no
        elif ${gsInstallationWarningAccepted} = "n" ]; then
            gsInstallationWarningAccepted=no
        elif ${gsInstallationWarningAccepted} = "Y" ]; then
            gsInstallationWarningAccepted=yes
        elif ${gsInstallationWarningAccepted} = "y" ]; then
            gsInstallationWarningAccepted=yes
        fi
        break
    done
    if [ ${gsInstallationWarningAccepted} = "yes" ]; then
        echo "${installingGamingSoftware}" && echo ""
        if [ ${gsPkgs} = *"lutris"* ]; then
            echo "deb http://download.opensuse.org/repositories/home:/strycore/Debian_10/ ./" | tee /etc/apt/sources.list.d/lutris.list >/dev/null
            wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_10/Release.key -O- | apt-key add -
            apt-get install -yy lutris >/dev/null
        elif [ ${gsPkgs} = *"minecraft-launcher"* ]; then
            wget -q https://launcher.mojang.com/download/Minecraft.deb
            gdebi -nq Minecraft.deb
        elif [ ${gsPkgs} = *"winehq-stable"* ]; then
            dpkg --add-architecture i386
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb && gdebi -nq libfaudio0_20.01-0~buster_amd64.deb
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb && gdebi -nq libfaudio0_20.01-0~buster_i386.deb
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key | apt-key add winehq.key >/dev/null
            echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | tee /etc/apt/sources.list.d/winehq.list >/dev/null
        elif [ ${gsPkgs} = *"winehq-stable"* ]; then
            dpkg --add-architecture i386
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key | apt-key add winehq.key >/dev/null

            echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | tee /etc/apt/sources.list.d/winehq.list >/dev/null
        elif [ ${gsPkgs} = *"winehq-staging"* ]; then
            dpkg --add-architecture i386
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key | apt-key add winehq.key >/dev/null
            echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | tee /etc/apt/sources.list.d/winehq.list >/dev/null
        fi
        apt-get update >/dev/null && apt-get install -yy --install-recommends ${wbPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupMultimediaSoftware() {
	if [ ! -f ${configDir}pkgs.conf ]; then
	    msPkgs="gimp spotify-client discord"
		else
			. ${configDir}pkgs.conf
	fi
    echo "${multimediaSoftwareWarning}"
    while true; do
    read -p "${warningPrompt}" msInstallationWarningAccepted
        if [ -z ${msInstallationWarningAccepted} ]; then
            msInstallationWarningAccepted=no
        elif ${msInstallationWarningAccepted} = "N" ]; then
            msInstallationWarningAccepted=no
        elif ${msInstallationWarningAccepted} = "n" ]; then
            msInstallationWarningAccepted=no
        elif ${msInstallationWarningAccepted} = "Y" ]; then
            msInstallationWarningAccepted=yes
        elif ${msInstallationWarningAccepted} = "y" ]; then
            msInstallationWarningAccepted=yes
        fi
        break
    done
    if [ ${msInstallationWarningAccepted} = "yes" ]; then
        echo "${installingMultimediaSoftware}" && echo ""
        if [ ${msPkgs} = *"spotify-client"* ]; then
            dpkg --add-architecture i386
            curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - >/dev/null
            echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list >/dev/null
        elif [ ${msPkgs} = *"discord"* ]; then
            dpkg --add-architecture i386
            curl -L https://dl.discordapp.net/apps/linux/0.0.12/discord-0.0.12.deb > discord-0.0.12.deb
            gdebi -nq discord-0.0.12.deb >/dev/null
        fi
        apt update >/dev/null && apt-get install -yy ${msPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupDeveloperSoftware() {
	if [ ! -f ${configDir}pkgs.conf ]; then
        dsPkgs="code mesa-opencl-icd"
		else
			. ${configDir}pkgs.conf
	fi
    echo "${developerSoftwareWarning}"
    while true; do
    read -p "${warningPrompt}" dsInstallationWarningAccepted
        if [ -z ${dsInstallationWarningAccepted} ]; then
            dsInstallationWarningAccepted=no
        elif ${dsInstallationWarningAccepted} = "N" ]; then
            dsInstallationWarningAccepted=no
        elif ${dsInstallationWarningAccepted} = "n" ]; then
            dsInstallationWarningAccepted=no
        elif ${dsInstallationWarningAccepted} = "Y" ]; then
            dsInstallationWarningAccepted=yes
        elif ${dsInstallationWarningAccepted} = "y" ]; then
            dsInstallationWarningAccepted=yes
        fi
        break
    done
    if [ ${dsInstallationWarningAccepted} = "yes" ]; then
        echo "" && echo "${installingDeveloperSoftware}" && echo ""
        if [${dsPkgs} = "code" ]; then
			apt install -y wget >/dev/null
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg >/dev/null
			apt purge wget --autoremove -yy
            install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        fi
        apt-get update >/dev/null && apt-get install -yy ${dsPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupLatestNvidiaDrivers() {
	if [ ! -f ${configDir}pkgs.conf ]; then
        lndPkgs="nvidia-driver nvidia-settings nvidia-opencl-icd"
		else
			. ${configDir}pkgs.conf
	fi
    echo "${nvidiaLatestDriversWarning}"
    while true; do
    read -p "${warningPrompt}" lndInstallationWarningAccepted
        if [ -z ${lndInstallationWarningAccepted} ]; then
            lndInstallationWarningAccepted=no
        elif ${lndInstallationWarningAccepted} = "N" ]; then
            lndInstallationWarningAccepted=no
        elif ${lndInstallationWarningAccepted} = "n" ]; then
            lndInstallationWarningAccepted=no
        elif ${lndInstallationWarningAccepted} = "Y" ]; then
            lndInstallationWarningAccepted=yes
        elif ${lndInstallationWarningAccepted} = "y" ]; then
            lndInstallationWarningAccepted=yes
        fi
        break
    done
    read -p "${warningPrompt}" lndInstallationWarningAccepted
    if [ ${lndInstallationWarningAccepted} = "yes" ]; then
        echo "" && echo "${installingLatestNvidiaDrivers}" && echo ""
        apt-get install -yy ${lndPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

setupOpenSourceDrivers() {
    osdPkgs="libgl1-mesa-dri:i386 mesa-vulkan-drivers:i386 libglu1 libglu1:i386 libegl-mesa0 libgbm1 libgl1-mesa-dri {libglapi,libglu1}-mesa libglx-mesa0 libosmesa6 mesa-{utils,va-drivers,vdpau-drivers,vulkan-drivers} xserver-xorg-video-nouveau"
    echo "${openSourceDriversWarning}"
    read -p "${warningPrompt}" osdInstallationWarningAccepted
        if [ -z ${lndInstallationWarningAccepted} ]; then
            lndInstallationWarningAccepted=no
        elif ${lndInstallationWarningAccepted} = "N" ]; then
            lndInstallationWarningAccepted=no
        elif ${lndInstallationWarningAccepted} = "n" ]; then
            lndInstallationWarningAccepted=no
        elif ${lndInstallationWarningAccepted} = "Y" ]; then
            lndInstallationWarningAccepted=yes
        elif ${lndInstallationWarningAccepted} = "y" ]; then
            lndInstallationWarningAccepted=yes
        fi
        break
    if [ ${osdInstallationWarningAccepted} = "yes" ]; then
        echo "" && echo "${installingOpenSourceDrivers}" && echo ""
        apt-get install -yy ${osdPkgs} >/dev/null
        else
            echo "${warningPromptDisagrement}" && echo ""
    fi
}

systemReadiness() {
        echo "${systemSettings_systemReadiness_checkingForUpdates}"
        apt-get update -yy &>/dev/null
        apt-get upgrade -yy &>/dev/null

        echo "${systemSettings_systemReadiness_generatingAptSourcesList}"
        cp /etc/apt/sources.list /etc/apt/sources.list.backup
        if [ ${repository} = "free" ]; then
            printf '#\n# DEBIAN REPOSITORIES\n#\ndeb http://deb.debian.org/debian/ buster main\ndeb-src http://deb.debian.org/debian/ buster main\ndeb http://security.debian.org/debian-security buster/updates main\ndeb-src http://security.debian.org/debian-security buster/updates main\ndeb http://deb.debian.org/debian/ buster-updates main\ndeb-src http://deb.debian.org/debian/ buster-updates main\ndeb http://deb.debian.org/debian/ buster-backports main\ndeb-src http://deb.debian.org/debian/ buster-backports main' > /etc/apt/sources.list
        elif [ ${repository} = "nonfree" ]; then
            printf '#\n# DEBIAN REPOSITORIES\n#\ndeb http://deb.debian.org/debian/ buster main contrib nonfree\ndeb-src http://deb.debian.org/debian/ buster main contrib nonfree\ndeb http://security.debian.org/debian-security buster/updates main contrib nonfree\ndeb-src http://security.debian.org/debian-security buster/updates main contrib nonfree\ndeb http://deb.debian.org/debian/ buster-updates main contrib nonfree\ndeb-src http://deb.debian.org/debian/ buster-updates main contrib nonfree\ndeb http://deb.debian.org/debian/ buster-backports main contrib nonfree\ndeb-src http://deb.debian.org/debian/ buster-backports main contrib nonfree' > /etc/apt/sources.list
        fi
}

setupSwapFile() {
    read -p "${systemSettings_createSwapFile_fileSize}" createSwapFile_size
    dd if=/dev/zero of=/swapfile bs=1M count=${createSwapFile_size} >/dev/null
    chmod 600 /swapfile
    sudo mkswap -L swap /swapfile >/dev/null
    sudo swapon /swapfile >/dev/null
    echo "/swapfile swap swap sw 0 0" >> /etc/fstab
}

setupDebianFixes() {
    echo "${systemSettings_applyDebianFixes_pleaseWait}"
    sed -e 11's/.*/# &//' /etc/network/interfaces && sed -e 12's/.*/# &//' /etc/network/interfaces
    printf '[main]\nplugins=keyfile,ifupdown\n\n[ifupdown]\nmanaged=true\n' > /etc/NetworkManager/NetworkManager.conf
    systemctl restart NetworkManager
    printf 'options bluetooth disable_ertm=1\n' > /etc/modprobe.d/bluetooth.conf
    sed -i 's/; flat-volumes = yes/flat-volumes = no/g' /etc/pulse/daemon.conf
    printf 'snd_hda_intel enable_msi=1\n' /etc/modprobe.d/snd_hda_intel.conf
}

setupVirtualization() {
	dependencies="qemu-kvm ovmf bridge-utils"
	sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on iommu=pt isolcpus= nohz_full= rcu_nocbs= default_hugepagesz=1G hugepagesz=1G hugepages=16 rd.driver.pre=vfio-pci video=efifb:off"/g' /etc/default/grub
	printf 'options kvm_intel nested=1\noptions kvm-intel enable_shadow_vmcs=1\noptions kvm-intel enable_apicv=1\noptions kvm-intel ept=1\n' > /etc/modprobe.d/kvm.conf
	printf 'blacklist nouveau\noptions nouveau modeset=0\n' > /etc/modprobe.d/nouveau.conf
    printf 'options vfio-pci ids=\n' > /etc/modprobe.d/vfio.conf
}

# Consider user choices from the main.conf file, then initialize script functions in this order
welcome
root
setupDesktopEnviroment
if [ ${installBasicSystemTools} = "no" ]; then
    echo "${notInstallingBasicSystemTools}" && echo ""
elif [ ${installBasicSystemTools} = "yes" ]; then
        setupBasicSystemTools
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installBasicTools} = "no" ]; then
    echo "${notInstallingBasicTools}" && echo ""
elif [ ${installBasicTools} = "yes" ]; then
        setupBasicTools
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installWebBrowser} = "no" ]; then
    echo "${notInstallingWebBrowser}" && echo ""
elif [ ${installWebBrowser} = "yes" ]; then
        setupWebBrowser
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installOfficeSuite} = "no" ]; then
    echo "${notInstallingOfficeSuite}" && echo ""
elif [ ${installOfficeSuite} = "yes" ]; then
        setupOfficeSuite
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installGamingSoftware} = "no" ]; then
    echo "${notInstallingGamingSoftware}" && echo ""
elif [ ${installGamingSoftware} = "yes" ]; then
        setupGamingSoftware
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installMultimediaSoftware} = "no" ]; then
    echo "${notInstallingMultimediaSoftware}" && echo ""
elif [ ${installMultimediaSoftware} = "yes" ]; then
        setupMultimediaSoftware
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installDeveloperSoftware} = "no" ]; then
    echo "${notInstallingDeveloperSoftware}" && echo ""
elif [ ${installDeveloperSoftware} = "yes" ]; then
        setupDeveloperSoftware
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installLatestNvidiaDrivers} = "no" ]; then
    echo "${notInstallingLatestNvidiaDrivers}" && echo ""
elif [ ${installLatestNvidiaDrivers} = "yes" ]; then
        setupLatestNvidiaDrivers
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${installOpenSourceDrivers} = "no" ]; then
    echo "${notInstallingOpenSourceDrivers}" && echo ""
elif [ ${installOpenSourceDrivers} = "yes" ]; then
        setupOpenSourceDrivers
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${repository} = "nonfree" ]; then
	if [ ${runSystemReadiness} = "no" ]; then
		echo "${notRunningSystemReadiness}" && echo ""
	elif [ ${runSystemReadiness} = "yes" ]; then
		    systemReadiness
		else
		    echo "${invalidConfig}"
		    exit 2
	fi
fi
if [ ${createSwapFile} = "no" ]; then
    echo "${notCreatingSwapFile}" && echo ""
elif [ ${createSwapFile} = "yes" ]; then
        setupSwapFile
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${applyDebianFixes} = "no" ]; then
    echo "${notApplyingDebianFixes}" && echo ""
elif [ ${applyDebianFixes} = "yes" ]; then
        setupDebianFixes
    else
        echo "${invalidConfig}"
        exit 2
fi

if [ ${configureVirtualization} = "no" ]; then
    echo "${notSettingUpVirtualization}" && echo ""
elif [ ${configureVirtualization} = "yes" ]; then
        setupVirtualization
    else
        echo "${invalidConfig}"
        exit 2
fi
