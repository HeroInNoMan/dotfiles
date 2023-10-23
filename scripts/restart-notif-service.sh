#!/usr/bin/env bash

if hash notify-send 2>/dev/null; then
  # PIDS=$(pkill notification-daemon)
  # if [ ! $PIDS -eq 1 ]; then
  echo "Restarting notification-daemon…"
  killall notification-daemon
  /usr/lib/notification-daemon/notification-daemon&
  # fi
else
  echo "No notification service available!"
fi

# EOF
