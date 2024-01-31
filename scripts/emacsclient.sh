#!/usr/bin/env bash

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

DEFAULT_PROFILE="gnu" # doom | spacemacs | centaur | nano
PROFILE_FILE="$HOME/.emacs-profile"
EXECUTE='-e "(dash-or-scratch)"'

if [[ $# -gt 0 ]]; then
  PROFILE=$1
echo "using argument"
elif [[ -f  "$PROFILE_FILE" ]]; then
  PROFILE=$(head -1 $PROFILE_FILE | tr -d '\n')
  echo "using $PROFILE as in $PROFILE_FILE"
else
  PROFILE=$DEFAULT_PROFILE
  echo "using $PROFILE by default"
fi

emacsclient -c -a '' $EXECUTE -s $PROFILE
# EOF
