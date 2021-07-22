#!/usr/bin/env bash

source "rofi-utils.sh"

# Videos directory
ROOT_DIR="$HOME/Vidéos"
SOURCE_DIRS=("$HOME/Vidéos/Politique" "$HOME/Téléchargements" "/media/duncan/Maxtor")
INDEX_FILE="$ROOT_DIR/.index"
PATHS="/tmp/paths"
EXTENTIONS=("avi" "mp4" "mkv")
mkdir -p "$ROOT_DIR"

write_paths_to_tmp_file() {
  true > $PATHS
  REGEX=".*\.\(xxx"
  for e in "${EXTENTIONS[@]}"; do
    REGEX+="\|$e"
  done
  REGEX+="\)"
  for d in "${SOURCE_DIRS[@]}"
  do
    if [[ -d "$d" ]]; then
      find "$d" -type f \
           -regex $REGEX \
           >> "$PATHS"
    fi
  done
}

extract_display_string(){
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
  display_string="${t_title}${padding}(${t_duration})"
  echo "$display_string"
}

load_files() {

  if [[ ! -f $INDEX_FILE ]]; then

    write_paths_to_tmp_file

    if [[ -s $PATHS ]]; then

      # create temp file ######################################################
      INDEX_FILE_TMP="/tmp/.index_videos"
      true > $INDEX_FILE_TMP

      while read -r path; do
        display_string=$(extract_display_string "$path")
        # write display string and path in temp file ##########################
        echo "$display_string|$path" >> "$INDEX_FILE_TMP"
      done <"$PATHS"

      # sort temp file and write to final index file ##########################
      sort $INDEX_FILE_TMP > $INDEX_FILE
      rm -f $INDEX_FILE_TMP
    else
      echo "No files found."
      exit 1
    fi
  fi
}

# create a list for rofi to consume ###########################################
gen_list(){
  load_files
  while read -r line; do
    echo -e "$line"
  done <"$INDEX_FILE"
}

main() {
  lines=$(gen_list)
  display_line=$( echo -e "$lines" | cut -d\| -f1 | rofi -i -theme repos/dotfiles/rofi/media.rasi -dmenu -no-custom -p "🎬" )
  if [ -n "$display_line" ]; then
    while read -r line; do
      if [[ $line == *"$display_line"* ]]; then
        smplayer -fullscreen -close-at-end -minigui "$(echo "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$INDEX_FILE"
  fi
}

main
exit 0
