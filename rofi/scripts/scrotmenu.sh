#!/bin/bash

# rofi_command="rofi -theme themes/scrotmenu.rasi"
# rofi_command="rofi"
rofi_command="rofi -bg '#262626' -bgalt '#212121' -fg '#ffffff' -hlbg '#d64937' -hlfg '#ffffff' -opacity "90" -location 6 -lines 30"

### Options ###
screen="🖵 (screen)"
area=" (area)"
window="🗔 (window)"
screen_publish="🖵 (screen) → publish"
area_publish=" (area) → publish"
window_publish="🗔 (window) → publish"
# Variable passed to rofi
options="$screen\n$screen_publish\n$area\n$area_publish\n$window\n$window_publish"


chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 3 -p "Capture")"
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
  $screen_publish)
    sleep 1; scrot; publish.sh
    ;;
  $area_publish)
    scrot -s; publish.sh
    ;;
  $window_publish)
    sleep 1; scrot -u; publish.sh
    ;;
esac
