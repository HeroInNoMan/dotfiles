#!/bin/bash
#
# A rofi powered menu to execute power related action.
# Uses: amixer mpc poweroff reboot rofi rofi-prompt

power_off='⏻	power off'
reboot='⭮	reboot'
lock='🔒	lock screen'
suspend='💤	sleep'
log_out='🚪	log out'

chosen=$(printf '%s;%s;%s;%s;%s\n' "$power_off" "$reboot" "$lock" "$suspend" "$log_out" | rofi -theme repos/dotfiles/rofi/power.rasi -dmenu -sep ';' -selected-row 2 -p "Session")

case "$chosen" in
  "$power_off")
    rofi-prompt.sh --query 'Shutdown?' # && poweroff
    ;;

  "$reboot")
    rofi-prompt.sh --query 'Reboot?' # && reboot
    ;;

  "$lock")
    lxlock
    ;;

  "$suspend")
    # TODO Add your suspend command.
    ;;

  "$log_out")
    # TODO Add your log out command.
    ;;

  *) exit 1 ;;
esac
