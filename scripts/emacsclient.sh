#!/usr/bin/env bash

if [ "wayland" != $XDG_SESSION_TYPE ]; then
  export GTK_IM_MODULE=xim
  export QT_IM_MODULE=xim
fi

DEFAULT_PROFILE="gnu" # doom | spacemacs | centaur | nano
PROFILE_FILE="$HOME/.emacs-profile"

if [[ $# -gt 0 ]]; then
  PROFILE=$1
  shift
  echo "using $PROFILE profile (parameter given)"
elif [[ -f  "$PROFILE_FILE" ]]; then
  PROFILE=$(head -1 $PROFILE_FILE | tr -d '\n')
  echo "using $PROFILE profile (as in $PROFILE_FILE)"
else
  PROFILE=$DEFAULT_PROFILE
  echo "using $PROFILE profile (by default)"
fi
if [[ $# -gt 0 ]]; then
  ELISP_COMMAND=$@
else
  ELISP_COMMAND="(dash-or-scratch)"
fi
emacsclient -c -a '' -s "$PROFILE" -e "$ELISP_COMMAND"
# EOF
