#!/usr/bin/env bash

# Audacious music player control
# used in ~/.config/openbox/lubuntu-rc.xml

. functions.bash

HW_IMG_DIR="$HOME/.config/img"
PLAY_PAUSE_IMG="$HW_IMG_DIR/play.png"
FWD_IMG="$HW_IMG_DIR/skip_forward.png"
REW_IMG="$HW_IMG_DIR/skip_backward.png"

ENQUEUE_TO_TEMP_IMG="$HW_IMG_DIR/.png"
ENQUEUE_IMG="$HW_IMG_DIR/.png"
SHOW_MAIN_WINDOW_IMG="$HW_IMG_DIR/.png"
PAUSE_IMG="$HW_IMG_DIR/stop.png"
QUIT_AFTER_PLAY_IMG="$HW_IMG_DIR/.png"
HEADLESS_IMG="$HW_IMG_DIR/.png"
SHOW_JUMP_BOX_IMG="$HW_IMG_DIR/search.png"

notify () {
  notify "$2 " --expire-time=1000 --urgency=CRITICAL --icon="$1"
}

usage() {
  echo "Usage: TODO"
}

if [ $# == 1 ]; then
  case $1 in
    "show-main-window")
      audacious --show-main-window
      # notify $SHOW_MAIN_WINDOW_IMG "Audacious Music Player"
      ;;
    "fwd")
      audacious --fwd
      # notify $FWD_IMG "Fast-forward"
      ;;
    "rew")
      audacious --rew
      # notify $REW_IMG "Rewind"
      ;;
    "pause")
      audacious --pause
      # notify $PAUSE_IMG "Play / Pause"
      ;;
    "play-pause")
      audacious --play-pause
      # notify $PLAY_PAUSE_IMG "Play / Pause"
      ;;
    "quit-after-play")
      audacious --quit-after-play
      # notify $QUIT_AFTER_PLAY_IMG
      ;;
    "headless")
      audacious --headless
      # notify $HEADLESS_IMG "Headless"
      ;;
    "enqueue")
      audacious --enqueue
      # notify $ENQUEUE_IMG "Enqueue"
      ;;
    "enqueue-to-temp")
      audacious --enqueue-to-temp
      # notify $ENQUEUE_TO_TEMP_IMG "Enqueue to temp"
      ;;
    "show-jump-box")
      audacious --show-jump-box
      # notify $SHOW_JUMP_BOX_IMG "Search Music"
      ;;
    *) usage ;;
  esac
else
  usage
  exit 1
fi

# EOF
