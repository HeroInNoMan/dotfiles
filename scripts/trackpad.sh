#!/bin/sh

TRACKPAD_IMG="$HOME/.config/img/trackpad.png"

MAX_TAP_TIME=$(/usr/bin/synclient -l | grep --regexp='MaxTapTime' | cut --delimiter='=' --fields=2 | tr --delete '[:blank:]')

if [ "$MAX_TAP_TIME" -gt 0 ]; then
    /usr/bin/synclient MaxTapTime=0
    notify-send "OFF" --expire-time=500 --icon="$TRACKPAD_IMG" --urgency=NORMAL
else
    /usr/bin/synclient MaxTapTime=100
    notify-send "ON" --expire-time=500 --icon="$TRACKPAD_IMG" --urgency=NORMAL
fi

# enable vertical & horizontal scrolling on edge or with two fingers
/usr/bin/synclient VertEdgeScroll=1
/usr/bin/synclient VertTwoFingerScroll=1
/usr/bin/synclient HorizEdgeScroll=1
/usr/bin/synclient HorizTwoFingerScroll=1

# EOF
