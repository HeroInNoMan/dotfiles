#!/bin/bash

if [ $# -ne 0 ]; then
    modi="$1";
else
    modi="run";
fi
rofi -show $modi -bg '#262626' -bgalt '#212121' -fg '#ffffff' -hlbg '#d64937' -hlfg '#ffffff' -font monospace\ 12 -opacity "90" -location 6 -lines 30

# EOF
