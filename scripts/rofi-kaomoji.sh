#!/usr/bin/env bash

rofi_command="rofi -i -theme repos/dotfiles/rofi/emoji.rasi"
# TODO: trouver pourquoi le -i est nécessaire malgré le “case-sensitive: false;” dans emoji.rasi

KAO_FILE="$HOME/repos/dmenukaomoji/kaomoji"
if [[ ! -f "${KAO_FILE}" ]]; then
  echo "install dmenukaomoji first: https://github.com/eylles/dmenukaomoji"
  exit 1
fi
# List for rofi
gen_list () {
  while read -r line; do
    echo "$line"
  done <$KAO_FILE
}

main() {
  kao=$( (gen_list) | $rofi_command -dmenu -p "Kao" )

  if [ -n "$kao" ]; then
    result=$(echo "$kao" | sed "s/ .*//")
    echo $result | xclip -r
    echo $result | xclip -r -selection clipboard
    xdotool key Shift+Insert
  fi
}
main
