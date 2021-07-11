#!/bin/bash

#base values
ROOT=$(pwd)  #"$(dirname "$0")"
echo ROOT $ROOT
TEMPLATE_INSTALL_SCRIPT="app-install.sh"
PROFILE_NAME=$3

source $ROOT/config

# create assets folder if not existing
ASSETS_DIR=${ROOT}/installed-assets
mkdir -p $ASSETS_DIR


if [ $1 == "--help" ] || [ $1 == "-h" ]; then
    echo "webinstall [option -i,-h,-u] [url/appIp] [container]"
    exit 0
fi

if [ $1 == "--install" ] || [ $1 == "-i" ]; then
    inputLink=$2
    source $ROOT/-install.sh
elif [ $1 == "--uninstall" ] || [ $1 == "-u" ]; then
    echo "uninstall work incomplete"
else
    # default to install
    inputLink=$1
    source $ROOT/-install.sh
fi
