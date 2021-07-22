#!/usr/bin/env bash

# utility functions ###########################################################

build_padding(){
  str_left="$1"
  str_right="$2"
  max_width="$3"
  ((n=$max_width - ${#str_right}))
  padding=""
  while [[ $n -gt ${#str_left} ]]; do
    padding+=" "
    ((n--))
  done
  echo "${padding}"
}

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" "$h" "$m" "$s"
}
