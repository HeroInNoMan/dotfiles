#!/usr/bin/env bash

# Window Tiling Features
# hash xdotool 2>/dev/null || { echo "Error: xdotool is not installed."; }

desktop=$(xdotool get_desktop)
echo "D$((1 + ${desktop}))"

for win in $(xdotool search --desktop $desktop --name ".*"); do
  desktop_windows[i]=$win
  i=$(( i+1 ))
done

[ $i -gt 0 ] && w1=${desktop_windows[${#desktop_windows[@]}-1]}
[ $i -gt 1 ] && w2=${desktop_windows[${#desktop_windows[@]}-2]}
[ $i -gt 2 ] && w3=${desktop_windows[${#desktop_windows[@]}-3]}
[ $i -gt 2 ] && w4=${desktop_windows[${#desktop_windows[@]}-4]}

# screen positions

# # 7 8 9
# # 4 5 6
# # 1 2 3
# #
# sp_7=0
# sp_8=50
# half_screen=50
# end_screen=100
# full_screen_width=100
# half_screen_width=100
# half_screen_height=100
# full_screen_height=100

move_resize () {
  sx=$1; sy=$2; mx=$3; my=$4
  w=${5:-$w1}
  echo "[move_resize] window: $w"
  xdotool windowsize ${w} ${sx}% ${sy}%
  xdotool windowmove ${w} ${mx}% ${my}%
}

move_nw_¼ () {
  move_resize 50 47.5 0 0 $1
}
move_ne_¼ () {
  move_resize 50 47 50 0 $1
}
move_sw_¼ () {
  move_resize 50 47.5 0 49 $1
}
move_se_¼ () {
  move_resize 50 47.5 50 49 $1
}
move_n_½ () {
  move_resize 100 47.5 0 0 $1
}
move_n_¾ () {
  move_resize 100 74.5 0 0 $1
}
move_n_¼ () {
  move_resize 100 24.5 0 0 $1
}
move_s_½ () {
  move_resize 100 47.5 0 49 $1
}
move_s_¾ () {
  move_resize 100 74.5 0 25 $1
}
move_s_¼ () {
  move_resize 100 24.5 0 75 $1
}
move_w_½ () {
  move_resize 50 95 0 0 $1
}
move_e_½ () {
  move_resize 50 95 50 0 $1
}
move_w_¾ () {
  move_resize 75 95 0 0 $1
}
move_e_¼ () {
  move_resize 25 95 75 0 $1
}
move_w_¼ () {
  move_resize 25 95 0 0 $1
}
move_e_¾ () {
  move_resize 75 95 25 0 $1
}
move_c () {
  move_resize 100 100 0 0
}
tile_horizontally_½ () {
  move_n_½ $w1
  move_s_½ $w2
}
tile_horizontally_¾ () {
  move_n_¾ $w1
  move_s_¼ $w2
}
tile_horizontally_¼ () {
  move_n_¼ $w1
  move_s_¾ $w2
}
tile_vertically_½ () {
  move_w_½ $w1
  move_e_½ $w2
}
tile_vertically_¾ () {
  move_w_¾ $w1
  move_e_¼ $w2
}
tile_vertically_¼ () {
  move_w_¼ $w1
  move_e_¾ $w2
}

usage () {
  echo "Usage:"
  echo "$0 h | v (tile horizontally / vertically)"
  echo "$0 n | s | e | w | nw | ne | se | sw (move window to north / south / east / west)"
  echo "$0 c (maximize window)"
  exit 1
}

if [ $# == 0 ]; then
  # usage;
  exit 1;
elif [ $# == 1 ]; then
  case $1 in

    "v") tile_vertically_½ ;;
    "v34") tile_vertically_¾ ;;
    "v14") tile_vertically_¼ ;;
    "h") tile_horizontally_½ ;;
    "h34") tile_horizontally_¾ ;;
    "h14") tile_horizontally_¼ ;;

    "c") move_c ;;

    # "n") move_n_½ ;;
    "n") move_n_½ ;;
    "s") move_s_½ ;;
    "w") move_w_½ ;;
    "e") move_e_½ ;;

    "nw") move_nw_¼ ;;
    "ne") move_ne_¼ ;;
    "sw") move_sw_¼ ;;
    "se") move_se_¼ ;;
  esac
fi

# EOF
