#!/bin/sh

# script utilisé dans ~/.config/openbox/lubuntu-rc.xml pour gérer le son.

SOUND_UP_IMG="$HOME/.config/img/sound_up.png"
SOUND_DOWN_IMG="$HOME/.config/img/sound_down.png"
MUTE_IMG="$HOME/.config/img/mute.png"
UNMUTE_IMG="$HOME/.config/img/unmute.png"

SINK_NAME=$(pacmd dump | grep -m 1 -o "alsa.*stereo")
SINKS=$(pacmd dump | grep -o "alsa_output.*stereo" | sort | uniq)
MUTE_STATE=$(pacmd dump | grep -P "^set-sink-mute $SINK_NAME\s+" | perl -p -e 's/.+\s(yes|no)$/$1/')

toggle_mute () {
    case $MUTE_STATE in
        "yes")
            for sink in $SINKS; do
                pactl set-sink-mute "$sink" 0
            done
            [ $? -eq 0 ] && notify-send "ON" --expire-time=1000 --icon="$UNMUTE_IMG" --urgency=NORMAL
            ;;
        "no")
            for sink in $SINKS; do
                pactl set-sink-mute "$sink" 1
            done
            [ $? -eq 0 ] && notify-send "OFF" --expire-time=1000 --icon="$MUTE_IMG" --urgency=NORMAL
            ;;
    esac
}

sound_up () {
    amixer -q sset Master 3%+ unmute
    [ $? != 0 ] &&
        for sink in $SINKS; do
            pactl set-sink-volume "$sink" +5%
        done
    [ $? -eq 0 ] && notify-send " " --expire-time=120 --icon="$SOUND_UP_IMG" --urgency=NORMAL
}

sound_down () {
    amixer -q sset Master 3%- unmute
    [ $? != 0 ] &&
        for sink in $SINKS; do
            pactl set-sink-volume "$sink" -5%
        done
    [ $? -eq 0 ] && notify-send " " --expire-time=120 --icon="$SOUND_DOWN_IMG" --urgency=NORMAL
}

case $1 in
    # killall notify-osd # notify-send ne prend plus en compte l’option -t
    "toggle") toggle_mute ;;
    "up") sound_up ;;
    "down") sound_down ;;
    *) echo "Usage: $0 toggle|up|down" ;;
esac

# EOF
