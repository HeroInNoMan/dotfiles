#!/bin/bash

KBD_IMG="$HOME/.config/img/keyboard.png"
TM_LABEL="TypeMatrix.com USB Keyboard"

CURRENT_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')

notif-change-layout () {
    LAYOUT_NAME=$1
    NEW_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
    echo "$CURRENT_LAYOUT -> $NEW_LAYOUT ($LAYOUT_NAME)"
    notify-send "→ $LAYOUT_NAME" --expire-time=500 --icon=$KBD_IMG --urgency=NORMAL
}

if [ $# -ne 0 ]
then
    setxkbmap "$@"
    LAYOUT=$(setxkbmap -print | awk -F"(" '/xkb_keycodes/ {print $2}' | awk -F")" '{print toupper($1)}')
    notif-change-layout "$LAYOUT"
else
    case $CURRENT_LAYOUT in
        "fr(bepo)"|"fr bepo")
            setxkbmap fr -option
            notif-change-layout "AZERTY"
            ;;
        "fr")
            setxkbmap us -option
            notif-change-layout "QWERTY"
            ;;
        "us")
            setxkbmap de -option
            notif-change-layout "QWERTZ"
            ;;
        *)
            # mode pairing si plus d’un clavier
            NB_KBD=$(xinput list --name-only | grep -i "keyboard" | grep -iv "virtual" | sort | uniq | wc -l)
            TM_ID=$(xinput list --id-only keyboard:"$TM_LABEL")
            if [[ $NB_KBD -gt 1 ]]; then
                # tous les claviers → azerty
                setxkbmap fr -option
                if [[ $TM_ID ]]; then
                    # TM™ → bépo
                    echo "TypeMatrix detected (id=$TM_ID)"
                    setxkbmap fr bepo -option -device "$TM_ID"
                else
                    # pas de TM™ : premier clavier trouvé → bépo
                    FIRST_KBD_LABEL=$(xinput list --name-only | grep -i "keyboard" | grep -iv "virtual" -m 1)
                    FIRST_KBD_ID=$(xinput list --id-only keyboard:"$FIRST_KBD_LABEL")
                    setxkbmap fr bepo -option -device "$FIRST_KBD_ID"
                fi
                notif-change-layout "BÉPO / AZERTY"
            else
                # un seul clavier : → bépo
                if [[ $TM_ID ]]; then
                    setxkbmap fr bepo -option
                else
                    setxkbmap fr bepo -option ctrl:nocaps
                fi
                notif-change-layout "BÉPO"
            fi
            ;;
    esac
fi

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# llkk
# llk

# EOF
