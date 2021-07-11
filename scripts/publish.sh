#!/usr/bin/env bash

# load variables and output an error if they are not defined ##################
[[ -e "$HOME/.localrc" ]] && source "$HOME/.localrc"
[[ -z $GRAB_URL ]] && notify-send "⚠ Grab URL not defined!"
[[ -z $GRAB_REMOTE_DIR ]] && notify-send "⚠ Grab remote dir not defined!"

# pick latest screenshot (grab) in $HOME directory ############################
GRABS_DIR=".old-screenshots"
mkdir -p $HOME/$GRABS_DIR
GRAB_PATTERN="*_scrot.png"
SOURCE_FILE_NAME=$(ls -t1 $HOME/$GRAB_PATTERN | head -1)
GRAB_NAME=${1:-$(basename "${SOURCE_FILE_NAME%.png}")}.png

URL="$GRAB_URL/$GRAB_NAME"
DEST_NAME="$GRAB_REMOTE_DIR/$GRAB_NAME"

# copy file to server #########################################################
scp "$SOURCE_FILE_NAME" "$DEST_NAME" || exit 1;

# copy URL to clipboard #######################################################
echo "$URL" | xclip -r
echo "$URL" | xclip -r -selection clipboard

# open URL in firefox #########################################################
firefox -new-tab "$URL"

# notify ######################################################################
notify-send "Copied: $URL" --expire-time=2000

# clean-up ####################################################################
echo $SOURCE_FILE_NAME
mv $SOURCE_FILE_NAME $HOME/$GRABS_DIR/

#EOF
