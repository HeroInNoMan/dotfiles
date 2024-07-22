#!/usr/bin/env bash

# LETTER=t # t for personal TODO
LETTER=w # w for work TODO
SERVER_NAME=$(head -1 "$HOME/.emacs-profile" | tr -d '\n')
emacsclient.sh $SERVER_NAME "(progn \
               (setq newframe-capture t) \
               (org-capture nil \""$LETTER"\") \
               (delete-other-windows))"
# EOF
