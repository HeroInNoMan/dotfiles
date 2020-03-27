#!/usr/bin/env bash
KBD_FILE="$HOME/.kbd-switch"
true >> $KBD_FILE
LAYOUT=$(head -1 $KBD_FILE)

case $LAYOUT in
  "fr(bepo)")
    setxkbmap fr -option
    echo "fr" > $KBD_FILE
    ;;
  *)
    setxkbmap fr bepo -option ctrl:nocaps compose:paus
    echo "fr(bepo)" > $KBD_FILE
    ;;
esac

# Ergodox, TypeMatrix → toujours en bépo sans options
for id in $(xinput list | grep -i "\(ergodox\|typematrix\)" | cut -d= -f2 | cut -f1); do
  setxkbmap -layout 'fr(bepo)' -device "$id" -option 2> /dev/null
done

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# llkk
# llk

# EOF
