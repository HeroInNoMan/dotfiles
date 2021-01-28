#!/usr/bin/env bash

# Hardware control
# manages brightness, monitors, sound, keyboard layout
# used in ~/.config/openbox/lubuntu-rc.xml
# script utilisé dans ~/.config/openbox/lubuntu-rc.xml pour gérer le rétro-éclairage.

HW_IMG_DIR="$HOME/.config/img"
BRIGHTNESS_IMG="$HW_IMG_DIR/brightness.png"
MUTE_IMG="$HW_IMG_DIR/sound_remove.png"
SOUND_UP_IMG="$HW_IMG_DIR/sound_up.png"
SOUND_DOWN_IMG="$HW_IMG_DIR/sound_down.png"
UNMUTE_IMG="$HW_IMG_DIR/sound.png"

SINK_NAME=$(pacmd dump | grep --max-count=1 --only-matching "alsa.*stereo")
SINKS=$(pacmd dump | grep 'sink' | cut -d ' ' -f 2 | sort | uniq)
MUTE_STATE=$(pacmd dump | grep --perl-regexp "^set-sink-mute $SINK_NAME\s+" | perl -p -e 's/.+\s(yes|no)$/$1/')
SOUND_CHANGE_STEP=10
BRIGHTNESS_CHANGE_STEP=5

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"

notif () {
  killall notification-daemon
  /usr/lib/notification-daemon/notification-daemon &
  notify-send "$1" --expire-time=500 --icon="$2" --urgency=NORMAL
}

light_down () {
  xbacklight -dec $BRIGHTNESS_CHANGE_STEP
  [ $? != 0 ] && echo $(($(cat $BRIGHTNESS_FILE) - 100)) > $BRIGHTNESS_FILE || notif "↓" "$BRIGHTNESS_IMG"
}

light_up () {
  xbacklight -inc $BRIGHTNESS_CHANGE_STEP
  [ $? != 0 ] && echo $(($(cat $BRIGHTNESS_FILE) + 100)) > $BRIGHTNESS_FILE || notif "↑" "$BRIGHTNESS_IMG"
}

sound_down () {
  if command -v amixer &> /dev/null; then
    for ctrl in $(amixer scontrols | grep 'Simple mixer control' | cut -d\' -f 2 | sort | uniq); do
      amixer -q sset $ctrl ${SOUND_CHANGE_STEP}%- unmute
    done
  fi

  if command -v pactl &> /dev/null; then
    for sink in $SINKS; do
      pactl set-sink-volume $sink -${SOUND_CHANGE_STEP}%
    done
  fi
  VOLUME_STATE=$(pacmd dump-volumes | grep 'Sink' | cut -d '/' -f 2)
  notif "🔉 ${VOLUME_STATE}" "$SOUND_DOWN_IMG"
}

sound_up () {
  if command -v amixer &> /dev/null; then
    for ctrl in $(amixer scontrols | grep 'Simple mixer control' | cut -d\' -f 2 | sort | uniq); do
      amixer -q sset $ctrl ${SOUND_CHANGE_STEP}%+ unmute
    done
  fi

  if command -v pactl &> /dev/null; then
    for sink in $SINKS; do
      pactl set-sink-volume $sink +${SOUND_CHANGE_STEP}%
    done
  fi
  VOLUME_STATE=$(pacmd dump-volumes | grep 'Sink' | cut -d '/' -f 2)
  notif "🔊 ${VOLUME_STATE}" "$SOUND_UP_IMG"
}

toggle_mute () {
  NOTIF_TEXT=$([[ $MUTE_STATE == 'yes' ]] && echo 'ON' || echo 'OFF')
  NOTIF_IMG=$([[ $MUTE_STATE == 'yes' ]] && echo "$UNMUTE_IMG" || echo "$MUTE_IMG")
  SINK_STATE=$([[ $MUTE_STATE == 'yes' ]] && echo '0' || echo '1')
  if command -v pactl &> /dev/null; then
    for sink in $SINKS; do
      pactl set-sink-mute "$sink" "$SINK_STATE"
      [ $? -eq 0 ] && notif "$NOTIF_TEXT" "$NOTIF_IMG"
    done
  fi
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
	synclient VertScrollDelta=99
	synclient HorizScrollDelta=99
	synclient VertEdgeScroll=0
	synclient HorizEdgeScroll=0
	synclient CornerCoasting=0
	synclient VertTwoFingerScroll=1
	synclient HorizTwoFingerScroll=1
	synclient MinSpeed=1
	synclient MaxSpeed=1.75
	synclient AccelFactor=0.0403307
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
	synclient CircularScrolling=0
	synclient CircScrollDelta=0.1
	synclient CircScrollTrigger=0
	synclient CircularPad=0
	synclient PalmDetect=1
	synclient PalmMinWidth=10
	synclient PalmMinZ=200
	synclient CoastingSpeed=20
	synclient CoastingFriction=50
	synclient PressureMotionMinZ=30
	synclient PressureMotionMaxZ=160
	synclient PressureMotionMinFactor=1
	synclient PressureMotionMaxFactor=1
	synclient ResolutionDetect=1
	synclient GrabEventDevice=0
	synclient TapAndDragGesture=1
	synclient AreaLeftEdge=0
	synclient AreaRightEdge=0
	synclient AreaTopEdge=0
	synclient AreaBottomEdge=0
	synclient HorizHysteresis=24
	synclient VertHysteresis=24
	synclient ClickPad=1
	synclient RightButtonAreaLeft=3068
	synclient RightButtonAreaRight=0
	synclient RightButtonAreaTop=4326
	synclient RightButtonAreaBottom=0
	synclient MiddleButtonAreaLeft=0
	synclient MiddleButtonAreaRight=0
	synclient MiddleButtonAreaTop=0
	synclient MiddleButtonAreaBottom=0

	[ -z "$MAX_TAP_TIME" ] && exit 1

	if [ "$MAX_TAP_TIME" -gt 0 ]; then
		synclient MaxTapTime=0
		notif "OFF" "$TRACKPAD_IMG"
	else
		synclient MaxTapTime=100
		notif "ON" "$TRACKPAD_IMG"
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
    "trackpad") toggle_trackpad ;;
    *) usage ;;
  esac
else
  usage
  exit 1
fi

# EOF
