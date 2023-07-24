##!/usr/bin/env bash

#########################
# Script run at startup #
#########################

echo "went into init.sh" > $HOME/success.txt

# keyboard & layout ###########################################################
if [ -f ~/.Xmodmap ]; then
  xmodmap ~/.Xmodmap
fi
setxkbmap fr bepo -option ctrl:nocaps compose:prsc # start in bepo using CAPS LOCK as another control key

# config souris & touchpad ####################################################
# enable vertical & horizontal scrolling on edge or with two fingers
# /usr/bin/synclient VertEdgeScroll=1
# /usr/bin/synclient VertTwoFingerScroll=1
# /usr/bin/synclient HorizEdgeScroll=1
# /usr/bin/synclient HorizTwoFingerScroll=1
# syndaemon -d -t -k # Disable touchpad while typing (Optionally add -k to allow for modifer keys so that you can do CTRL-click, for example)

# SSH keys ####################################################################
# ssh-add ~/.ssh/al.rsa # add al key to ssh keyring

# daemons & tools #############################################################
xfce4-power-manager --daemon & # battery manager
# nm-applet & # battery manager (used to be nm-applet)
# wicd-gtk & # battery manager (used to be nm-applet)
# xscreensaver & # screen saver daemon
compton -b & # use compton 3D acceleration
parcellite & # clipboard
# conky & # monitoring
# emacs --no-window-system --daemon & # start emacs in daemon mode

# bluetooth ###################################################################
# pactl load-module module-bluetooth-discover & # activate bluetooth (does not seem to work)
# blueman-applet # launch bluetooth applet

# applications ################################################################
lxterminal & # start a terminal window
