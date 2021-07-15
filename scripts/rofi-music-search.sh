#!/usr/bin/env bash

# Music directory
MUSIC_DIR="$HOME/Musique"
MUSIC_INDEX="$MUSIC_DIR/.index"
MUSIC_INDEX_DISPLAY="$MUSIC_DIR/.index-display"
PATHS="/tmp/paths"
mkdir -p $MUSIC_DIR

write_paths_to_file() {
  find "$MUSIC_DIR" -type f \
       -iname '*.mp3'  \
       -o -iname '*.flac' \
       -o -iname '*.m3u'  \
       -o -iname '*.m4a'  \
       -o -iname '*.mp4'  \
       -o -iname '*.mpc'  \
       -o -iname '*.mpg'  \
       -o -iname '*.wav'  \
       -o -iname '*.wma'  \
       -o -iname '*.wmv'  \
       > "$1"
}

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

extract_track_info() {
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
  [[ -z $t_artist ]] || t_infos="${t_artist}"
  [[ -z $t_date   ]] || t_infos="${t_infos} - ${t_date}"
  [[ -z $t_album  ]] || t_infos="${t_infos} - ${t_album}"
  [[ -z $t_track  ]] || t_infos="${t_infos} - ${t_track}."
  [[ -z $t_title  ]] || t_infos="${t_infos} ${t_title}"

  if [[ -n $t_genre ]]; then
    padding=$(build_padding "$t_infos" "$t_genre" 145)
    t_infos="${t_infos}${padding}(${t_genre})"
  fi
  # if no info was available, use path, starting after $MUSIC_DIR #############
  if [[ -z $t_infos ]]; then
    t_infos=$(awk '{ sub(/.*Musique\//, ""); print }' <<< "$path")
  fi
  echo "$t_infos"
}

load_music() {

  if [[ ! -f $MUSIC_INDEX ]]; then

    write_paths_to_file $PATHS

    if [[ -s $PATHS ]]; then

      # create temp file ######################################################
      MUSIC_INDEX_TMP="/tmp/.index_tracks"
      true > $MUSIC_INDEX_TMP

      while read -r path; do
        t_infos=$(extract_track_info "$path")
        # write display string and path in temp file ##########################
        echo "$t_infos|$path" >> "$MUSIC_INDEX"
        echo "$t_infos" >> "$MUSIC_INDEX_TMP"
      done <"$PATHS"

      # sort temp file and write to final index file ##########################
      sort --version-sort "$MUSIC_INDEX_TMP" > "$MUSIC_INDEX_DISPLAY"

    else
      echo "No music found."
      exit 1
    fi
  fi
}

# create a list for rofi to consume ###########################################
gen_list(){
  load_music
  while read -r line; do
    echo -e "$line"
  done <"$MUSIC_INDEX_DISPLAY"
}

main() {
  track=$( (gen_list) | rofi -i -theme repos/dotfiles/rofi/media.rasi -dmenu -no-custom -p "🎶" )

  if [ -n "$track" ]; then
    while read -r line; do
      if [[ $line == *"$track"* ]]; then
        audacious -E "$(echo -e "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$MUSIC_INDEX"
  fi
}

main
exit 0
