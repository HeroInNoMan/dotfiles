#!/usr/bin/env bash

notify () {
  args=$@
  if hash notify-send 2>/dev/null; then
    PIDS=$(pgrep -c -f notification-daemon)
    if [ $PIDS -eq 0 ]; then
      echo "Restarting notification-daemon…"
      /usr/lib/notification-daemon/notification-daemon &
    fi
    notify-send "$args"
  else
    echo "No notification service available!"
  fi
}

make_title () {
  max_length=52
  char="*"

  string=$1
  padding=""
  line=""
  title=" "
  for ((i=0; i < ${#string}; i++)); do
    title="${title}${string:$i:1} "
  done

  for ((i=0 ; i < (((max_length - ${#title}) / 2 )) ; i++)); do
    padding="${padding}${char}"
  done

  for ((i=0 ; i < max_length ; i++)); do
    line="${line}${char}"
  done

  echo -e "$line\n${padding}${title^^}${padding}${char}\n$line"
}
