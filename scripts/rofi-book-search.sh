#!/usr/bin/env bash

source "rofi-utils.sh"

# Books directory
BOOKS_DIR="$HOME/ebooks"
EBOOK_INDEX="$BOOKS_DIR/.index"
PATHS="/tmp/paths"
mkdir -p "$BOOKS_DIR"

write_paths_to_file (){
  find "$BOOKS_DIR" -type f -name '*.epub' > "$1"
}

extract_book_infos(){
  path="$1"

  # path="/home/duncan/ebooks/Collections/Science-fiction:Anticipation:Fantastique/Brussolo, Serge/Vue en coupe d'une ville malade - Serge Brussolo.epub"
  # path="/home/duncan/ebooks/Calibre/Ruth Ozeki/Mon epouse americaine (1209)/Mon epouse americaine - Ruth Ozeki.epub"
  # path="/home/duncan/ebooks/Bibli-kobo/Paul Lafargue/Le droit a la paresse - Refutation du __ droit au travail __ de 1848 (494)/Le droit a la paresse - Refutation du __ d - Paul Lafargue.epub"

  file=$(basename "$path")
  metadata=$(awk '{ sub(/.*(ebooks\/Collections|ebooks\/Littérature|ebooks)\//, ""); print }' <<< "$path" | cut -d/ -f1)
  file=${file%.epub}
  padding=$(build_padding "$file" "$metadata" 145)
  infos="${file}${padding}(${metadata})"
  echo "$infos"
}

load_books() {

  if [[ ! -f $EBOOK_INDEX ]]; then

    write_paths_to_file $PATHS

    if [[ -s $PATHS ]]; then

      # create temp file ######################################################
      EBOOK_INDEX_TMP="/tmp/.index_books"
      true > $EBOOK_INDEX_TMP

      while read -r path; do
        infos=$(extract_book_infos "$path")
        # write display string and path in temp file ##########################
        echo "${infos}|${path}" >> "$EBOOK_INDEX"
      done <"$PATHS"

      # sort temp file and write to final index file ##########################
      # sort $EBOOK_INDEX_TMP > $EBOOK_INDEX
      rm -f $EBOOK_INDEX_TMP
    else
      echo "$BOOKS_DIR is empty!"
      echo "Please put some books in it."
      echo "Only .epubs files are considered books."
      exit 1
    fi
  fi
}

# create a list for rofi to consume ###########################################
gen_list(){
  load_books
  while read -r line; do
    echo -e "$line"
  done <"$EBOOK_INDEX"
}

main() {
  books=$(gen_list)
  book=$( echo -e "$books" | cut -d\| -f1 | rofi -i -theme repos/dotfiles/rofi/media.rasi -dmenu -no-custom -p "📚" )
  if [ -n "$book" ]; then
    while read -r line; do
      if [[ $line == *"$book"* ]]; then
        ebook-viewer "$(echo "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$EBOOK_INDEX"

  fi
}

main
exit 0
