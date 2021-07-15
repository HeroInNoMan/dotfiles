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

# Add elements to BOOKS array
load_books() {

  if [[ ! -f $EBOOKS_INDEX ]]; then
    # Save find result to F_ARRAY
    readarray -t F_ARRAY <<< "$(find "$BOOKS_DIR" -type f -name '*.epub')"
    if [[ ! -z ${F_ARRAY[@]} ]]; then
      for i in "${!F_ARRAY[@]}"
      do
        path=${F_ARRAY[$i]}
        file=$(basename "${F_ARRAY[$i]}")
        file=${file%.epub}
        echo "$file|$path" >> "$EBOOKS_INDEX"
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
        xdg-open "$(echo "$line" | cut -d\| -f2)"
        exit 0
      fi
    done <"$EBOOKS_INDEX"

  fi
}

main
exit 0
