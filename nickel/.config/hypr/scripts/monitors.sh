#!/bin/bash

# Get list of connected monitors
MONS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

if echo "$MONS" | grep -q "HDMI-A-1"; then
  # If HDMI is connected → enable it and disable laptop
  hyprctl keyword monitor "HDMI-A-1,preferred,auto,auto"
  hyprctl keyword monitor "eDP-1,disable"
else
  # Otherwise → only use laptop screen
  hyprctl keyword monitor "eDP-1,preferred,auto,1.2"
  hyprctl keyword monitor "HDMI-A-1,disable"
fi
