#!/bin/bash

# rofi_command="rofi -theme themes/scrotmenu.rasi"
# rofi_command="rofi"
rofi_command="rofi -bg '#262626' -bgalt '#212121' -fg '#ffffff' -hlbg '#d64937' -hlfg '#ffffff' -opacity "90" -location 6 -lines 30"

### Options ###
screen="🖵 (screen)"
area=" (area)"
window="🗔 (window)"
# Variable passed to rofi
options="$screen\n$area\n$window"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 1 -p "Capture")"
case $chosen in
  $screen)
    sleep 1; scrot
    ;;
  $area)
    scrot -s
    ;;
  $window)
    sleep 1; scrot -u
    ;;
esac
