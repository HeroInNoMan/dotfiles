#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Info:
#   author:    Arthur Léothaud
#   file:      rofi-display-layout.sh
#   created:   2020-12-26T17:35:05+0100
#   revision:  ---
#   version:   1.0
# -----------------------------------------------------------------------------
# Requirements:
#   rofi
# Description:
#   Use rofi to search for saved arandr configurations
# Usage:
#   rofi-display-layout.sh
# -----------------------------------------------------------------------------
# Script:

# arandr configurations directory

LAYOUTS_DIR="$HOME/.screenlayout/"
mkdir -p "$LAYOUTS_DIR"

# Save find result to F_ARRAY
readarray -t F_ARRAY <<< "$(find "$LAYOUTS_DIR" -type f -name '*.sh')"

# Associative array for storing layouts
# key => layout name
# value => absolute path to the file
# LAYOUTS['filename']='path'
declare -A LAYOUTS

# Add elements to LAYOUTS array
get_layouts() {

  # if [ ${#F_ARRAY[@]} != 0 ]; then
  if [[ ! -z ${F_ARRAY[@]} ]]; then
    for i in "${!F_ARRAY[@]}"
    do
      path=${F_ARRAY[$i]}
      file=$(basename "${F_ARRAY[$i]}")
      file=${file%.sh}
      LAYOUTS+=(["$file"]="$path")
    done
  else
    echo "$LAYOUTS_DIR is empty!"
    echo "Please start by saving a layout with arandr."
    exit 1
  fi
}

# List for rofi
gen_list(){
  for i in "${!LAYOUTS[@]}"
  do
    echo "$i"
  done
}

main() {
  get_layouts
  layout=$( (gen_list) | rofi -i -theme ale-monitor.rasi -dmenu -no-custom -p "💻📺" )

  if [ -n "$layout" ]; then
    echo "$layout"
    echo "${LAYOUTS[$layout]}"
    ${LAYOUTS[$layout]}
    echo "done."
  fi
}

main

exit 0
