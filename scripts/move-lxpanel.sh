#!/usr/bin/env bash

# find number of monitors
NB_DISPLAYS=$(xrandr --query | grep --count ' connected')

# get current lxpanel monitor number
PANEL_CONFIG_FILE=$HOME/.config/lxpanel/default/panels/panel

if [[ ! -f $PANEL_CONFIG_FILE ]]; then
  PANEL_CONFIG_FILE=$HOME/repos/dotfiles/lxpanel/LXDE/panels/panel
fi

if [[ ! -f $PANEL_CONFIG_FILE ]]; then
  PANEL_CONFIG_FILE=$HOME/.config/lxpanel/LXDE/panels/panel
fi

CURRENT_MONITOR_NUMBER=$(grep "monitor=[0-9]" $PANEL_CONFIG_FILE | cut -d '=' -f2)

# change
NEW_MONITOR=$((($CURRENT_MONITOR_NUMBER + 1) % $NB_DISPLAYS))
sed -i "s/monitor=$CURRENT_MONITOR_NUMBER/monitor=$NEW_MONITOR/" $PANEL_CONFIG_FILE
echo "Switching panel from display #$CURRENT_MONITOR_NUMBER to #$NEW_MONITOR ($NB_DISPLAYS displays found in total)"

# apply changes
lxpanelctl restart
