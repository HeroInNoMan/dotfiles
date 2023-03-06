#!/usr/bin/env bash

# "bepo 1.0" == "bepo"
# "bepo 1.1" == "bepo_afnor"
BEPO_VERSION="bepo_afnor"

KBD_IMG="$HOME/.config/img/keyboard.png"
KBD_FILE="$HOME/.kbd-switch"
true >> "$KBD_FILE"
LAYOUT=$(head -1 "$KBD_FILE")

notif-change-layout () {
  LAYOUT_NAME=$1
  NEW_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
  echo "$CURRENT_LAYOUT → $NEW_LAYOUT ($LAYOUT_NAME)"
  notify-send "$LAYOUT_NAME" --expire-time=1000 --icon="$KBD_IMG" --category="Layout"
}

setup_typematrix () {
  # TypeMatrix → toujours en bépo sans options
  for id in $(xinput list | grep -i "typematrix" | cut -d= -f2 | cut -f1); do
    setxkbmap fr $BEPO_VERSION -device "$id" -option 2> /dev/null
    TYPEMATRIX="true"
  done
  if [ -n "$TYPEMATRIX" ] && [ ! "BÉPO" == "$NOTIF" ];
  then
    NOTIF="TM:BÉPO, $NOTIF"
  fi
}

setup_ergodox () {
  # Ergodox → toujours en bépo sans options
  for id in $(xinput list | grep -i "ergodox" | cut -d= -f2 | cut -f1); do
    setxkbmap fr $BEPO_VERSION -device "$id" -option 2> /dev/null
    ERGODOX="true"
  done
  if [ -n "$ERGODOX" ] && [ ! "BÉPO" == "$NOTIF" ];
  then
    NOTIF="EZ:BÉPO, $NOTIF"
  fi
}

setup_default () {
  case $LAYOUT in
    "fr(bepo)")
      setxkbmap fr -option
      echo "fr" > "$KBD_FILE"
      NOTIF="AZERTY"
      ;;
    *)
      setxkbmap fr $BEPO_VERSION -option ctrl:nocaps compose:prsc
      echo "fr(bepo)" > "$KBD_FILE"
      NOTIF="BÉPO"
      ;;
  esac
}

main () {
  setup_default
  setup_typematrix
  setup_ergodox
  notif-change-layout "$NOTIF"
  [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
}

main
# llkk
# llk

# EOF
