#!/bin/bash

# Directory for session data
SESSION_DIR="$HOME/.config/hypr/session"
mkdir -p "$SESSION_DIR"

# Save current window information
hyprctl clients -j > "$SESSION_DIR/windows.json"

# Parse the JSON and create a restore script
python3 - <<EOF > "$SESSION_DIR/restore.sh"
import json
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

# Track launched applications
cursor_launched = False
vivaldi_launched = False
studio_launched = False

# Process each monitor's windows
for monitor in sorted(windows_by_monitor.keys()):
    print(f'# Switching to monitor {monitor}')
    print(f'hyprctl dispatch focusmonitor {monitor}')
    print('sleep 0.5')
    
    current_workspace = None
    
    for window in windows_by_monitor[monitor]:
        # Get relevant window properties
        class_name = window.get('class', '')
        title = window.get('title', '')
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
        if class_name == 'Cursor':
            if not cursor_launched:
                print(f'/home/dei/Downloads/cursor-0.42.3x86_64.AppImage &')
                cursor_launched = True
                print('sleep 5')
            print(f'hyprctl dispatch movetoworkspacesilent {workspace},title:"{title}"')
        elif class_name == 'Vivaldi-stable':
            # Determine which profile to use based on the window title/content
            if any(keyword in title for keyword in ["Illinois Institute", "blackboard", "iit.edu"]):
                profile = "Profile 1"  # School profile
                if "Calendar" in title:
                    url = "https://calendar.google.com"
                else:
                    url = "about:blank"  # or specific IIT URL
            elif any(keyword in title for keyword in ["Zoho", "Invoice", "INV-", "xpressauto"]):
                profile = "Profile 3"  # Work profile
                if "Zoho Books" in title:
                    url = "https://books.zoho.com"
                else:
                    url = "about:blank"  # or specific work URL
            else:
                # Personal profile for everything else (Gmail, GitHub, etc.)
                profile = "Default"
                if "Gmail" in title:
                    url = "https://mail.google.com"
                elif "github" in title.lower():
                    url = "https://github.com/deigil"
                else:
                    url = "about:blank"

            print(f'vivaldi-stable --profile-directory="{profile}" "{url}" &')
            print(f'sleep 2')
            print(f'for i in {{1..20}}; do')
            print(f'    if hyprctl clients | grep -q "Vivaldi-stable"; then')
            print(f'        hyprctl dispatch movetoworkspacesilent {workspace},class:Vivaldi-stable')
            print(f'        break')
            print(f'    fi')
            print(f'    sleep 0.5')
            print(f'done')
        elif class_name == 'vesktop':
            print(f'vesktop &')
        elif class_name == 'jetbrains-studio':
            if not studio_launched:
                print(f'android-studio &')
                studio_launched = True
                print(f'# Wait for Android Studio to fully launch')
                print(f'for i in {{1..60}}; do')
                print(f'    if hyprctl clients | grep -q "jetbrains-studio"; then')
                print(f'        break')
                print(f'    fi')
                print(f'    sleep 1')
                print(f'done')
            print(f'hyprctl dispatch movetoworkspacesilent {workspace},class:jetbrains-studio')
        elif class_name == 'org.gnome.SystemMonitor':
            print(f'gnome-system-monitor &')
        elif class_name == 'Spotify':
            print(f'spotify &')
        else:
            # Generic handling for other applications
            print(f'# Launching {class_name}')
            print(f'if command -v {class_name.lower()} &> /dev/null; then')
            print(f'    {class_name.lower()} &')
            print(f'elif command -v flatpak &> /dev/null && flatpak list --app | grep -qi {class_name}; then')
            print(f'    flatpak run $(flatpak list --app | grep -i {class_name} | awk \'{{print $2}}\')')
            print(f'else')
            print(f'    echo "Unable to launch {class_name}, please install it or add it to the script manually"')
            print(f'fi')

        # Position the window
        print(f'sleep 0.5')
        if floating:
            print(f'hyprctl dispatch togglefloating address:latest')
        print(f'hyprctl dispatch movewindowpixel exact {at[0]} {at[1]} address:latest')
        print(f'hyprctl dispatch resizewindowpixel exact {size[0]} {size[1]} address:latest')
        
        print('sleep 1')
EOF

chmod +x "$SESSION_DIR/restore.sh"
