#!/usr/bin/env bash

# Hardware control
# manages brightness, monitors, sound, keyboard layout
# used in ~/.config/openbox/lubuntu-rc.xml
# script utilisé dans ~/.config/openbox/lubuntu-rc.xml pour gérer le rétro-éclairage.

. functions.bash

HW_IMG_DIR="$HOME/.config/img"

# default brightness values ###################################################
BRIGHTNESS_IMG="$HW_IMG_DIR/brightness.png"
BRIGHTNESS_CHANGE_STEP=5
BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"

# default sound values ########################################################
SINK_NAMES=$(pacmd dump | grep 'set-sink-mute' | cut -d ' ' -f2)
ACTIVE_SINK_ID=$(pactl list short sinks | grep -e 'RUNNING' | cut -f1)
ACTIVE_SINK_ID=${ACTIVE_SINK_ID:-1}
SOUND_CHANGE_STEP=5

notify () {
  notify-send "$1" --expire-time=1000 --icon="$2" --urgency=NORMAL
}

light_down () {
  xbacklight -dec $BRIGHTNESS_CHANGE_STEP
  [ $? != 0 ] && echo $(($(cat $BRIGHTNESS_FILE) - 100)) > $BRIGHTNESS_FILE || notify "↓" "$BRIGHTNESS_IMG"
}

light_up () {
  xbacklight -inc $BRIGHTNESS_CHANGE_STEP
  [ $? != 0 ] && echo $(($(cat $BRIGHTNESS_FILE) + 100)) > $BRIGHTNESS_FILE || notify "↑" "$BRIGHTNESS_IMG"
}

sound_down () {
  for sink in $SINK_NAMES ; do
    pactl set-sink-volume $sink -${SOUND_CHANGE_STEP}%
  done
  VOLUME_STATE=$(pacmd dump-volumes | grep -i "^Sink $ACTIVE_SINK_ID" | cut -d '/' -f2)
  SOUND_DOWN_IMG="$HW_IMG_DIR/sound_down.png"
  notify "🔉 ${VOLUME_STATE}" "$SOUND_DOWN_IMG"
}

sound_up () {
  for sink in $SINK_NAMES ; do
    pactl set-sink-volume $sink +${SOUND_CHANGE_STEP}%
  done
  VOLUME_STATE=$(pacmd dump-volumes | grep -i "^Sink $ACTIVE_SINK_ID" | cut -d '/' -f2)
  SOUND_UP_IMG="$HW_IMG_DIR/sound_up.png"
  notify "🔊 ${VOLUME_STATE}" "$SOUND_UP_IMG"
}

toggle_mike () {
  echo "Not implemented yet!"
}

toggle_mute () {
  for sink in $(pacmd dump | grep 'set-sink-mute' | cut -d ' ' -f2) ; do
    pactl set-sink-mute "$sink" "toggle"
  done
  DEFAULT_SINK_NAME=$(pacmd dump | grep --max-count=1 --only-matching "alsa.*stereo")
  ACTIVE_SINK_NAME=$(pactl list short sinks | grep -e 'RUNNING' | cut -f2)
  ACTIVE_SINK_NAME=${ACTIVE_SINK_NAME:-$DEFAULT_SINK_NAME}
  MUTE_STATE=$(pacmd dump | grep -m 1 "set-sink-mute.*$ACTIVE_SINK_NAME" | cut -d ' ' -f3)
  NOTIF_TEXT=$([[ $MUTE_STATE == 'no' ]] && echo 'ON' || echo 'OFF')
  MUTE_IMG="$HW_IMG_DIR/sound_remove.png"
  UNMUTE_IMG="$HW_IMG_DIR/sound.png"
  NOTIF_IMG=$([[ $MUTE_STATE == 'no' ]] && echo "$UNMUTE_IMG" || echo "$MUTE_IMG")
  notify "$NOTIF_TEXT" "$NOTIF_IMG"
}

cycle_audio_output () {
  SINK_INPUT_IDS=$(pactl list short sink-inputs | cut -f1)
  SINK_ID_LIST=($(pactl list short sinks | cut -f1))
  for i in "${!SINK_ID_LIST[@]}"; do
    if [[ $ACTIVE_SINK_ID == ${SINK_ID_LIST[$i]} ]]; then
      NEXT_SINK_ID=${SINK_ID_LIST[$i+1]}
    fi
  done
  # in case active sink was last in array
  [[ -z $NEXT_SINK_ID ]] && NEXT_SINK_ID=${SINK_ID_LIST[0]}

  for id in $SINK_INPUT_IDS; do
    pactl move-sink-input $id $NEXT_SINK_ID
  done
  ACTIVE_SINK_ID=$(pactl list short sinks | grep -e 'RUNNING' | cut -f1)
  ACTIVE_SINK_ID=${ACTIVE_SINK_ID:-1}
  SINK_DESC=$(pactl list sinks | grep "Destination #$ACTIVE_SINK_ID" -A 10 | grep "Description" | cut -d: -f2)
  [[ -n $SINK_DESC ]] && notify "⇒ $SINK_DESC"
}

toggle_trackpad () {
  TRACKPAD_IMG="$HOME/.config/img/mouse_warning.png"

  MAX_TAP_TIME=$(synclient -l | grep --regexp='MaxTapTime' | cut --delimiter='=' --fields=2 | tr --delete '[:blank:]')

  # configure trackpad options
  synclient LeftEdge=1310
  synclient RightEdge=4826
  synclient TopEdge=2220
  synclient BottomEdge=4636
  synclient FingerLow=25
  synclient FingerHigh=30
  synclient MaxTapTime=100
  synclient MaxTapMove=218
  synclient MaxDoubleTapTime=180
  synclient SingleTapTimeout=180
  synclient ClickTime=100
  synclient EmulateMidButtonTime=0
  synclient EmulateTwoFingerMinZ=282
  synclient EmulateTwoFingerMinW=7
  synclient VertScrollDelta=50
  synclient HorizScrollDelta=30
  synclient VertEdgeScroll=0
  synclient HorizEdgeScroll=0
  synclient CornerCoasting=0
  synclient VertTwoFingerScroll=1
  synclient HorizTwoFingerScroll=1
  synclient MinSpeed=0.1
  synclient MaxSpeed=1.75
  synclient AccelFactor=0.05
  synclient TouchpadOff=0
  synclient LockedDrags=0
  synclient LockedDragTimeout=5000
  synclient RTCornerButton=2
  synclient RBCornerButton=3
  synclient LTCornerButton=0
  synclient LBCornerButton=0
  synclient TapButton1=1
  synclient TapButton2=3
  synclient TapButton3=2
  synclient ClickFinger1=1
  synclient ClickFinger2=3
  synclient ClickFinger3=0
  synclient CircularScrolling=on
  synclient CircScrollDelta=0.1
  synclient CircScrollTrigger=0
  synclient CircularPad=0
  synclient PalmDetect=1
  synclient PalmMinWidth=8
  synclient PalmMinZ=100
  synclient CoastingSpeed=20
  synclient CoastingFriction=50
  synclient PressureMotionMinZ=30
  synclient PressureMotionMaxZ=160
  synclient PressureMotionMinFactor=1
  synclient PressureMotionMaxFactor=1
  synclient GrabEventDevice=0
  synclient TapAndDragGesture=1
  synclient AreaLeftEdge=0
  synclient AreaRightEdge=0
  synclient AreaTopEdge=0
  synclient AreaBottomEdge=0
  synclient HorizHysteresis=10
  synclient VertHysteresis=10
  synclient ClickPad=1
  synclient RightButtonAreaLeft=3068
  synclient RightButtonAreaRight=0
  synclient RightButtonAreaTop=4326
  synclient RightButtonAreaBottom=0
  synclient MiddleButtonAreaLeft=0
  synclient MiddleButtonAreaRight=0
  synclient MiddleButtonAreaTop=0
  synclient MiddleButtonAreaBottom=0
  # synclient ResolutionDetect=1

  if hash syndaemon 2>/dev/null; then
    if pgrep -x syndaemon > /dev/null; then
      echo "syndaemon already running"
    else
      echo "starting syndaemon..."
      syndaemon -i 0.5 -t -K -R &
    fi

  else

    [ -z "$MAX_TAP_TIME" ] && exit 1

    if [ "$MAX_TAP_TIME" -gt 0 ]; then
      synclient MaxTapTime=0
      notify "OFF" "$TRACKPAD_IMG"
    else
      synclient MaxTapTime=100
      notify "ON" "$TRACKPAD_IMG"
    fi
  fi

}

usage () {
  echo "Usage:"
  echo "$0 light-up | light-down"
  echo "$0 sound-toggle | sound-up | sound-down"
  echo "$0 display | display-previous | display-dual-screen-copy | display-built-in-only | display-extend-left | display-extend-right | display-extend-up | display-extend-down | display-external-only | display-extend-triple"
  echo "$0 trackpad"
}

if [ $# == 1 ]; then
  case $1 in
    "display") manage-displays.sh ;;
    "display-previous") manage-displays.sh previous ;;
    "display-dual-screen-copy") manage-displays.sh dual-screen-copy ;;
    "display-built-in-only") manage-displays.sh built-in-only ;;
    "display-extend-left") manage-displays.sh extend-left ;;
    "display-extend-right") manage-displays.sh extend-right ;;
    "display-extend-up") manage-displays.sh extend-up ;;
    "display-extend-down") manage-displays.sh extend-down ;;
    "display-external-only") manage-displays.sh external-only ;;
    "display-extend-triple") manage-displays.sh extend-triple ;;
    "light-down") light_down ;;
    "light-up") light_up ;;
    "sound-down") sound_down ;;
    "sound-up") sound_up ;;
    "sound-toggle") toggle_mute ;;
    "sound-cycle") cycle_audio_output ;;
    "trackpad") toggle_trackpad ;;
    *) usage ;;
  esac
else
  usage
  exit 1
fi

# EOF
