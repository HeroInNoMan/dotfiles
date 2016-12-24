#!/bin/sh

# script utilisé dans ~/.config/openbox/lubuntu-rc.xml pour gérer le rétro-éclairage.

LIGHT_UP_IMG="$HOME/.config/img/light_up.png"
LIGHT_DOWN_IMG="$HOME/.config/img/light_down.png"
BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"

light_up () {
    xbacklight -inc 30
    [ $? != 0 ] && echo $(($(cat $BRIGHTNESS_FILE) + 100)) > $BRIGHTNESS_FILE
}

light_down () {
    xbacklight -dec 30
    [ $? != 0 ] && echo $(($(cat $BRIGHTNESS_FILE) - 100)) > $BRIGHTNESS_FILE
}

case $1 in
    "up") light_up ;;
    "down") light_down ;;
    *) echo "Usage: $0 up|down" ;;
esac

# EOF
