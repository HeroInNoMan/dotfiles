#!/usr/bin/env bash

if [ $# -ne 0 ]; then
  modi="$1";
else
  modi="run";
fi
rofi -show "$modi" -theme "repos/dotfiles/rofi/run.rasi"

# EOF
