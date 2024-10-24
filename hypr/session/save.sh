#!/bin/bash

# Directory for session data
SESSION_DIR="$HOME/.config/hypr/session"
mkdir -p "$SESSION_DIR"

# Save current window information
hyprctl clients -j > "$SESSION_DIR/windows.json"

# Parse the JSON and create a restore script
python3 - <<EOF > "$SESSION_DIR/restore.sh"
import json
import sys
from pathlib import Path

session_file = Path("$SESSION_DIR/windows.json")
with session_file.open() as f:
    windows = json.load(f)

def get_workspace_sort_key(window):
    workspace = window.get('workspace', {})
    if workspace.get('name') == '12':
        return 12
    return workspace.get('id', 0)

# Group windows by monitor
windows_by_monitor = {}
for window in windows:
    monitor = window.get('monitor', 0)
    if monitor not in windows_by_monitor:
        windows_by_monitor[monitor] = []
    windows_by_monitor[monitor].append(window)

# Sort windows within each monitor by workspace
for monitor in windows_by_monitor:
    windows_by_monitor[monitor].sort(key=get_workspace_sort_key)

# Only track Cursor since it has its own session management
cursor_launched = False

# Process each monitor's windows
for monitor in sorted(windows_by_monitor.keys()):
    print(f'# Switching to monitor {monitor}')
    print(f'hyprctl dispatch focusmonitor {monitor}')
    print('sleep 0.5')
    
    current_workspace = None
    
    for window in windows_by_monitor[monitor]:
        # Get relevant window properties
        class_name = window.get('class', '')
        workspace = window.get('workspace', {}).get('name', '1')
        floating = window.get('floating', False)
        size = window.get('size', [800, 600])
        at = window.get('at', [0, 0])
        
        # Skip certain applications that shouldn't be restored
        if class_name.lower() in ['waybar', 'rofi']:
            continue
        
        # Switch workspace if needed
        if workspace != current_workspace:
            print(f'hyprctl dispatch workspace {workspace}')
            current_workspace = workspace
            print('sleep 0.5')
        
        # Handle different applications
        if class_name == 'Cursor' and not cursor_launched:
            print(f'/home/dei/Downloads/cursor-0.42.3x86_64.AppImage &')
            cursor_launched = True
            print('sleep 3')
        elif class_name == 'Cursor':
            continue
        elif class_name == 'Vivaldi-stable':
            print(f'vivaldi-stable &')
        elif class_name == 'vesktop':
            print(f'vesktop &')
        elif class_name == 'jetbrains-studio':
            print(f'android-studio &')
        elif class_name == 'org.gnome.SystemMonitor':
            print(f'gnome-system-monitor &')
        else:
            print(f'# Unhandled application: {class_name}')
            print(f'{class_name.lower()} &')
            
        if floating:
            print(f'sleep 0.5')
            print(f'hyprctl dispatch togglefloating address:latest')
            print(f'hyprctl dispatch movewindowpixel exact {at[0]} {at[1]} address:latest')
            print(f'hyprctl dispatch resizewindowpixel exact {size[0]} {size[1]} address:latest')
        
        print('sleep 1')
EOF

chmod +x "$SESSION_DIR/restore.sh"