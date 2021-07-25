#!/bin/bash

#base values
ROOT=$(pwd) #"$(dirname "$0")"
echo ROOT $ROOT
TEMPLATE_INSTALL_SCRIPT="app-install.sh"
PROFILE_NAME=$3

source $ROOT/config

# create assets folder if not existing
ASSETS_DIR=${ROOT}/installed-assets
mkdir -p $ASSETS_DIR

if [ $1 == "--help" ] || [ $1 == "-h" ]; then
    printf "\n"
    printf "webinstall [option -i,-l,-u,-h] [url/appIp] [container]\n"
    printf "\n"
    printf "[-i/--install]   [url/domain]  --> installs web app\n"
    printf "[-u/--uninstall] [url/domain]  --> uninstall\n"
    printf "[-l/--launch]    [url/domain]  --> launch the app\n"
    printf "[-a/--all]       []            --> list all installed apps\n"
else

    if [ $1 == "--install" ] || [ $1 == "-i" ]; then
        inputLink=$2
        source $ROOT/-install.sh
    elif [ $1 == "--uninstall" ] || [ $1 == "-u" ]; then
        echo "uninstall work incomplete..."
    elif [ $1 == "--launch" ] || [ $1 == "-l" ]; then
        source $ROOT/-launch.sh
    elif [ $1 == "--all" ] || [ $1 == "-a" ]; then
        ls -1 $ROOT/installed-assets
    else
        # TODO: check if already installed, launch if it exists
        # default to install
        inputLink=$1
        source $ROOT/-install.sh

        # Launch -
        source $ROOT/-launch.sh
    fi
fi
