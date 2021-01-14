#!/usr/bin/env bash

# Nettoie les sockets (cf.
# https://www.blog-libre.org/2019/05/11/loption-controlmaster-de-ssh_config/)
# pour éviter les problèmes avec ControlMaster dans la config ssh.

for socket in $(find ~/.ssh/sockets/ -type s); do
  ssh -o ControlPath=$socket -O exit toto 2>/dev/null || rm $socket
done

#EOF
