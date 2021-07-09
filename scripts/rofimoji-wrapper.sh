#!/usr/bin/env bash
if [[ ! $(hash rofimoji) ]]; then
  if [[ -f $HOME/.local/bin/rofimoji ]]; then
    export PATH=$PATH:$HOME/.local/bin/
  else
    echo "Please install rofimoji: 'pip install rofimoji'"
  fi
fi

$(rofimoji --files "${1:-emojis}" \
           --action clipboard \
           --skin-tone neutral \
           --selector rofi \
           --selector-args="-location 6 \
                          -opacity 10 \
                          -lines 40 \
                          -width 95 \
                          -columns 4 \
                          -bg '#262626' \
                          -bgalt '#212121' \
                          -fg '#ffffff' \
                          -hlbg '#d64937' \
                          -hlfg '#ffffff' ")
# EOF
