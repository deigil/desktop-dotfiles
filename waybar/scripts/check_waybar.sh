#!/bin/bash

# Check if Waybar is running
if ! pgrep -x "waybar" > /dev/null; then
    # If not running, restart Waybar
    hyprctl dispatch exec waybar
fi