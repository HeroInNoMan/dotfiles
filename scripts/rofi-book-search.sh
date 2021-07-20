#!/usr/bin/env bash

# Books directory
BOOKS_DIR="$HOME/ebooks"
EBOOKS_INDEX="$BOOKS_DIR/.index"
mkdir -p "$BOOKS_DIR"

# Associative array for storing books
# key => book name
# value => absolute path to the file
# BOOKS['filename']='path'
# declare -A BOOKS

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

# Add elements to BOOKS array
load_books() {

  if [[ ! -f $EBOOKS_INDEX ]]; then
    # Save find result to F_ARRAY
    readarray -t F_ARRAY <<< "$(find "$BOOKS_DIR" -type f -name '*.epub')"
    if [[ ! -z ${F_ARRAY[@]} ]]; then
      for i in "${!F_ARRAY[@]}"
      do
        path=${F_ARRAY[$i]}

        # path="/home/duncan/ebooks/Collections/Science-fiction:Anticipation:Fantastique/Brussolo, Serge/Vue en coupe d'une ville malade - Serge Brussolo.epub"
        # path="/home/duncan/ebooks/Calibre/Ruth Ozeki/Mon epouse americaine (1209)/Mon epouse americaine - Ruth Ozeki.epub"
        # path="/home/duncan/ebooks/Bibli-kobo/Paul Lafargue/Le droit a la paresse - Refutation du __ droit au travail __ de 1848 (494)/Le droit a la paresse - Refutation du __ d - Paul Lafargue.epub"
        file=$(basename "$path")
        metadata=$(awk '{ sub(/.*(ebooks\/Collections|ebooks\/Littérature|ebooks)\//, ""); print }' <<< "$path" | cut -d/ -f1)
        file=${file%.epub}
        echo "metadata: $metadata"
        echo "file: $file"

        padding=$(build_padding "$file" "$metadata" 145)


        echo "${file}${padding}(${metadata})|${path}" >> "$EBOOKS_INDEX"
      done
    else
      echo "$BOOKS_DIR is empty!"
      echo "Please put some books in it."
      echo "Only .epubs files are considered books."
      exit 1
    fi
  fi
}

# List for rofi
gen_list(){
  while read -r line; do
    echo -e "$line"
  done <"$EBOOKS_INDEX"
}

main() {
  load_books
  books=$(gen_list)
  book=$( echo -e "$books" | cut -d\| -f1 | rofi -i -theme repos/dotfiles/rofi/media.rasi -dmenu -no-custom -p "📚" )
  if [ -n "$book" ]; then
    while read -r line; do
      if [[ $line == *"$book"* ]]; then
        ebook-viewer "$(echo "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$EBOOKS_INDEX"

  fi
}

main
exit 0
