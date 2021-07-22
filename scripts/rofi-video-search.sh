#!/usr/bin/env bash

source "rofi-utils.sh"

# Videos directory
VIDEOS_DIR="$HOME/Vidéos"
VIDEOS_INDEX="$VIDEOS_DIR/.index"
PATHS="/tmp/paths"
mkdir -p "$VIDEOS_DIR"

write_paths_to_file() {

  find "$HOME/Vidéos/Politique" "$HOME/Téléchargements" "/media/duncan/Maxtor" -type f \
       -iname '*.mp4'  \
       -o -iname '*.avi'  \
       -o -iname '*.mkv'  \
       > "$1"
}

extract_video_infos(){
  path="$1"

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
  echo "$infos"
}

load_videos() {

  if [[ ! -f $VIDEOS_INDEX ]]; then

    write_paths_to_file $PATHS

    if [[ -s $PATHS ]]; then

      # create temp file ######################################################
      VIDEOS_INDEX_TMP="/tmp/.index_videos"
      true > $VIDEOS_INDEX_TMP

      while read -r path; do
        infos=$(extract_video_infos "$path")
        # write display string and path in temp file ##########################
        echo "$infos|$path" >> "$VIDEOS_INDEX_TMP"
      done <"$PATHS"

      # sort temp file and write to final index file ##########################
      sort $VIDEOS_INDEX_TMP > $VIDEOS_INDEX
      rm -f $VIDEOS_INDEX_TMP
    else
      echo "No videos found."
      exit 1
    fi
  fi
}

# create a list for rofi to consume ###########################################
gen_list(){
  load_videos
  while read -r line; do
    echo -e "$line"
  done <"$VIDEOS_INDEX"
}

main() {
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
