#!/usr/bin/env bash

WORKSPACE="$1"
[[ $WORKSPACE ]] || WORKSPACE="$HOME/outils/eclipse/workspaces/enercoop-coopener-v5"
# $HOME/outils/eclipse/workspaces/xxx
export ECLIPSE_BINARY="$HOME/outils/eclipse/jee-2022-12/eclipse/eclipse"
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus

# export SWT_GTK3=0
# export GTK2_RC_FILES=~/.gtkrc-2.0-gnome-color-chooser

source ${SDKMAN_DIR}/bin/sdkman-init.sh
sdk use java $JAVA_17_VERSION

$ECLIPSE_BINARY

# EOF
