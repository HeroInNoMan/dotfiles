#!/usr/bin/env bash

SERVER_NAME=$(head -1 "$HOME/.emacs-profile" | tr -d '\n')
emacsclient.sh $SERVER_NAME "(progn \
               (setq newframe-capture t)
               (org-capture nil \"w\") \
               (delete-other-windows))"

# EOF
