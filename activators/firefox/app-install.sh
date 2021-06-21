#!/bin/bash

PROFILE_NAME=$([[ -z $PROFILE_NAME ]] && echo $DOMAIN || echo $PROFILE_NAME)
# echo $APP_PATH/firefox_profile.profile
# ls $APP_PATH
PROFILE_PATH=$APP_PATH/firefox_profile.profile/
mkdir $PROFILE_PATH
firefox -no-remote -CreateProfile "$PROFILE_NAME"
# firefox -no-remote -CreateProfile "$PROFILE_NAME $PROFILE_PATH"
CNF_EXEC="firefox -P $PROFILE_NAME "