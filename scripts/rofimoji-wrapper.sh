#!/usr/bin/env bash

if [[ ! $(hash rofimoji) ]]; then
  if [[ -f $HOME/.local/bin/rofimoji ]]; then
    export PATH=$PATH:$HOME/.local/bin/
  else
    echo "Please install rofimoji: 'pipx install rofimoji'"
  fi
fi

$(rofimoji --files "${1:-emojis}" \
# remplacé par un fichier de conf ~/.config/rofimoji.rc
    # --selector-args=" -theme ale-emoji.rasi " \
    # --action clipboard \
    # --skin-tone neutral \
    # --clipboarder xclip \
    # --typer xdotool \
    # --selector rofi \
  )

caps_lock_status=$(xset -q | sed -n 's/^.*Caps Lock:\s*\(\S*\).*$/\1/p')
if [ $caps_lock_status == "on" ]; then
  echo "Caps lock on, turning off"
  xdotool key Caps_Lock
else
  echo "Caps lock already off"
fi

shift_lock_status=$(xset -q | sed -n 's/^.*Shift Lock:\s*\(\S*\).*$/\1/p')
if [ $caps_lock_status == "on" ]; then
  echo "Shift lock on, turning off"
  xdotool key Shift_Lock
else
  echo "Shift lock already off"
fi

xdotool type "$(xclip -o -selection clipboard)"

# EOF
