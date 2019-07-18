#!/bin/bash

MONITOR_IMG="$HOME/.config/img/monitor.png"
MONITOR_FILE="./.monitor-state"
CURRENT_MODE=$(head -1 $MONITOR_FILE)
PREVIOUS_MODE=$(head -2 $MONITOR_FILE | tail -1)
M1=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 1p)
if [ -z "$M1" ]; then
    M1='eDP1'
fi
M2=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 2p)
if [ -z "$M2" ]; then
    M2='DP2'
fi
NB_M=$(xrandr --query | grep --count ' connected')

append_documentation() {
  { echo "# possible values:"
    echo "# dual-screen-copy"
    echo "# built-in-only"
    echo "# extend-left"
    echo "# extend-right"
    echo "# external-only"
  } >> $MONITOR_FILE
}

next_state() {
  case $1 in
    "previous")
      echo "$PREVIOUS_MODE";;
    "dual-screen-copy")
      echo "built-in-only";;
    "built-in-only")
      echo "extend-left";;
    "extend-left")
      echo "extend-right";;
    "extend-right")
      echo "external-only";;
    *)
      echo "dual-screen-copy";;
  esac
}

update_monitor_state() {
  echo "switching to $1 mode"
  echo "$1" > $MONITOR_FILE
  echo "$CURRENT_MODE" >> $MONITOR_FILE
  append_documentation
  notify-send "→ $1" --expire-time=1000 --icon="$MONITOR_IMG" --urgency=CRITICAL
}

usage() {
  echo "usage: $0 [ previous | dual-screen-copy | built-in-only | extend-left | extend-right | external-only ]"
}


# test args
if [ "$NB_M" -lt 2 ]; then
    NEXT_MODE=built-in-only
elif [ $# == 0 ]; then
  NEXT_MODE=$(next_state "$(head -1 $MONITOR_FILE)")
elif [ $# == 1 ]; then
    if [ "$1" == "previous" ]; then
      NEXT_MODE=$PREVIOUS_MODE
    else
        NEXT_MODE=$1
    fi
else
    usage
    exit 1
fi
echo "Monitor 1: $M1"
echo "Monitor 2: $M2"
echo "previous mode: $PREVIOUS_MODE"
echo "current mode: $CURRENT_MODE"
echo "next mode: $NEXT_MODE"

case $NEXT_MODE in
    "built-in-only")
      update_monitor_state "built-in-only"
      xrandr --output $M1 --auto --rotate normal --output $M2 --off
      ;;
    "extend-left")
      update_monitor_state "extend-left"
      xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --left-of $M1
      ;;
    "extend-right")
      update_monitor_state "extend-right"
      xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --right-of $M1
      ;;
    "external-only")
      update_monitor_state "external-only"
      xrandr --output $M2 --auto --rotate normal --output $M1 --off
      ;;
    *)
      update_monitor_state "dual-screen-copy"
      xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --same-as $M1
      ;;
esac

# EOF
