#!/usr/bin/env bash

# load variables and output error if they are not defined #####################
[[ -e "$HOME/.localrc" ]] && source "$HOME/.localrc"
[[ -z $GRAB_URL ]] && notify-send "⚠ Grab URL not defined!"
[[ -z $GRAB_REMOTE_DIR ]] && notify-send "⚠ Grab remote dir not defined!"

# pick latest screenshot (grab) in $HOME directory ############################
SOURCE_FILE_NAME=$(ls -t1 $HOME/*_scrot.png | head -1)
GRAB_NAME=${1:-$(basename "${SOURCE_FILE_NAME%.png}")}.png

URL="$GRAB_URL/$GRAB_NAME"
DEST_NAME="$GRAB_REMOTE_DIR/$GRAB_NAME"

# copy file to server #########################################################
scp "$SOURCE_FILE_NAME" "$DEST_NAME"

# copy URL to clipboard #######################################################
echo "$URL" | xclip -r
echo "$URL" | xclip -r -selection clipboard

# open URL in firefox #########################################################
firefox -new-tab "$URL"

# notify ######################################################################
notify-send "Copied: $URL" --expire-time=2000
#EOF
