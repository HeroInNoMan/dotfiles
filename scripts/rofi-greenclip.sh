#!/usr/bin/env bash

if ! hash greenclip 2> /dev/null; then
  echo "Installing greenclip…"
  cd ~/bin/ || return
  wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip
  chmod a+x greenclip
  cd - || return
fi

if [ $(pgrep -f "greenclip daemon" | wc -l) -lt 1 ]; then
  echo "Starting greenclip daemon…"
  greenclip daemon &
fi

rofi -modi "clipboard:greenclip print" -show clipboard -theme "ale-run.rasi" -run-command '{cmd}'

# EOF
