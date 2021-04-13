#!/usr/bin/env bash

KAO_FILE="$HOME/repos/dmenukaomoji/kaomoji"
[ -z $KAO_FILE ] \
  && echo "install dmenukaomoji first: https://github.com/eylles/dmenukaomoji" \
          https://github.com/eylles/dmenukaomoji&& exit 1

# List for rofi
gen_list () {
  while read -r line; do
    echo "$line"
  done <$KAO_FILE
}

main() {
  kao=$( (gen_list) | \
           rofi \
             -dmenu \
             -i \
             -opacity 10 \
             -no-custom \
             -location 6 \
             -lines 40 \
             -width 95 \
             -columns 4 \
             -p "Kaomoji > " )

  if [ -n "$kao" ]; then
    result=$(echo "$kao" | sed "s/ .*//")
    echo $result | xclip -r
    echo $result | xclip -r -selection clipboard
    xdotool key Shift+Insert
  fi
}
    main
