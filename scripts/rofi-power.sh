#!/bin/bash
#
# A rofi powered menu to execute power related action.
# Uses: amixer mpc poweroff reboot rofi rofi-prompt

power_off=$(echo -e "⏻\tpower off")
reboot=$(echo -e "⭮\treboot")
lock=$(echo -e "🔒\tlock screen")
suspend=$(echo -e "💤\tsleep")
hibernate=$(echo -e "🌙\thibernate")
log_out=$(echo -e "🚪\tlog out")

chosen=$(printf '%s;%s;%s;%s;%s;%s\n' \
                "$power_off" \
                "$reboot" \
                "$lock" \
                "$suspend" \
                "$hibernate" \
                "$log_out" \
           | rofi -theme ale-power.rasi \
                  -p "session" \
                  -dmenu \
                  -sep ';' \
                  -no-custom \
                  -selected-row 2)

case "$chosen" in
  "$power_off")
    rofi-prompt.sh --query 'Shutdown ?' && systemctl poweroff
    ;;

  "$reboot")
    rofi-prompt.sh --query 'Reboot ?' && systemctl reboot
    ;;

  "$lock")
    lxlock
    ;;

  "$suspend")
    rofi-prompt.sh --query 'Suspend ?' && systemctl suspend
    ;;

  "$hibernate")
    rofi-prompt.sh --query 'Hibernate ?' && systemctl hybrid-sleep
    ;;

  "$log_out")
    lxsession-logout
    ;;

  *) exit 1 ;;
esac
