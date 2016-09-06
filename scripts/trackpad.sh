#!/bin/sh

TRACKPAD_IMG="$HOME/.config/img/trackpad.png"

MAX_TAP_TIME=$(synclient -l | grep --regexp='MaxTapTime' | cut --delimiter='=' --fields=2 | tr --delete '[:blank:]')

if [ "$MAX_TAP_TIME" -gt 0 ]; then
    synclient MaxTapTime=0
    notify-send "OFF" --expire-time=500 --icon="$TRACKPAD_IMG" --urgency=NORMAL
else
    synclient MaxTapTime=100
    notify-send "ON" --expire-time=500 --icon="$TRACKPAD_IMG" --urgency=NORMAL
fi

# enable vertical & horizontal scrolling on edge or with two fingers
synclient VertEdgeScroll=1
synclient VertTwoFingerScroll=1
synclient HorizEdgeScroll=1
synclient HorizTwoFingerScroll=1

# EOF
