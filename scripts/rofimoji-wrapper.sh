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
           --selector-args="-theme repos/dotfiles/rofi/emoji.rasi")
# EOF
