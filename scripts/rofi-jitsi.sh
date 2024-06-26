#!/usr/bin/env bash

# common init params ##########################################################
[[ -e "$HOME/.localrc" ]] && source "$HOME/.localrc"
[ $JITSI_PREFIX ] || JITSI_PREFIX="https://jitsi.org"

JITSI_VISIO_LIST="/home/$USER/.jitsi_visio_list"
if [ ! -e $JITSI_VISIO_LIST ]; then
  echo "room101" > $JITSI_VISIO_LIST
fi

# create a list for rofi to consume ###########################################
gen_list(){
  while read -r line; do
    echo -e "$line"
  done <"$JITSI_VISIO_LIST"
}

main() {
  visio=$( (gen_list) | rofi -i -theme ale-run.rasi -dmenu -p "Visio > " | xargs)
  while read -r line; do
    if [[ $line == $visio || -z $(grep "$visio" "$JITSI_VISIO_LIST") ]]; then
      echo "$visio" >> $JITSI_VISIO_LIST
      sort -u $JITSI_VISIO_LIST -o $JITSI_VISIO_LIST
      /usr/bin/google-chrome-stable --new-window %U --app="$JITSI_PREFIX/$visio"
      exit 0
    fi
  done <"$JITSI_VISIO_LIST"
}

main
