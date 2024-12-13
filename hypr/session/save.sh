#!/bin/bash

# Directory for session data
SESSION_DIR="$HOME/.config/hypr/session"
mkdir -p "$SESSION_DIR"

# Save current window information, excluding Vivaldi windows
hyprctl clients -j | jq '[.[] | select(.class != "Vivaldi-stable")]' > "$SESSION_DIR/windows.json"

# Run the Python script to generate restore.sh
python3 "$SESSION_DIR/save.py"

# Make restore script executable
chmod +x "$SESSION_DIR/restore.sh"

echo "Session saved successfully."