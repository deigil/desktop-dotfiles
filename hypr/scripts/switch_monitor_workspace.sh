#!/bin/bash

# Usage: ./switch_monitor_workspace.sh <monitor_name> <workspace_number>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <monitor_name> <workspace_number>"
    exit 1
fi

monitor="$1"
workspace=$2

# Get the current workspace on the specified monitor
current_workspace=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$monitor\") | .activeWorkspace.id")

# Close all windows in the current workspace on the specified monitor
hyprctl dispatch closewindow "workspace:${current_workspace}"

# Focus the specified monitor
hyprctl dispatch focusmonitor "$monitor"

# Switch to the specified workspace
hyprctl dispatch workspace "$workspace"

# Ensure the workspace is on the correct monitor
hyprctl dispatch moveworkspacetomonitor "$workspace" "$monitor"
