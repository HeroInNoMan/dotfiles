#!/bin/bash

# Location of Firefox bookmarks file
# BOOKMARKS_FILE=~/.mozilla/firefox/*.default-release/places.sqlite
BOOKMARKS_FILE=~/.mozilla/firefox/0p6v57in.default/places.sqlite

# Query to extract bookmarks with icons
# QUERY="SELECT moz_bookmarks.title, moz_places.url, moz_icons.icon_uri FROM moz_bookmarks JOIN moz_places ON moz_bookmarks.fk = moz_places.id LEFT JOIN moz_icons ON moz_bookmarks.fk = moz_icons.icon_id WHERE moz_bookmarks.title IS NOT NULL AND moz_places.url IS NOT NULL"
QUERY="SELECT moz_bookmarks.id, moz_bookmarks.parent, moz_bookmarks.type, moz_bookmarks.title, moz_places.url FROM moz_bookmarks LEFT JOIN moz_places ON moz_bookmarks.fk=moz_places .id"

# Extract bookmarks using sqlite3
BOOKMARKS=$(sqlite3 "$BOOKMARKS_FILE" "$QUERY")

# Filter out the headers from the SQLite output
BOOKMARKS=${BOOKMARKS/*title|url|icon_uri/}

# Format bookmarks for rofi using awk
ROFI_DATA=$(echo "$BOOKMARKS" | awk -F "|" '{ print $2 " " $1 " " $3 }')

# Serve bookmarks in rofi
echo "$ROFI_DATA" | rofi -dmenu -i -p "Bookmarks" -no-custom -format "i" -columns 1 -lines 10 -markup-rows -matching fuzzy -tokenize -sort -show-icons -kb-accept-entry "Return" | awk '{ print $NF }'

# Exit script
exit 0
