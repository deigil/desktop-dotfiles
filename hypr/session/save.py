#!/usr/bin/env python3
import json
from pathlib import Path
import sys
import shutil

# Directory for session data
SESSION_DIR = Path.home() / ".config/hypr/session"

# Mapping of window classes to executable commands
CLASS_EXEC_MAP = {
    'org.prismlauncher.PrismLauncher': 'prismlauncher',
    'org.rncbc.qpwgraph': '/usr/bin/qpwgraph',
    'vesktop': str(Path.home() / ".config/vesktop/vesktop-launch.sh"),
    'Vivaldi-stable': 'vivaldi-stable',
    'vivaldi-stable': 'vivaldi-stable',
    'jetbrains-studio': 'android-studio',
    'org.gnome.SystemMonitor': 'gnome-system-monitor',
    'Spotify': 'spotify',
    'p3x-onenote': 'p3x-onenote',
    'Cursor': '/home/dei/Downloads/cursor-0.43.4-build-241126w13goyvrs-x86_64.AppImage',
    'cursor-url-handler': '/home/dei/Downloads/cursor-0.43.4-build-241126w13goyvrs-x86_64.AppImage'
}

def find_executable(command):
    """Find the full path of an executable."""
    if command.startswith('/'):
        return command
    return shutil.which(command) or command

def generate_vivaldi_commands():
    """Generate commands for Vivaldi browser profiles."""
    vivaldi = find_executable('vivaldi-stable')
    commands = "\n# Launch Vivaldi profiles\n"
    
    # Default profile in workspace 1
    commands += "\n# Default profile - workspace 1\n"
    commands += "hyprctl dispatch focusmonitor 1\n"
    commands += "hyprctl dispatch workspace 1\n"
    commands += f"{vivaldi} --profile-directory='Default' &\n"
    commands += "sleep 5\n"
    
    # Work profile in workspace 2
    commands += "\n# Work profile - workspace 2\n"
    commands += "hyprctl dispatch workspace 2\n"
    commands += f"{vivaldi} --profile-directory='Profile 3' &\n"
    commands += "sleep 5\n"
    
    # School profile in workspace 3
    commands += "\n# School profile - workspace 3\n"
    commands += "hyprctl dispatch workspace 3\n"
    commands += f"{vivaldi} --profile-directory='Profile 1' &\n"
    commands += "sleep 5\n"
    
    return commands

def generate_restore_script(windows):
    script = "#!/bin/bash\n\n# Generated restore script\n\n"
    
    # Handle Cursor first if present
    cursor_windows = [w for w in windows if w['class'] == 'cursor-url-handler']
    if cursor_windows:
        script += "# Launch Cursor and wait for windows\n"
        script += "hyprctl dispatch workspace 1\n"
        script += f"{find_executable(CLASS_EXEC_MAP['cursor-url-handler'] or CLASS_EXEC_MAP['Cursor'])} &\n"
        script += "sleep 5\n\n"
        
        for window in cursor_windows:
            script += f"# Move Cursor window to workspace {window['workspace']['id']}\n"
            script += f"hyprctl dispatch movetoworkspace {window['workspace']['id']},title:'{window['title']}'\n"
            script += f"hyprctl dispatch movewindowpixel exact {window['at'][0]} {window['at'][1]} title:'{window['title']}'\n"
            script += f"hyprctl dispatch resizewindowpixel exact {window['size'][0]} {window['size'][1]} title:'{window['title']}'\n\n"
    
    # Handle other applications
    current_monitor = None
    current_workspace = None
    launched_apps = set()
    
    # Filter and sort windows by monitor and workspace
    other_windows = [w for w in windows if w['class'] in CLASS_EXEC_MAP and w['class'] != 'cursor-url-handler']
    other_windows.sort(key=lambda w: (w['monitor'], w['workspace']['id']))
    
    for window in other_windows:
        if window['monitor'] != current_monitor:
            script += f"# Switching to monitor {window['monitor']}\n"
            script += f"hyprctl dispatch focusmonitor {window['monitor']}\n"
            script += "sleep 1\n\n"
            current_monitor = window['monitor']
        
        if window['workspace']['id'] != current_workspace:
            script += f"# Switching to workspace {window['workspace']['id']}\n"
            script += f"hyprctl dispatch workspace {window['workspace']['id']}\n"
            script += "sleep 1\n"
            current_workspace = window['workspace']['id']
        
        app_class = window['class']
        if app_class not in launched_apps:
            script += f"# Launching {app_class}\n"
            script += f"{find_executable(CLASS_EXEC_MAP[app_class])} &\n"
            # Special case for vesktop
            if app_class == 'vesktop':
                script += "sleep 7\n"
            else:
                script += "sleep 3\n"
            launched_apps.add(app_class)
        
        script += f"hyprctl dispatch movewindowpixel exact {window['at'][0]} {window['at'][1]} address:latest\n"
        script += f"hyprctl dispatch resizewindowpixel exact {window['size'][0]} {window['size'][1]} address:latest\n\n"
    
    # Add Vivaldi profile launches at the end
    script += generate_vivaldi_commands()
    
    return script

def restore_session():
    try:
        with (SESSION_DIR / "windows.json").open() as f:
            windows = json.load(f)
        
        script = generate_restore_script(windows)
        
        with (SESSION_DIR / "restore.sh").open('w') as f:
            f.write(script)
        
        print("Successfully generated restore.sh", file=sys.stderr)
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    restore_session()