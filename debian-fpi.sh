#!/bin/sh

#
# Debian Fast-Post Installer script
# Created and developed by Liam Powell (gfelipe099)
# debian-fpi file
# For Debian GNU/Linux 10 (buster) amd64
#

# set config dir
configDir="${HOME}/.config/debian-fpi/"

# set script parameters
language="${1}"
repository="${2}"

if [ -z ${language} ] || [ -z "${repository}" ]; then
    printf "\nUsage: "${0}" [language] [repository]

You must specify which language and repository from these options:
    ==> Language:
        --> en
        --> es
        --> fr
    ==> Repository:
        --> free
        --> nonfree

Example: sh debian-fpi.sh en free\n\n"
    exit 1
fi

# set language variables
if [ "${language}" = "en" ]; then
    for lang in ./lang/*.lang; do
        if [ -f ./lang/en-us.lang ]; then
            . ./lang/en-us.lang
            else
                echo "ERROR: en-us.lang: file not found"
                exit 1
        fi
    done
elif [ "${language}" = "es" ]; then
    for lang in ./lang/*.lang; do
        if [ -f ./lang/es-es.lang ]; then
            . ./lang/es-es.lang
            else
                echo "ERROR: en-us.lang: file not found"
                exit 1
        fi
    done
elif [ "${language}" = "fr" ]; then
    for lang in ./lang/*.lang; do
        if [ -f ./lang/fr-fr.lang ]; then
            . ./lang/fr-fr.lang
            else
                echo "ERROR: fr-fr.lang: file not found"
                exit 1
        fi
    done
    else
        echo "ERROR: "${language}": language not found"
        exit 1
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
    echo "${pkgManagerNotFound}"
    exit
    else
        apt-get install -y lsb-release > /dev/null 2>&1
        os=$(lsb_release -ds | sed 's/"//g')
fi
if [ "${os}" != "Debian GNU/Linux 11 (bullseye)" ]; then
    echo "${notUsingDebian}"
    exit 2
fi

welcome() {
    clear
    echo "${pleaseWait}"
    apt-get install -y figlet > /dev/null 2>&1
    clear
    figlet -c "Debian"
    figlet -c "FPI"
    apt-get purge -y figlet --autoremove > /dev/null 2>&1
    printf "${welcomeToDebianFpi}\n${createdBy}\n${kernelVersion} $(uname -r)"
}

root() {
    if [ ! -f "${configDir}/pkgs.conf" ] > /dev/null 2>&1; then
        echo ""; echo "${pkgsConfigFileNotFound}"
        else
            if [ -f "${configDir}/pkgs.conf" ]; then
                echo ""; echo "${pkgsConfigFileFound}"; echo ""
                read -p "${startPrompt}" input
                    if [ -z ${input} ]; then
                        exit
                    elif [ ${input} = "no" ]; then
                        exit
                    fi
                echo ""; echo ""
                . "${configDir}/pkgs.conf"
            fi
    fi
    if [ ! -f "${configDir}/main.conf" ] > /dev/null 2>&1; then
        echo ""; echo "${configFileNotFound}"; echo ""; echo ""

        read -p "${useDesktopEnviroment}" installDesktopEnviroment
        if [ -z "${installDesktopEnviroment}" ]; then
            installDesktopEnviroment="no"
            desktopEnviroment="null"
        elif [ "${installDesktopEnviroment}" = "yes" ]; then
            echo ""; echo ""; echo "${desktopEnv}"
            read -p "${desktopEnvPrompt}" desktopEnviroment
            if [ -z "${desktopEnviroment}" ]; then
                desktopEnviroment="gnome"
            fi
        elif [ "${installDesktopEnviroment}" = "no" ]; then
            installDesktopEnviroment="no"
            desktopEnviroment="null"
        fi
        echo ""; echo ""; echo "${applicationsSettings}"
        read -p "${applicationsSettings_bsystools}" installBasicSystemTools
        if [ -z "${installBasicSystemTools}" ]; then
            installBasicSystemTools="yes"
        fi
        read -p "${applicationsSettings_btools}" installBasicTools
        if [ -z "${installBasicTools}" ]; then
            installBasicTools="yes"
        fi
        read -p "${applicationsSettings_webbrowser}" installWebBrowser
        if [ -z "${installWebBrowser}" ]; then
            installWebBrowser="yes"
        fi
        read -p "${applicationsSettings_officesuite}" installOfficeSuite
        if [ -z "${installOfficeSuite}" ]; then
            installOfficeSuite="no"
        fi
        read -p "${applicationsSettings_gaming}" installGamingSoftware
        if [ -z "${installGamingSoftware}" ]; then
            installGamingSoftware="no"
        fi
        read -p "${applicationsSettings_multimedia}" installMultimediaSoftware
        if [ -z "${installMultimediaSoftware}" ]; then
            installMultimediaSoftware="no"
        fi
        read -p "${applicationsSettings_developer}" installDeveloperSoftware
        if [ -z "${installDeveloperSoftware}" ]; then
            installDeveloperSoftware="no"
        fi
        read -p "${applicationsSettings_nvidia_backports}" installLatestNvidiaDrivers
        if [ -z "${installLatestNvidiaDrivers}" ]; then
            installLatestNvidiaDrivers="no"
        fi
        read -p "${applicationsSettings_opensource_drivers}" installOpenSourceDrivers
        if [ -z "${installOpenSourceDrivers}" ]; then
            installOpenSourceDrivers="yes"
        fi
        echo ""; echo ""; echo "${systemSettings}"
        if [ "${repository}" = "nonfree" ]; then
            read -p "${systemSettings_systemReadiness}" runSystemReadiness
            if [ -z "${runSystemReadiness}" ] || [ "${runSystemReadiness}" = "" ]; then
                runSystemReadiness="no"
                else
                    runSystemReadiness="no"
            fi
        fi
        read -p "${systemSettings_createSwapFile}" createSwapFile
        if [ -z "${createSwapFile}" ]; then
            createSwapFile="no"
        fi
        read -p "${systemSettings_applyDebianFixes}" applyDebianFixes
        if [ -z ${applyDebianFixes} ]; then
            applyDebianFixes="yes"
        fi
        read -p "${systemSettings_configureVirtualization}" configureVirtualization
        if [ -z "${configureVirtualization}" ]; then
            configureVirtualization="no"
        fi
        printf '# Desktop Enviroment\ndesktopEnviroment="${desktopEnviroment}"\n\n# Applications Settings\ninstallDesktopEnviroment="${installDesktopEnviroment}"\ninstallBasicSystemTools="${installBasicSystemTools}"\ninstallBasicTools="${installBasicTools}"\ninstallWebBrowser="${installWebBrowser}"\ninstallOfficeSuite="${installOfficeSuite}"\ninstallGamingSoftware="${installGamingSoftware}"\ninstallMultimediaSoftware="${installMultimediaSoftware}"\ninstallDeveloperSoftware="${installDeveloperSoftware}"\ninstallLatestNvidiaDrivers="${installLatestNvidiaDrivers}"\ninstallOpenSourceDrivers="${installOpenSourceDrivers}"\n\n# System Settings\nrunSystemReadiness="${runSystemReadiness}"\ncreateSwapFile="${createSwapFile}"\napplyDebianFixes="${applyDebianFixes}"\nconfigureVirtualization="${configureVirtualization}"\n' > "${configDir}/main.conf"
        echo ""; read -p "${startPrompt}" input
            if [ -z ${input} ]; then
                exit
            elif [ ${input} = "no" ]; then
                exit
            fi; echo ""; echo ""
        else
            . "${configDir}/main.conf"
            echo ""; echo "${configFileFound}"; echo ""
        read -p "${startPrompt}" input
            if [ -z ${input} ]; then
                exit
            elif [ ${input} = "no" ]; then
                exit
            fi
    fi
}

setupDesktopEnviroment() {
    echo "${installingDesktopEnv}"
    if [ "${desktopEnviroment}" = "gnome" ]; then
        apt-get install -y gdm3* > /dev/null 2>&1
    elif [ "${desktopEnviroment}" = "kde" ]; then
        apt-get install -y sddm* > /dev/null 2>&1; apt-get purge -y discover plasma-discover kinfocenter xterm --autoremove > /dev/null 2>&1
    elif [ "${desktopEnviroment}" = "xfce" ]; then
        apt-get install -y xfce4 > /dev/null 2>&1
    elif [ "${desktopEnviroment}" = "awesome" ]; then
        apt install -y git awesome fonts-roboto rofi compton \
                        i3lock xclip qt5-style-plugins materia-gtk-theme \
                        lxappearance xbacklight flameshot nautilus xfce4-power-manager \
                        pnmixer network-manager-gnome policykit-1-gnome qt5-style-plugins > /dev/null 2>&1
        printf "XDG_CURRENT_DESKTOP=Unity\nQT_QPA_PLATFORMTHEME=gtk2\n" >> /etc/environment
        git clone --branch debian https://github.com/ChrisTitusTech/titus-awesome ~/.config/awesome
        mkdir -p ~/.config/rofi
        cp $HOME/.config/awesome/theme/config.rasi ~/.config/rofi/config.rasi
        sed -i '/@import/c\@import "'$HOME'/.config/awesome/theme/sidebar.rasi"' ~/.config/rofi/config.rasi
        else
            echo "${unknownDesktopEnv}"
            exit 1
    fi
}

setupBasicSystemTools() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        if [ "${repository}" = "nonfree" ]; then
            bstPkgs="selinux-basics selinux-policy-default auditd gufw clamtk gcc make firmware-linux-{nonfree,free} curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji"
        elif [ "${repository}" = "free" ]; then
            bstPkgs="selinux-basics selinux-policy-default auditd fail2ban gufw clamtk gcc make perl firmware-linux-free curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji"
        fi
        else
            . "${configDir}/pkgs.conf"
    fi
    echo "${installingBSysTools}"
    apt-get install -y "${bstPkgs}" > /dev/null 2>&1
    echo "${configuringBSysTools}"
    if [ -d "/etc/selinux" ]; then
        selinux-activate > /dev/null 2>&1
    fi
    ufw enable > /dev/null 2>&1
    systemctl enable --now fail2ban > /dev/null 2>&1 2>&1
}

setupBasicTools() {
    if [ "${desktopEnviroment}" = "gnome" ]; then
        if [ ! -f "${configDir}/pkgs.conf" ]; then
            btPkgs="nautilus gnome-terminal gedit clamtk-gnome"
            else
                . "${configDir}/pkgs.conf"
        fi
    elif [ "${desktopEnviroment}" = "kde" ]; then
        if [ ! -f "${configDir}/pkgs.conf" ]; then
            btPkgs="plasma-nm dolphin konsole kate kwin-{x11,wayland}"
            else
                . "${configDir}/pkgs.conf"
        fi
    elif [ "${desktopEnviroment}" = "xfce" ]; then
        if [ ! -f "${configDir}/pkgs.conf" ]; then
            btPkgs="thunar mousepad ristretto xfce4-{screenshooter,terminal,goodies,themes}"
            else
                . "${configDir}/pkgs.conf"
        fi
    fi
    while true; do
        read -p "${warningPrompt}" btInstallationWarningAccepted
        if [ -z "${btInstallationWarningAccepted}" ]; then
            btInstallationWarningAccepted="no"
        elif [ "${btInstallationWarningAccepted}" = "N" ]; then
            btInstallationWarningAccepted="no"
        elif [ "${btInstallationWarningAccepted}" = "n" ]; then
            btInstallationWarningAccepted="no"
        elif [ "${btInstallationWarningAccepted}" = "Y" ]; then
            btInstallationWarningAccepted="yes"
        elif [ "${btInstallationWarningAccepted}" = "y" ]; then
            btInstallationWarningAccepted="yes"
        fi
        break
    done
    if [ "${wbInstallationWarningAccepted}" = "yes" ]; then
        echo "${installingBTools}"; echo ""
        apt-get update > /dev/null 2>&1; apt-get install -y "${btPkgs}" > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupWebBrowser() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        wbPkgs="firefox-esr"
        else
            . "${configDir}/pkgs.conf"
    fi
    while true; do
        read -p "${warningPrompt}" wbInstallationWarningAccepted
        if [ -z "${osInstallationWarningAccepted}" ]; then
            wbInstallationWarningAccepted="no"
        elif [ "${wbInstallationWarningAccepted}" = "N" ]; then
            wbInstallationWarningAccepted="no"
        elif [ "${wbInstallationWarningAccepted}" = "n" ]; then
            wbInstallationWarningAccepted="no"
        elif [ "${wbInstallationWarningAccepted}" = "Y" ]; then
            wbInstallationWarningAccepted="yes"
        elif [ "${wbInstallationWarningAccepted}" = "y" ]; then
            wbInstallationWarningAccepted="yes"
        fi
        break
    done
    if [ "${wbInstallationWarningAccepted}" = "yes" ]; then
        echo "${installingWebBrowser}"; echo ""
        if [ ${wbPkgs} = *"google-chrome-stable"* ]; then
            wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
            apt-get update > /dev/null 2>&1; apt-get install -y google-chrome-stable > /dev/null 2>&1
        elif [ ${wbPkgs} = *"vivaldi-stable"* ]; then
            wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | apt-key add -
            add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main'
        elif [ ${wbPkgs} = *"brave-browser-stable"* ]; then
            apt-get purge --autoremove brave-{beta,nightly} > /dev/null 2>&1
            apt-get install -y apt-transport-https curl > /dev/null 2>&1
            curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - > /dev/null 2>&1
            echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null 2>&1
        elif [ ${wbPkgs} = *"brave-browser-beta"* ]; then
            apt-get purge --autoremove brave-{stable,nightly} > /dev/null 2>&1
            apt-get install -y apt-transport-https curl > /dev/null 2>&1
            curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-beta.gpg add - > /dev/null 2>&1
            echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-beta.list > /dev/null 2>&1
        elif [ ${wbPkgs} = *"brave-browser-nightly"* ]; then
            apt-get purge --autoremove brave-{stable,beta} > /dev/null 2>&1
            apt-get install -y apt-transport-https curl > /dev/null 2>&1
            curl -s https://brave-browser-apt-nightly.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-nightly.gpg add - > /dev/null 2>&1
            echo "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-nightly.list > /dev/null 2>&1
        fi
        apt-get update > /dev/null 2>&1; apt-get install -y ${wbPkgs} > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupOfficeSuite() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        osPkg="libreoffice"
        else
            . "${configDir}/pkgs.conf"
    fi
    echo "${officeSuiteSoftwareWarning}"
    while true; do
        read -p "${warningPrompt}" osInstallationWarningAccepted
        if [ -z "${osInstallationWarningAccepted}" ]; then
            osInstallationWarningAccepted="no"
        elif [ "${osInstallationWarningAccepted}" = "N" ]; then
            osInstallationWarningAccepted="no"
        elif [ "${osInstallationWarningAccepted}" = "n" ]; then
            osInstallationWarningAccepted="no"
        elif [ "${osInstallationWarningAccepted}" = "Y" ]; then
            osInstallationWarningAccepted="yes"
        elif [ "${osInstallationWarningAccepted}" = "y" ]; then
            osInstallationWarningAccepted="yes"
        fi
        break
    done
    if [ "${osInstallationWarningAccepted}" = "yes" ]; then
        echo "${installingOfficeSuite}"; echo ""
        apt-get install -y libreoffice > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupGamingSoftware() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        gsPkgs="steam lutris pcsx2 winehq-staging"
        else
            . "${configDir}/pkgs.conf"
    fi
    echo "${gamingSoftwareWarning}"
    while true; do
        read -p "${warningPrompt}" gsInstallationWarningAccepted
        if [ -z "${gsInstallationWarningAccepted}" ]; then
            gsInstallationWarningAccepted="no"
        elif [ "${gsInstallationWarningAccepted}" = "N" ]; then
            gsInstallationWarningAccepted="no"
        elif [ "${gsInstallationWarningAccepted}" = "n" ]; then
            gsInstallationWarningAccepted="no"
        elif [ "${gsInstallationWarningAccepted}" = "Y" ]; then
            gsInstallationWarningAccepted="yes"
        elif [ "${gsInstallationWarningAccepted}" = "y" ]; then
            gsInstallationWarningAccepted="yes"
        fi
        break
    done
    if [ "${gsInstallationWarningAccepted}" = "yes" ]; then
        echo "${installingGamingSoftware}"; echo ""
        if [ ${gsPkgs} = *"lutris"* ]; then
            echo "deb http://download.opensuse.org/repositories/home:/strycore/Debian_10/ ./" | tee /etc/apt/sources.list.d/lutris.list > /dev/null 2>&1
            wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_10/Release.key -O- | apt-key add -
            apt-get install -y lutris > /dev/null 2>&1
        elif [ ${gsPkgs} = *"minecraft-launcher"* ]; then
            wget -q https://launcher.mojang.com/download/Minecraft.deb
            gdebi -nq Minecraft.deb
        elif [ ${gsPkgs} = *"winehq-stable"* ]; then
            dpkg --add-architecture i386
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb; gdebi -nq libfaudio0_20.01-0~buster_amd64.deb
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb; gdebi -nq libfaudio0_20.01-0~buster_i386.deb
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key | apt-key add winehq.key > /dev/null 2>&1
            echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | tee /etc/apt/sources.list.d/winehq.list > /dev/null 2>&1
        elif [ ${gsPkgs} = *"winehq-stable"* ]; then
            dpkg --add-architecture i386
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key | apt-key add winehq.key > /dev/null 2>&1

            echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | tee /etc/apt/sources.list.d/winehq.list > /dev/null 2>&1
        elif [ ${gsPkgs} = *"winehq-staging"* ]; then
            dpkg --add-architecture i386
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key | apt-key add winehq.key > /dev/null 2>&1
            echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | tee /etc/apt/sources.list.d/winehq.list > /dev/null 2>&1
        fi
        apt-get update > /dev/null 2>&1; apt-get install -y --install-recommends ${wbPkgs} > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupMultimediaSoftware() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        msPkgs="gimp spotify-client discord"
        else
            . "${configDir}/pkgs.conf"
    fi
    echo "${multimediaSoftwareWarning}"
    while true; do
    read -p "${warningPrompt}" msInstallationWarningAccepted
        if [ -z "${msInstallationWarningAccepted}" ]; then
            msInstallationWarningAccepted="no"
        elif [ "${msInstallationWarningAccepted}" = "N" ]; then
            msInstallationWarningAccepted="no"
        elif [ "${msInstallationWarningAccepted}" = "n" ]; then
            msInstallationWarningAccepted="no"
        elif [ "${msInstallationWarningAccepted}" = "Y" ]; then
            msInstallationWarningAccepted="yes"
        elif [ "${msInstallationWarningAccepted}" = "y" ]; then
            msInstallationWarningAccepted="yes"
        fi
        break
    done
    if [ "${msInstallationWarningAccepted}" = "yes" ]; then
        echo "${installingMultimediaSoftware}"; echo ""
        if [ "${msPkgs}" = *"spotify-client"* ]; then
            dpkg --add-architecture i386
            curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - > /dev/null 2>&1
            echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list > /dev/null 2>&1
        elif [ "${msPkgs}" = *"discord"* ]; then
            dpkg --add-architecture i386
            curl -L https://dl.discordapp.net/apps/linux/0.0.12/discord-0.0.12.deb > discord-0.0.12.deb
            gdebi -nq discord-0.0.12.deb > /dev/null 2>&1
        fi
        apt update > /dev/null 2>&1; apt-get install -y "${msPkgs}" > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupDeveloperSoftware() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        dsPkgs="code mesa-opencl-icd"
        else
            . "${configDir}/pkgs.conf"
    fi
    echo "${developerSoftwareWarning}"
    while true; do
    read -p "${warningPrompt}" dsInstallationWarningAccepted
        if [ -z "${dsInstallationWarningAccepted}" ]; then
            dsInstallationWarningAccepted="no"
        elif "${dsInstallationWarningAccepted}" = "N" ]; then
            dsInstallationWarningAccepted="no"
        elif "${dsInstallationWarningAccepted}" = "n" ]; then
            dsInstallationWarningAccepted="no"
        elif "${dsInstallationWarningAccepted}" = "Y" ]; then
            dsInstallationWarningAccepted="yes"
        elif "${dsInstallationWarningAccepted}" = "y" ]; then
            dsInstallationWarningAccepted="yes"
        fi
        break
    done
    if [ "${dsInstallationWarningAccepted}" = "yes" ]; then
        echo ""; echo "${installingDeveloperSoftware}"; echo ""
        if [ "${dsPkgs}" = "code" ]; then
            apt install -y wget > /dev/null 2>&1
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg > /dev/null 2>&1
            apt purge wget --autoremove -y
            install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        fi
        apt-get update > /dev/null 2>&1; apt-get install -y "${dsPkgs}" > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupLatestNvidiaDrivers() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        lndPkgs="nvidia-driver nvidia-settings nvidia-opencl-icd"
        else
            . "${configDir}/pkgs.conf"
    fi
    echo "${nvidiaLatestDriversWarning}"
    while true; do
    read -p "${warningPrompt}" lndInstallationWarningAccepted
        if [ -z "${lndInstallationWarningAccepted}" ]; then
            lndInstallationWarningAccepted="no"
        elif [ "${lndInstallationWarningAccepted}" = "N" ]; then
            lndInstallationWarningAccepted="no"
        elif [ "${lndInstallationWarningAccepted}" = "n" ]; then
            lndInstallationWarningAccepted="no"
        elif [ "${lndInstallationWarningAccepted}" = "Y" ]; then
            lndInstallationWarningAccepted="yes"
        elif [ "${lndInstallationWarningAccepted}" = "y" ]; then
            lndInstallationWarningAccepted="yes"
        fi
        break
    done
    read -p "${warningPrompt}" lndInstallationWarningAccepted
    if [ "${lndInstallationWarningAccepted}" = "yes" ]; then
        echo ""; echo "${installingLatestNvidiaDrivers}"; echo ""
        apt-get install -y ${lndPkgs} > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

setupOpenSourceDrivers() {
    if [ ! -f "${configDir}/pkgs.conf" ]; then
        osdPkgs="libgl1-mesa-dri:i386 mesa-vulkan-drivers:i386 libglu1 libglu1:i386 libegl-mesa0 libgbm1 libgl1-mesa-dri {libglapi,libglu1}-mesa libglx-mesa0 libosmesa6 mesa-{utils,va-drivers,vdpau-drivers,vulkan-drivers} xserver-xorg-video-nouveau"
        else
            . "${configDir}/pkgs.conf"
    fi
  
    echo "${openSourceDriversWarning}"
    read -p "${warningPrompt}" osdInstallationWarningAccepted
    if [ -z "${osdInstallationWarningAccepted}" ]; then
        osdInstallationWarningAccepted="no"
    elif "${osdInstallationWarningAccepted}" = "N" ]; then
        osdInstallationWarningAccepted="no"
    elif "${osdInstallationWarningAccepted}" = "n" ]; then
        osdInstallationWarningAccepted="no"
    elif "${osdInstallationWarningAccepted}" = "Y" ]; then
        osdInstallationWarningAccepted="yes"
    elif "${osdInstallationWarningAccepted}" = "y" ]; then
        osdInstallationWarningAccepted="yes"
    fi
        break
    if [ "${osdInstallationWarningAccepted}" = "yes" ]; then
        echo ""; echo "${installingOpenSourceDrivers}"; echo ""
        apt-get install -y "${osdPkgs}" > /dev/null 2>&1
        else
            echo "${warningPromptDisagrement}"; echo ""
    fi
}

systemReadiness() {
    echo "${systemSettings_systemReadiness_checkingForUpdates}"
    apt-get update -y &> /dev/null
    apt-get upgrade -y &> /dev/null
    echo "${systemSettings_systemReadiness_generatingAptSourcesList}"
    cp /etc/apt/sources.list /etc/apt/sources.list.backup
    if [ "${repository}" = "free" ]; then
        printf '#\n# DEBIAN REPOSITORIES\n#\ndeb http://deb.debian.org/debian/ buster main\ndeb-src http://deb.debian.org/debian/ buster main\ndeb http://security.debian.org/debian-security buster/updates main\ndeb-src http://security.debian.org/debian-security buster/updates main\ndeb http://deb.debian.org/debian/ buster-updates main\ndeb-src http://deb.debian.org/debian/ buster-updates main\ndeb http://deb.debian.org/debian/ buster-backports main\ndeb-src http://deb.debian.org/debian/ buster-backports main' > /etc/apt/sources.list
    elif [ "${repository}" = "nonfree" ]; then
        printf '#\n# DEBIAN REPOSITORIES\n#\ndeb http://deb.debian.org/debian/ buster main contrib nonfree\ndeb-src http://deb.debian.org/debian/ buster main contrib nonfree\ndeb http://security.debian.org/debian-security buster/updates main contrib nonfree\ndeb-src http://security.debian.org/debian-security buster/updates main contrib nonfree\ndeb http://deb.debian.org/debian/ buster-updates main contrib nonfree\ndeb-src http://deb.debian.org/debian/ buster-updates main contrib nonfree\ndeb http://deb.debian.org/debian/ buster-backports main contrib nonfree\ndeb-src http://deb.debian.org/debian/ buster-backports main contrib nonfree' > /etc/apt/sources.list
    fi
}

setupSwapFile() {
    read -p "${systemSettings_createSwapFile_fileSize}" createSwapFile_size
    dd if=/dev/zero of=/swapfile bs=1M count=${createSwapFile_size} > /dev/null 2>&1
    chmod 0600 /swapfile
    sudo mkswap -L swap /swapfile > /dev/null 2>&1
    sudo swapon /swapfile > /dev/null 2>&1
    echo "/swapfile swap swap sw 0 0" >> /etc/fstab
}

setupDebianFixes() {
    echo "${systemSettings_applyDebianFixes_pleaseWait}"
    sed -e 11's/.*/# &//' /etc/network/interfaces; sed -e 12's/.*/# &//' /etc/network/interfaces
    systemctl restart NetworkManager
    printf 'options bluetooth disable_ertm=1\n' > /etc/modprobe.d/bluetooth.conf
    sed -i 's/; flat-volumes = yes/flat-volumes = no/g' /etc/pulse/daemon.conf
    pulseaudio --kill; pulseaudio --start
    printf 'snd_hda_intel enable_msi=1\n' /etc/modprobe.d/snd_hda_intel.conf
}

setupVirtualization() {
     curl -sL https://git.io/JUbV9 > grub-vfiocfg; sh grub-vfiocfg
}

# Initialize the script functions in this order, according to the user choices
welcome
root
if [ "${installDesktopEnviroment}" = "no" ]; then
    echo "${notInstallingDesktopEnviroment}"
elif [ "${installDesktopEnviroment}" = "yes" ]; then
        setupDesktopEnviroment
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installBasicSystemTools}" = "no" ]; then
    echo "${notInstallingBasicSystemTools}"
elif [ "${installBasicSystemTools}" = "yes" ]; then
        setupBasicSystemTools
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installBasicTools}" = "no" ]; then
    echo "${notInstallingBasicTools}"
elif [ "${installBasicTools}" = "yes" ]; then
        setupBasicTools
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installWebBrowser}" = "no" ]; then
    echo "${notInstallingWebBrowser}"
elif [ "${installWebBrowser}" = "yes" ]; then
        setupWebBrowser
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installOfficeSuite}" = "no" ]; then
    echo "${notInstallingOfficeSuite}"
elif [ "${installOfficeSuite}" = "yes" ]; then
        setupOfficeSuite
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installGamingSoftware}" = "no" ]; then
    echo "${notInstallingGamingSoftware}"
elif [ "${installGamingSoftware}" = "yes" ]; then
        setupGamingSoftware
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installMultimediaSoftware}" = "no" ]; then
    echo "${notInstallingMultimediaSoftware}"
elif [ "${installMultimediaSoftware}" = "yes" ]; then
        setupMultimediaSoftware
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installDeveloperSoftware}" = "no" ]; then
    echo "${notInstallingDeveloperSoftware}"
elif [ "${installDeveloperSoftware}" = "yes" ]; then
        setupDeveloperSoftware
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installLatestNvidiaDrivers}" = "no" ]; then
    echo "${notInstallingLatestNvidiaDrivers}"
elif [ "${installLatestNvidiaDrivers}" = "yes" ]; then
        setupLatestNvidiaDrivers
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${installOpenSourceDrivers}" = "no" ]; then
    echo "${notInstallingOpenSourceDrivers}"
elif [ "${installOpenSourceDrivers}" = "yes" ]; then
        setupOpenSourceDrivers
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${repository}" = "nonfree" ]; then
    if [ "${runSystemReadiness}" = "no" ]; then
        echo "${notRunningSystemReadiness}"
    elif [ "${runSystemReadiness}" = "yes" ]; then
            systemReadiness
        else
            echo "${invalidConfig}"
            exit 2
    fi
fi
if [ "${createSwapFile}" = "no" ]; then
    echo "${notCreatingSwapFile}"
elif [ "${createSwapFile}" = "yes" ]; then
        setupSwapFile
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ ${applyDebianFixes} = "no" ]; then
    echo "${notApplyingDebianFixes}"
elif [ ${applyDebianFixes} = "yes" ]; then
        setupDebianFixes
    else
        echo "${invalidConfig}"
        exit 2
fi
if [ "${configureVirtualization}" = "no" ]; then
    echo "${notSettingUpVirtualization}"
elif [ "${configureVirtualization}" = "yes" ]; then
        setupVirtualization
    else
        echo "${invalidConfig}"
        exit 2
fi
