#!/usr/bin/env bash

KBD_IMG="$HOME/.config/img/keyboard.png"
KBD_FILE="$HOME/.kbd-switch"
true >> $KBD_FILE
LAYOUT=$(head -1 $KBD_FILE)

notif-change-layout () {
	LAYOUT_NAME=$1
	NEW_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
	echo "$CURRENT_LAYOUT → $NEW_LAYOUT ($LAYOUT_NAME)"
	notify-send "$LAYOUT_NAME" --expire-time=1000 --icon=$KBD_IMG --category="Layout"
}

case $LAYOUT in
	"fr(bepo)")
		setxkbmap fr -option
		echo "fr" > $KBD_FILE
		NOTIF="AZERTY"
		;;
	*)
		setxkbmap fr bepo -option ctrl:nocaps compose:paus
		echo "fr(bepo)" > $KBD_FILE
		NOTIF="BÉPO"
		;;
esac

# TypeMatrix → toujours en bépo sans options
for id in $(xinput list | grep -i "typematrix" | cut -d= -f2 | cut -f1); do
	setxkbmap -layout 'fr(bepo)' -device "$id" -option 2> /dev/null
	TYPEMATRIX="true"
done
if [ -n "$TYPEMATRIX" ] && [ ! "BÉPO" == "$NOTIF" ];
then
	NOTIF="TM:BÉPO, $NOTIF"
fi



# Ergodox → toujours en bépo sans options
for id in $(xinput list | grep -i "ergodox" | cut -d= -f2 | cut -f1); do
	setxkbmap -layout 'fr(bepo)' -device "$id" -option 2> /dev/null
	ERGODOX="true"
done
if [ -n "$ERGODOX" ] && [ ! "BÉPO" == "$NOTIF" ];
then
	NOTIF="EZ:BÉPO, $NOTIF"
fi

notif-change-layout "$NOTIF"

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# llkk
# llk

# EOF
