#!/usr/bin/env bash

# Books directory
# VIDEOS_DIR="$HOME/"
# mkdir -p $VIDEOS_DIR

# Save find result to F_ARRAY
readarray -t F_ARRAY <<< "$(find $HOME/Vidéos/ $HOME/Téléchargements/ /media/ftp/freebox/ -type f -name '*.mp4' -o -name '*.avi' -o -name '*.mkv')"

# Associative array for storing videos
# key => book name
# value => absolute path to the file
# VIDEOS['filename']='path'
declare -A VIDEOS

# Add elements to VIDEOS array
get_videos() {

  # if [ ${#F_ARRAY[@]} != 0 ]; then
  if [[ ! -z ${F_ARRAY[@]} ]]; then
    for i in "${!F_ARRAY[@]}"
    do
      path=${F_ARRAY[$i]}
      path_dir=$(dirname "$path")
      short_path=$(basename "$path_dir")
      file=$short_path/$(basename "$path")
      file=${file%.*}
      VIDEOS+=(["$file"]="$path")
    done
  else
    echo "No videos found."
    exit 1
  fi
}

# List for rofi
gen_list(){
  for i in "${!VIDEOS[@]}"
  do
    echo "$i"
  done
}

main() {
  get_videos
  video=$( (gen_list) | rofi -dmenu -i -no-custom -columns 1 -width 80 -lines 30 -location 6 -p "Vidéos > " )

  if [ -n "$video" ]; then
    smplayer -fullscreen -close-at-end -minigui "${VIDEOS[$video]}"
  fi
}

main

exit 0
