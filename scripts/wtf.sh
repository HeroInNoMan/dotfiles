#!/usr/bin/env bash

# Window Tiling Features

# TODO make sure xdotool is installed


move_nw () {
  xdotool getactivewindow windowsize 50% 47.5% windowmove 0 0
}

move_ne () {
  xdotool getactivewindow windowsize 50% 47% windowmove 50% 0
}

move_sw () {
  xdotool getactivewindow windowsize 50% 47.5% windowmove 0% 49%
}

move_se () {
  xdotool getactivewindow windowsize 50% 47.5% windowmove 50% 49%
}

move_n () {
  xdotool getactivewindow windowsize 100% 47.5% windowmove 0% 0%
}

move_s () {
  xdotool getactivewindow windowsize 100% 47.5% windowmove 0% 49%
}

move_w () {
  xdotool getactivewindow windowsize 50% 95% windowmove 0 0
}

move_e () {
  xdotool getactivewindow windowsize 50% 95% windowmove 50% 0
}

alt_tab () {
  xdotool keydown alt key Tab
  xdotool keyup alt sleep 0.08
}

tile_horizontally () {
  move_n
  alt_tab
  move_s
  alt_tab
}

tile_vertically () {
  move_w
  alt_tab
  move_e
  alt_tab
}

usage () {
  echo "Usage:"
  echo "$0 t (alt_tab)"
  echo "$0 h | v (tile horizontally / vertically)"
  echo "$0 n | s | e | w | nw | ne | se | sw (move window to north / south / east / west)"
  exit 1
}

if [ $# == 0 ]; then
  usage;
  exit 1;
elif [ $# == 1 ]; then
  case $1 in

    "t") alt_tab ;;
    "h") tile_horizontally ;;
    "v") tile_vertically ;;

    "n") move_n ;;
    "s") move_s ;;
    "w") move_w ;;
    "e") move_e ;;

    "nw") move_nw ;;
    "ne") move_ne ;;
    "sw") move_sw ;;
    "se") move_se ;;
  esac
fi

# EOF
