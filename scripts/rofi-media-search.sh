#!/usr/bin/env bash

MEDIA_TYPE=$1

# init params #################################################################
case $MEDIA_TYPE in
  music)
    ROOT_DIR="$HOME/Musique"
    SOURCE_DIRS=("$ROOT_DIR")
    EXTENTIONS=( "mp3" "flac"  "m3u"  "m4a"  "mp4"  "mpc"  "mpg"  "wav"  "wma"  "wmv")
    PROMPT_EMOJI="🎶"
    SORT=1
    EXEC_CMD="audacious -E"
    ;;
  book)
    ROOT_DIR="$HOME/ebooks"
    SOURCE_DIRS=("$ROOT_DIR")
    EXTENTIONS=("epub")
    PROMPT_EMOJI="📚"
    SORT=0
    EXEC_CMD="ebook-viewer"
    ;;
  video)
    ROOT_DIR="$HOME/Vidéos"
    SOURCE_DIRS=("$ROOT_DIR" "$HOME/Téléchargements" "/media/duncan/Maxtor" "/media/ftp/freebox")
    EXTENTIONS=("avi" "mp4" "mkv")
    PROMPT_EMOJI="🎬"
    SORT=1
    EXEC_CMD="smplayer -fullscreen -close-at-end -minigui"
    ;;
  *)
    echo "usage: $0 <music> | <book> | <video>"
    exit 1
    ;;
esac

# common init params ##########################################################
INDEX_FILE="$ROOT_DIR/.index-$MEDIA_TYPE"
INDEX_DISPLAY_FILE="$ROOT_DIR/.index-display-$MEDIA_TYPE"
PATHS="$ROOT_DIR/paths-$MEDIA_TYPE"
mkdir -p "$ROOT_DIR"
MAX_WIDTH=145

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


# extraction functions ########################################################
extract_book_display_string() {
  path="$1"
  file=$(basename "$path")
  metadata=$(awk '{ sub(/.*(ebooks\/Collections|ebooks\/Littérature|ebooks)\//, ""); print }' <<< "$path" | cut -d/ -f1)
  file=${file%.epub}
  padding=$(build_padding "$file" "$metadata" "$MAX_WIDTH")
  echo "${file}${padding}(${metadata})"
}

extract_video_display_string() {
  path="$1"
  TAGS_DUMP=$(ffprobe -hide_banner -show_format -of compact -i "$path" 2> /dev/null)
  if [[ $(echo $TAGS_DUMP | grep title=) ]]; then
    t_title=$(echo $TAGS_DUMP | sed -e 's/.*title=\([^|]*\).*/\1/')
  else
    t_title=$(awk '{ sub(/.*(Vidéos|Téléchargements|\/media\/ftp\/freebox|\/media\/duncan)\//, ""); print }' <<< "$path")
    t_title=${t_title%.*}
  fi
  if [[ $(echo $TAGS_DUMP | grep duration=) ]]; then
    t_duration=$(echo $TAGS_DUMP | sed -e 's/.*duration=\([^|\.]*\).*/\1/')
    t_duration=$(convertsecs "$t_duration")
    padding=$(build_padding "$t_title" "$t_duration" "$MAX_WIDTH")
  fi
  echo "${t_title}${padding}(${t_duration})"
}

extract_music_display_string() {
  path="$1"
  TAGS_DUMP=$(ffprobe -hide_banner -show_format -of compact -i "$path" 2> /dev/null)

  # extract each tag field (if present) from raw dump #########################
  [[ $(echo $TAGS_DUMP | grep tag:artist=) ]] && t_artist=$(echo $TAGS_DUMP | sed -e 's/.*tag:artist=\([^|]*\).*/\1/')
  [[ $(echo $TAGS_DUMP | grep tag:date=)   ]] && t_date=$(  echo $TAGS_DUMP | sed -e 's/.*tag:date=\([^|]*\).*/\1/')
  [[ $(echo $TAGS_DUMP | grep tag:album=)  ]] && t_album=$( echo $TAGS_DUMP | sed -e 's/.*tag:album=\([^|]*\).*/\1/')
  [[ $(echo $TAGS_DUMP | grep tag:track=)  ]] && t_track=$( echo $TAGS_DUMP | sed -e 's/.*tag:track=\([^|/]*\).*/\1/')
  [[ $(echo $TAGS_DUMP | grep tag:title=)  ]] && t_title=$( echo $TAGS_DUMP | sed -e 's/.*tag:title=\([^|]*\).*/\1/')
  [[ $(echo $TAGS_DUMP | grep tag:genre=)  ]] && t_genre=$( echo $TAGS_DUMP | sed -e 's/.*tag:genre=\([^|]*\).*/\1/')

  # build display string with available tag fields ############################
  # target format is: “ARTIST - DATE - ALBUM - TRACKNUMBER. TITLE”
  [[ -z $t_artist ]] || display_string="${t_artist}"
  [[ -z $t_date   ]] || display_string="${display_string} - ${t_date}"
  [[ -z $t_album  ]] || display_string="${display_string} - ${t_album}"
  [[ -z $t_track  ]] || display_string="${display_string} - ${t_track}."
  [[ -z $t_title  ]] || display_string="${display_string} ${t_title}"

  if [[ -n $t_genre ]]; then
    padding=$(build_padding "$display_string" "$t_genre" "$MAX_WIDTH")
    display_string="${display_string}${padding}(${t_genre})"
  fi
  # if no info was available, use path, starting after $ROOT_DIR #############
  if [[ -z $display_string ]]; then
    display_string=$(awk '{ sub(/.*Musique\//, ""); print }' <<< "$path")
  fi
  echo "$display_string"
}

load_files() {

  if [[ ! -f $INDEX_FILE  ]] || [[ ! -f $INDEX_DISPLAY_FILE ]]; then

    write_paths_to_tmp_file

    if [[ -s $PATHS ]]; then

      while read -r path; do
        case $MEDIA_TYPE in
          music)
            display_string=$(extract_music_display_string "$path")
            ;;
          book)
            display_string=$(extract_book_display_string "$path")
            ;;
          video)
            display_string=$(extract_video_display_string "$path")
            ;;
          *)
            echo "usage: $0 <music> | <book> | <video>"
            exit 1
            ;;
        esac
        # write display string and path in temp file ##########################
        echo "$display_string|$path" >> "$INDEX_FILE"
        echo "$display_string" >> "$INDEX_DISPLAY_FILE"
      done <"$PATHS"

      # sort temp file and write to final index file ##########################
      if [[ "$SORT" -eq 1 ]]; then
        sort --version-sort --output="$INDEX_DISPLAY_FILE" "$INDEX_DISPLAY_FILE"
      fi
    else
      echo "No files found."
      exit 1
    fi
  fi
}

# create a list for rofi to consume ###########################################
gen_list(){
  while read -r line; do
    echo -e "$line"
  done <"$INDEX_DISPLAY_FILE"
}

main() {
  load_files
  display_line=$( (gen_list) | rofi -i -theme ale-media.rasi -dmenu -no-custom -p "$PROMPT_EMOJI" )

  if [ -n "$display_line" ]; then
    while read -r line; do
      if [[ $line == *"$display_line"* ]]; then
        $EXEC_CMD "$(echo -e "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$INDEX_FILE"
  fi
}

main
exit 0
