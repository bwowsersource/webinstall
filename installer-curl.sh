# Find bashrc path - look in default location

# declare -a DEFAULT_PATHS=("." "~/.bashrc") # is an array
DEFAULT_INSTALL_PATH=$(pwd)
WEBINSTALL_RC_FILE_NAME=".webinstallrc"

# echo  ${DEFAULT_PATHS[1]}
# for i in "${DEFAULT_PATHS[@]}"; do
# echo $i
#         PATH_TO_FILE=$(realpath $i);

#     if [ -f "$i" ]; then
#         echo "$i exists."
#     fi
# done

PATH_TO_FILE=~/.bashrc
if [ -f $PATH_TO_FILE ]; then
    echo "$PATH_TO_FILE exists."
    DIR_OF_PATH_TO_FILE=$(dirname $PATH_TO_FILE)
    
    # install .webinstallrc file
    RC_PATH=$DIR_OF_PATH_TO_FILE/$WEBINSTALL_RC_FILE_NAME
    # write to file
    echo "alias webinstall=\"sh $DEFAULT_INSTALL_PATH/webinstall.sh\"" > $RC_PATH
    SOURCE_COMMAND="source $RC_PATH"

    # check if file already has source command
    match=$(cat $PATH_TO_FILE | grep "^${SOURCE_COMMAND}")
    if [ -z "$match" ]; then
        echo $SOURCE_COMMAND >>$PATH_TO_FILE
        echo "installed to $PATH_TO_FILE"
        echo "run \"source $PATH_TO_FILE\" to apply changes immediately"
    else
        echo "$WEBINSTALL_RC_FILE_NAME entry already exist in $PATH_TO_FILE"
    fi
fi
