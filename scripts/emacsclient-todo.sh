#!/usr/bin/env bash

emacsclient.sh gnu "(progn \
(setq external-capture t) \
 (org-capture nil \"w\") \
 (delete-other-windows))"

# EOF
