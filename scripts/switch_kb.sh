#!/bin/bash

KBD_IMG="$HOME/.config/img/keyboard.png"

TM_LABEL="TypeMatrix.com USB Keyboard"
EZ_LABEL="TypeMatrix.com USB Keyboard"
DEVICE_LABEL=$(xinput list --name-only | grep --ignore-case "keyboard" | grep --ignore-case --invert-match "virtual" --max-count=1)

CURRENT_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')

notif-change-layout () {
    LAYOUT_NAME=$1
    NEW_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
    echo "$CURRENT_LAYOUT -> $NEW_LAYOUT ($LAYOUT_NAME)"
    notify-send "→ $LAYOUT_NAME" --expire-time=500 --icon=$KBD_IMG --urgency=CRITICAL
}

change-layout() {
    if [ $# -ne 0 ]; then
        $(setxkbmap "$@")
        LAYOUT=$(setxkbmap -print | awk -F"(" '/xkb_keycodes/ {print $2}' | awk -F")" '{print toupper($1)}')
        notif-change-layout $LAYOUT
        return
    fi
    case $CURRENT_LAYOUT in
        "fr(bepo)"|"fr bepo")
            $(setxkbmap fr -option)
            notif-change-layout "AZERTY" ;;
        *)  # switch vers bépo
            NB_KBD=$(xinput list --name-only | grep --ignore-case "keyboard" | grep --ignore-case --invert-match "virtual" | sort | uniq | wc --lines)

            ID_LIST=$(xinput list | grep "${DEVICE_LABEL}.*keyboard" | cut --delimiter== --fields=2 | cut --fields=1)

            OPTION=$([[ $TM_LABEL != $DEVICE_LABEL ]] && echo 'ctrl:nocaps')

            if [[ $NB_KBD == 1 ]]; then # only one keyboard
                $(setxkbmap -layout 'fr(bepo)' -option $OPTION)
                notif-change-layout "BÉPO"
                return
            else # more than one keyboard
                $(setxkbmap -layout 'fr' -option) # all keyboards in azerty
                for id in $ID_LIST; do # selected keyboards in bépo
                    $(setxkbmap -layout 'fr(bepo)' -device $id -option $OPTION)
                done
                notif-change-layout "BÉPO / AZERTY"
            fi
            ;;
    esac
}

if [ -z $@ ]; then
    change-layout
else
    case $1 in
        "bepo")
            setxkbmap fr bepo -option ctrl:nocaps
            notif-change-layout "BÉPO" ;;
        *)
            setxkbmap $@
            notif-change-layout "$1" ;;
    esac
fi

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# llkk
# llk

# EOF
