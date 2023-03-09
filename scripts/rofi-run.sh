#!/usr/bin/env bash

if [ $# -ne 0 ]; then
  modi="$1";
else
  modi="run";
fi

ROFI_THEME="ale-run.rasi"

if [ $modi == "emoji" ]; then
  ROFI_THEME="ale-emoji.rasi"
fi


rofi \
  -show "$modi" \
  -theme "$ROFI_THEME" \

  # EOF
