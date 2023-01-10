#!/usr/bin/env bash

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

emacsclient -s gnu -c -a '' -e "(progn (org-capture nil \"w\"))"

# EOF
