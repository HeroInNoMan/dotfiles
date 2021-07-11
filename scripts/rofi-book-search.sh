#!/usr/bin/env bash

# Books directory
BOOKS_DIR="$HOME/ebooks"
mkdir -p $BOOKS_DIR

# Save find result to F_ARRAY
readarray -t F_ARRAY <<< "$(find "$BOOKS_DIR" -type f -name '*.epub')"

# Associative array for storing books
# key => book name
# value => absolute path to the file
# BOOKS['filename']='path'
declare -A BOOKS

# Add elements to BOOKS array
get_books() {

  # if [ ${#F_ARRAY[@]} != 0 ]; then
  if [[ ! -z ${F_ARRAY[@]} ]]; then
    for i in "${!F_ARRAY[@]}"
    do
      path=${F_ARRAY[$i]}
      file=$(basename "${F_ARRAY[$i]}")
      file=${file%.epub}
      BOOKS+=(["$file"]="$path")
    done
  else
    echo "$BOOKS_DIR is empty!"
    echo "Please put some books in it."
    echo "Only .epubs files are considered books."
    exit 1
  fi
}

# List for rofi
gen_list(){
  for i in "${!BOOKS[@]}"
  do
    echo "$i"
  done
}

main() {
  get_books
  book=$( (gen_list) | rofi -dmenu -i -no-custom -location 6 -lines 30 -width 60 -columns 1 -p "Book > " )

  if [ -n "$book" ]; then
    xdg-open "${BOOKS[$book]}"
  fi
}

main

exit 0
