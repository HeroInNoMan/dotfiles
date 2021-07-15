#!/usr/bin/env bash

# Videos directory
VIDEOS_DIR="$HOME/Vidéos"
VIDEOS_INDEX="$VIDEOS_DIR/.index"
mkdir -p $VIDEOS_DIR

# Save find result to F_ARRAY

# Add elements to VIDEOS array
load_videos() {

  if [[ ! -f $VIDEOS_INDEX ]]; then

    readarray -t F_ARRAY <<< "$(find $HOME/Vidéos/ $HOME/Téléchargements/ /media/duncan/Maxtor/ -type f -name '*.mp4' -o -name '*.avi' -o -name '*.mkv')"
    if [[ ! -z ${F_ARRAY[@]} ]]; then

      VIDEOS_INDEX_TMP="/tmp/.index_videos"
      true > $VIDEOS_INDEX_TMP

      for i in "${!F_ARRAY[@]}"
      do
        path=${F_ARRAY[$i]}
        file=$(awk '{ sub(/.*(Vidéos|Téléchargements|\/media\/duncan)\//, ""); print }' <<< "$path")
        file=${file%.*}
        echo "$file|$path" >> "$VIDEOS_INDEX_TMP"
      done
      sort $VIDEOS_INDEX_TMP > $VIDEOS_INDEX
      rm -f $VIDEOS_INDEX_TMP
    else
      echo "No videos found."
      exit 1
    fi
  fi
}

# List for rofi
gen_list(){
  while read -r line; do
    echo -e "$line"
  done <"$VIDEOS_INDEX"
}

main() {
  load_videos
  videos=$(gen_list)
  video=$( echo -e "$videos" | cut -d\| -f1 | rofi -i -theme repos/dotfiles/rofi/media.rasi -dmenu -no-custom -p "🎬" )

  if [ -n "$video" ]; then
    while read -r line; do
      if [[ $line == *"$video"* ]]; then
        smplayer -fullscreen -close-at-end -minigui "$(echo "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$VIDEOS_INDEX"
  fi
}

main

exit 0
