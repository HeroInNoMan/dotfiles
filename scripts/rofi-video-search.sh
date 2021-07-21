#!/usr/bin/env bash

# Videos directory
VIDEOS_DIR="$HOME/Vidéos"
VIDEOS_INDEX="$VIDEOS_DIR/.index"
mkdir -p $VIDEOS_DIR

# Save find result to F_ARRAY

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
  echo -e "${padding}"
}

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" "$h" "$m" "$s"
}

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

        # path="/home/duncan/Vidéos/au travail/2009.05.27 - Questions pour un Champion.mkv"
        TAGS_DUMP=$(ffprobe -hide_banner -show_format -of compact -i "$path" 2> /dev/null)
        if [[ $(echo $TAGS_DUMP | grep title=) ]]; then
          t_title=$(echo $TAGS_DUMP | sed -e 's/.*title=\([^|]*\).*/\1/')
        else
          t_title=$(awk '{ sub(/.*(Vidéos|Téléchargements|\/media\/duncan)\//, ""); print }' <<< "$path")
          t_title=${t_title%.*}
        fi
        if [[ $(echo $TAGS_DUMP | grep duration=) ]]; then
          t_duration=$(echo $TAGS_DUMP | sed -e 's/.*duration=\([^|\.]*\).*/\1/')
          t_duration=$(convertsecs "$t_duration")
          padding=$(build_padding "$t_title" "$t_duration" 145)
        fi

        infos="${t_title}${padding}(${t_duration})"

        echo "$infos|$path" >> "$VIDEOS_INDEX_TMP"
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
