#!/usr/bin/env bash

workspace=$1

# Get the current monitor
current_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

# Define allowed workspaces for each monitor
case "$current_monitor" in
    "DP-5")
        allowed_workspace=11
        ;;
    "HDMI-A-2")
        allowed_workspace=12
        ;;
    "DP-4")
        allowed_workspace=$workspace
        ;;
    *)
        allowed_workspace=$workspace
        ;;
esac

# Switch to the allowed workspace
hyprctl dispatch workspace $allowed_workspace