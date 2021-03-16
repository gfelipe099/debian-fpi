#!/bin/sh

#
# Debian GUI-Installer script
# Created and developed by Liam Powell (gfelipe099)
# debian-guii file
# For Debian GNU/Linux 10 (buster) amd64
#

# set script parameters
language="${1}"
desktopEnvToInstall="${2}"

if [ -z ${language} ] || [ -z ${desktopEnvToInstall} ]; then
    echo "Missing required argument: [language] and/or [desktopEnvToInstall]"
    echo "You must specify which language to use and what DE to install." && echo "" && echo ""
    echo "Usage: debian-fpi [language] [desktopEnviroment]" && echo ""
    echo "Options:"
    echo "  Language:"
    echo "    en"
    echo "    es"
    echo "    fr" && echo ""
    echo "  Desktop enviroments available:"
    echo "    gnome"
    echo "    kde"
    echo "    xfce" && echo ""
    echo "Example: sh debian-fpi.sh en xfce" && echo ""
    exit 1
fi

# set language variables
if [ ${language} = "en" ]; then
    pleaseWait="Please wait..."
    mustExecAsRoot="This script must be executed as root"
    PkgManagerNotFound="APT Package Manager was not found in this system, execution aborted."
    NotUsingDebian="You must be using Debian GNU/Linux 10 (buster) to execute this script."
    welcomeToDebianGuii="Welcome to the Debian GUI-Installer tool or Debian-GUII (utility from Debian-FPI)"
    createdBy="Created by Liam Powell (gfelipe099)"
    kernelVersion="Kernel version in use:"
    startPrompt="--> Do you want to start the script?: (Default: no): "
    useDesktopEnviroment="Will you use a desktop enviroment? (Default: no): "
    desktopEnv="--> Desktop Enviroment"
    desktopEnvPrompt="Which desktop enviroment do you want to use? (Default: gnome): "
    unknownDesktopEnv="Sorry the desktop enviroment you chose is not available or it is not known yet by the script, please change your configuration file parameters and try again."
    installingDesktopEnv="Installing "${2}" minimal desktop enviroment..."
elif [ ${language} = "es" ]; then
    pleaseWait="Por favor, espera..."
    mustExecAsRoot="Este script debe ser ejecutado como root"
    PkgManagerNotFound="El administrador de paquetes APT no fue encontrado en este sistema, ejecución abortada."
    NotUsingDebian="Debes estar usando Debian GNU/Linux 10 (buster) para ejecutar este script."
    welcomeToDebianGuii="¡Bienvenido a la herramienta instaladora de la GUI o Debian-GUII (utilidad de Debian-FPI)"
    createdBy="Creado por Liam Powell (gfelipe099)"
    kernelVersion="Versión del núcleo en uso:"
    startPrompt="--> Presiona cualquier tecla para empezar... (Por defecto: no): "
    useDesktopEnviroment="¿Usarás in entorno de escritorio? (Por defecto: no): "
    desktopEnv="--> Entorno de escritorio"
    desktopEnvPrompt="¿Qué entorno de escritorio quieres usar? (Por defecto: gnome): "
    unknownDesktopEnv="Lo siento, el entorno de escritorio que has elegido no está disponible o no es conocido aún por el script, por favor, cambia los parámetros de tu archivo de configuración e inténtalo de nuevo."
    installingDesktopEnv="Instalando el entorno de escritorio mínimo de "${2}"..."
    else
        echo "ERROR: "${language}": Unknown language or not implemented yet"
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
        apt-get install -yy lsb-release > /dev/null 2>&1
        os=$(lsb_release -ds | sed 's/"//g')
fi
if [ "${os}" != "Debian GNU/Linux 10 (buster)" ]; then
    echo "${NotUsingDebian}"
    exit 2
fi

welcome() {
    clear
    echo "${pleaseWait}"
    apt-get install -yy figlet > /dev/null 2>&1
    clear
    figlet -c "Debian"
    figlet -c "GUII"
    apt-get purge -yy figlet --autoremove > /dev/null 2>&1
    echo "${welcomeToDebianGuii}"
    echo "${createdBy}"
    echo "${kernelVersion} $(uname -r)"
}

root() {
    read -p "${startPrompt}" input
        if [ -z ${input} ]; then
            exit 0
        elif [ ${input} = "no" ]; then
            exit 0
        fi && echo "" && echo ""
}

setupDesktopEnviroment() {
    echo "${installingDesktopEnv}"
    if [ ${desktopEnvToInstall} = "gnome" ]; then
        echo "apt-get install -yy gdm3* > /dev/null 2>&1" && echo ""
    elif [ ${desktopEnvToInstall} = "kde" ]; then
        apt-get install -yy sddm* > /dev/null 2>&1 && apt-get purge -yy discover plasma-discover kinfocenter xterm --autoremove > /dev/null 2>&1 && echo ""
    elif [ ${desktopEnvToInstall} = "xfce" ]; then
        apt-get install -yy xfce4 > /dev/null 2>&1 && echo ""
        else
            echo "${unknownDesktopEnv}"
            exit 1
    fi
}

# Initialize script functions in this order
welcome
root
setupDesktopEnviroment
