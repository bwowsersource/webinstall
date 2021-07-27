#!/bin/bash

result_url=$(curl $inputLink -s -L -I -o /dev/null -w '%{url_effective}')

echo "reading... $result_url"

APP_ID=$([[ $result_url =~ ^https?:\/\/([^\/]*).*$ ]] && echo ${BASH_REMATCH[1]})
if ! [[ $result_url =~ ^https:\/\/ ]]; then
    echo "NOT SECURE!!"
    exit 1 # not https
fi

URL="https://${APP_ID}"


TITLE=$(curl -sL ${URL} | perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si')

DOMAIN=$([[ $APP_ID =~ ^(.*\.)?([^\.]+\.[^\.]+)$ ]] && echo ${BASH_REMATCH[2]})

TITLE="$TITLE | $DOMAIN"
echo "App title: $TITLE"
APP_PATH=$ASSETS_DIR/$DOMAIN
ICON=$APP_PATH/$APP_ID-icon.ico
DESKTOP_FILE=${APP_PATH}/$APP_ID-launcher.desktop
TEMPLATE=${ROOT}/${CNF_TEMPLATE}

rm -rf $APP_PATH
mkdir $APP_PATH
curl -s ${URL}/favicon.ico --output ${ICON}

# Load templates
# OS template
if [ ! -z $CNF_OS_TEMPLATE ]; then
    { #try
        source "$ROOT/platforms/$CNF_OS_TEMPLATE/$TEMPLATE_INSTALL_SCRIPT"
    } || { #catch
        echo "Failed to load templates for $CNF_OS_TEMPLATE"
    }
fi

# Browser template
if [ ! -z $CNF_BROWSER_TEMPLATE ]; then
    { #try
        source "$ROOT/activators/$CNF_BROWSER_TEMPLATE/$TEMPLATE_INSTALL_SCRIPT"
    } || { #catch
        echo "Failed to load templates for $CNF_BROWSER_TEMPLATE"
    }
fi



EXEC="${CNF_EXEC}${URL}"
echo "Installing $APP_ID"
echo "launch command: $EXEC"

# seed desktop file template and save to install folder
while read line; do
    while [[ "$line" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]]; do
        LHS=${BASH_REMATCH[1]}
        RHS="$(eval echo "\"$LHS\"")"
        line=${line//$LHS/$RHS}
    done
    echo "$line" >>${DESKTOP_FILE}
done <$TEMPLATE

chmod +x ${DESKTOP_FILE}
desktop_dest=$(eval "readlink -f ${CNF_DESKTOP_DEST}")

echo "Adding desktop file to ${desktop_dest}"

# ls "${desktop_dest}/"
cp ${DESKTOP_FILE} ${desktop_dest}/${APP_ID}.desktop
