#!/bin/bash

MONITOR_IMG="$HOME/.config/img/monitor.png"
MONITOR_FILE="$HOME/.monitor-state"

CURRENT_MODE=$(head -1 $MONITOR_FILE)
PREVIOUS_MODE=$(head -2 $MONITOR_FILE | tail -1)

log() {
	echo $(date "+%F %T") $@
}

usage() {
	log "usage: $0 [ previous | built-in-only | dual-screen-copy | extend-left | extend-right | extend-up | extend-down | external-only | extend-triple ]"
}

translate() {
	case $1 in
		built-in-only|built-in|builtin|built|internal|int|in|i)
			echo "built-in-only";;
		extend-left|left|l)
			echo "extend-left";;
		extend-right|right|r)
			echo "extend-right";;
		extend-up|up|u)
			echo "extend-up";;
		extend-down|down|d)
			echo "extend-down";;
		external-only|external|ext|e)
			echo "external-only";;
		extend-triple|triple|t)
			echo "extend-triple";;
		dual-screen-copy|dual|copy|c)
			echo "dual-screen-copy";;
		*)
			usage
			exit 1;;
	esac
}

next_state() {
	case $1 in
		previous)
			echo "$PREVIOUS_MODE";;
		built-in-only)
			echo "dual-screen-copy";;
		dual-screen-copy)
			echo "extend-left";;
		extend-left)
			echo "extend-right";;
		extend-right)
			echo "extend-up";;
		extend-up)
			echo "extend-down";;
		extend-down)
			echo "external-only";;
		external-only)
			echo "extend-triple";;
		*)
			echo "built-in-only";;
	esac
}

if [ $# == 0 ]; then
	NEXT_MODE=$(next_state "$(head -1 $MONITOR_FILE)")
elif [ $# == 1 ]; then
	if [ "$1" == "previous" ]; then
		NEXT_MODE=$PREVIOUS_MODE
	else
		NEXT_MODE=$(translate "$1")
	fi
else
	usage
	exit 1
fi

NB_MONITORS=$(xrandr --query | grep --count ' connected')
case $NB_MONITORS in
	0)
		log "No connected monitor detected!"
		exit 1;;
	1)
		M1=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 1p)
		NEXT_MODE=built-in-only;;
	2)
		M1=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 1p)
		M2=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 2p)
		# pas de mode triple avec seulement deux écrans
		[[ "$NEXT_MODE" == "extend-triple" ]] && NEXT_MODE='extend-right';;
	3)
		M1=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 1p)
		M2=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 2p)
		M3=$(xrandr --query | grep ' connected' | cut --delimiter=' ' --fields=1 | sed --quiet 3p)
		# make HDMI second and VGA third if possible
		[[ "$M3" == *"HDMI"* &&  "$M2" == *"VGA"* ]] && M_TMP=$M2 && M2=$M3 && M3=$M_TMP
		;;
	*)
		log "Too many monitors detected!"
		exit 1;;
esac

OFF_MONITORS_LIST=$(xrandr --query | grep ' disconnected' | cut --delimiter=' ' --fields=1 | sed --quiet p)
for m in $OFF_MONITORS_LIST; do
	OFF_ARG+=$(echo " --output $m --auto")
done

case $NEXT_MODE in
	built-in-only)
		MONITOR_SUMMARY="$M1"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --off --output $M3 --off $OFF_ARG);;
	extend-left)
		MONITOR_SUMMARY="$M1, $M2"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --left-of $M1 --output $M3 --off $OFF_ARG);;
	extend-right)
		MONITOR_SUMMARY="$M1, $M2"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --right-of $M1 --output $M3 --off $OFF_ARG);;
	extend-up)
		MONITOR_SUMMARY="$M1, $M2"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --above $M1 --output $M3 --off $OFF_ARG);;
	extend-down)
		MONITOR_SUMMARY="$M1, $M2"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --below $M1 --output $M3 --off $OFF_ARG);;
	external-only)
		MONITOR_SUMMARY="$M2"
		$(xrandr --output $M2 --auto --rotate normal --output $M1 --off --output $M3 --off $OFF_ARG);;
	extend-triple)
		MONITOR_SUMMARY="$M1, $M2, $M3"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --right-of $M1 --output $M3 --auto --rotate normal --right-of $M2 $OFF_ARG);;
	dual-screen-copy)
		MONITOR_SUMMARY="$M1, $M2"
		$(xrandr --output $M1 --auto --rotate normal --output $M2 --auto --rotate normal --same-as $M1 --output $M3 --off $OFF_ARG);;
	*)
		usage
		exit 1;;
esac

append_documentation() {
	{ echo "# possible values:"
		echo "# built-in-only"
		echo "# dual-screen-copy"
		echo "# extend-left"
		echo "# extend-right"
		echo "# extend-up"
		echo "# extend-down"
		echo "# external-only"
		echo "# extend-triple"
	} >> $MONITOR_FILE
}

update_monitor_state() {
	log "$CURRENT_MODE → $NEXT_MODE ($MONITOR_SUMMARY)"
	log "$1" > $MONITOR_FILE
	log "$CURRENT_MODE" >> $MONITOR_FILE
	append_documentation
	notify-send "→ $1" --expire-time=1000 --icon="$MONITOR_IMG"
}

update_monitor_state $NEXT_MODE

# EOF
