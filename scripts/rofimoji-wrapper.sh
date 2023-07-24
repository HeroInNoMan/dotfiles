#!/usr/bin/env bash

echo $1

if [[ ! $(hash rofimoji) ]]; then
  if [[ -f $HOME/.local/bin/rofimoji ]]; then
    export PATH=$PATH:$HOME/.local/bin/
  else
    echo "Please install rofimoji: 'pipx install rofimoji'"
  fi
fi

$($HOME/.local/bin/rofimoji \
    --files "${1:-emojis}" \
    --selector-args=" -theme ale-emoji.rasi " \
    --action clipboard \
    --skin-tone neutral \
    --selector rofi \
    --clipboarder xclip \
  )
# EOF
