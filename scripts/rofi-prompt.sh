#!/usr/bin/env bash
#
# Rofi powered menu to prompt a message and get a yes/no answer.
# Uses: rofi

yes=$(echo -e "✅\tConfirm")
no=$(echo -e "❌\tCancel")
query='Are you sure?'

while [ $# -ne 0 ]; do
  case "$1" in
    -y | --yes)
      [ -n "$2" ] && yes="$2" || yes=''
      shift
      ;;

    -n | --no)
      [ -n "$2" ] && no="$2" || no=''
      shift
      ;;

    -q | --query)
      [ -n "$2" ] && query="$2"
      shift
      ;;
  esac
  shift
done

chosen=$(printf '%s;%s\n' "$yes" "$no" \
           | rofi -theme 'repos/dotfiles/rofi/prompt.rasi' \
                  -p "$query" \
                  -dmenu \
                  -sep ';' \
                  -i \
                  -a 0 \
                  -u 1 \
                  -no-custom \
                  -selected-row 1)

case "$chosen" in
  "$yes") exit 0 ;;
  *)  exit 1 ;;
esac
