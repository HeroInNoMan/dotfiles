#!/bin/bash

KBD_IMG="$HOME/.config/img/keyboard.png"
TM_LABEL="TypeMatrix.com USB Keyboard"

CURRENT_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')

notif-change-layout () {
    LAYOUT_NAME=$1
    NEW_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
    echo "$CURRENT_LAYOUT -> $NEW_LAYOUT ($LAYOUT_NAME)"
    notify-send "→ $LAYOUT_NAME" --expire-time=500 --icon=$KBD_IMG --urgency=CRITICAL
}

change-layout() {
    if [ $# -ne 0 ]; then
        setxkbmap "$@"
        LAYOUT=$(setxkbmap -print | awk -F"(" '/xkb_keycodes/ {print $2}' | awk -F")" '{print toupper($1)}')
        notif-change-layout "$LAYOUT"
        return
    fi
    case $CURRENT_LAYOUT in
        "fr(bepo)"|"fr bepo")
            setxkbmap fr -option
            notif-change-layout "AZERTY" ;;
        "fr")
            setxkbmap us -option
            notif-change-layout "QWERTY" ;;
        "us")
            setxkbmap de -option
            notif-change-layout "QWERTZ" ;;
        *)
            # switch vers bépo
            NB_KBD=$(xinput list --name-only | grep --ignore-case "keyboard" | grep --ignore-case --invert-match "virtual" | sort | uniq | wc --lines)
            TM_ID=$(xinput list --id-only keyboard:"$TM_LABEL" 2> /dev/null)

            OPTION=$([[ -z $TM_ID ]] && echo 'ctrl:nocaps')

            # un seul clavier
            if [[ $NB_KBD == 1 ]]; then
                setxkbmap fr bepo -option $OPTION
                notif-change-layout "BÉPO"
                return
            fi
            # plusieurs claviers
            # tous → azerty
            setxkbmap fr -option
            # le premier → bépo
            if [[ $TM_ID ]]; then
                setxkbmap fr bepo -option $OPTION -device $TM_ID
            else
                DEVICE_LABEL=$(xinput list --name-only | grep --ignore-case "keyboard" | grep --ignore-case --invert-match "virtual" --max-count=1)
                DEVICE_ID=$(xinput list --id-only keyboard:"$DEVICE_LABEL")
                setxkbmap fr bepo -option $OPTION -device $DEVICE_ID
            fi
            notif-change-layout "BÉPO / AZERTY"
            ;;
    esac
}

change-layout
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# llkk
# llk

# EOF
