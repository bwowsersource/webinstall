#!/bin/bash

# if creating unique profile for each domain
PROFILE_NAME=$([[ -z $PROFILE_NAME ]] && echo $DOMAIN || echo $PROFILE_NAME)

# echo $APP_PATH/firefox_profile.profile
# ls $APP_PATH


# PROFILE_PATH=$APP_PATH/firefox_profile.profile/
# mkdir $PROFILE_PATH
# firefox -no-remote -CreateProfile "$PROFILE_NAME $PROFILE_PATH"
firefox -no-remote -CreateProfile "$PROFILE_NAME" # creates in default path
CNF_EXEC="firefox -P $PROFILE_NAME "

# Find profile path - look in default locatione
DEFAULT_PROFILE_PATH=~/.mozilla/firefox/
PROFILES_INI=${DEFAULT_PROFILE_PATH}/profiles.ini
if [ -f "$PROFILES_INI" ]; then
    echo "$FILE exists."
    PROFILE_PATH=$DEFAULT_PROFILE_PATH$(awk -F "=" '/Path/ {print $2}' $PROFILES_INI | grep $PROFILE_NAME)
fi

# save profile path in install directory
echo "# use 'source $APP_PATH/profile_path.sh'" > $APP_PATH/profile_path.sh
echo "PROFILE_PATH=${PROFILE_PATH}" >> $APP_PATH/profile_path.sh

# apply modifications

# - create user.js file
echo "// about:config customizations" > $PROFILE_PATH/user.js

# - always open in same tab
echo "user_pref(\"browser.link.open_newwindow.restriction\", 0);" >> $PROFILE_PATH/user.js
echo "user_pref(\"browser.link.open_newwindow\", 1);" >> $PROFILE_PATH/user.js

# - enable custom chrome css
echo "user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true);" >> $PROFILE_PATH/user.js

# - create css file
mkdir $PROFILE_PATH/chrome
cp ${ROOT}/activators/firefox/userChrome.css $PROFILE_PATH/chrome/userChrome.css