#!/usr/bin/env bash

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

emacsclient -c -a '' -e "(dash-or-scratch)"

# EOF
