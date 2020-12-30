#!/bin/sh
xrandr \
  --output eDP-1  --mode 1920x1080 --pos 0x172    --rotate normal \
  --output HDMI-1 --mode 1920x1080 --pos 1920x172 --rotate normal --primary \
  --output HDMI-2 --off \
  --output DP-1   --off \
  --output DP-2   --mode 1920x1080 --pos 3840x0   --rotate right \
