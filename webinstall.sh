#!/bin/bash


ROOT=$(pwd)
source $ROOT/config
ASSETS_DIR=${ROOT}/installed-assets
result_url=$(curl $1 -s -L -I -o /dev/null -w '%{url_effective}') 

echo $result_url

APP_ID=$([[ $result_url =~ ^https?:\/\/([^\/]*).*$ ]] && echo ${BASH_REMATCH[1]})
if ! [[ $result_url =~ ^https:\/\/ ]];
    then 
    echo "NOT SECURE!!";
    exit 1; # not https
fi

URL="https://${APP_ID}"

EXEC="${CNF_EXEC} ${URL}"
echo $APP_ID;

# TITLE=$(curl -sL ${URL} | perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si')

TITLE=$( [[ $APP_ID =~ ^.*\.([^\.]+\.[^\.]+)$ ]] && echo ${BASH_REMATCH[1]} )

echo $TITLE
APP_PATH=$ASSETS_DIR/$APP_ID
ICON=$APP_PATH/icon.ico
DESKTOP_FILE=${APP_PATH}/launcher.desktop
TEMPLATE=${ROOT}/${CNF_TEMPLATE}

rm -rf $APP_PATH
mkdir $APP_PATH
curl -s ${URL}/favicon.ico --output ${ICON}


while read line ; do
    while [[ "$line" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]] ; do
        LHS=${BASH_REMATCH[1]}
        RHS="$(eval echo "\"$LHS\"")"
        line=${line//$LHS/$RHS}
    done
    echo "$line" >> ${DESKTOP_FILE}
done < $TEMPLATE

chmod +x ${DESKTOP_FILE}
desktop_dest=$(eval "readlink -f ${CNF_DESKTOP_DEST}")

echo "Installing to ${desktop_dest}"

# ls "${desktop_dest}/"
cp ${DESKTOP_FILE} ${desktop_dest}/${APP_ID}.desktop
