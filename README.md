# My Dotfiles and Configs

This repository contains a curated selection of my personal dotfiles and configuration files for various tools and applications I use in my development and desktop environment. It showcases a highly customized multi-monitor Hyprland setup with advanced workspace management and session restoration.

## Key Features

- Advanced Hyprland setup with multi-monitor support and workspace management
- Sophisticated session management and restoration system
- Customized Waybar configuration with multi-monitor awareness
- Sophisticated scripts for workspace and monitor control
- OneDrive integration for cloud storage synchronization
- Spicetify customizations for a personalized Spotify experience
- Sunshine configuration for game streaming

## 🌟 Highlights 🌟

### 1. Session Management and Restoration

The crown jewel of this configuration is the advanced session management and restoration system:

```
📌 Automatic session state saving:
   - Window positions and sizes
   - Active workspaces on each monitor
   - Running applications

🔄 On-demand or startup session restoration

🧠 Intelligent application-specific restoration logic

🔒 Consistent work environment across reboots or restarts
```

### 2. Multi-Monitor Workspace Management

A sophisticated multi-monitor workspace management system:

```
🖥️ Monitor-specific workspace assignments:
   - Main monitor (DP-4): Workspaces 1-10
   - Secondary monitor (DP-5): Workspace 11
   - Tertiary monitor (HDMI-A-2): Workspace 12

🛡️ Accidental workspace switching prevention on secondary monitors

🧭 Intelligent window placement and movement across monitors
```

## Installation

1. Clone this repository:
   ```
   git clone git@github.com:yourusername/dotfiles.git
   ```
2. Symlink or copy the configuration files to their respective locations in your home directory.
3. Ensure all required scripts are executable, especially those in `/hypr/scripts/`.

## Usage

Each directory contains configurations for specific applications. To use them:

1. Ensure you have the corresponding application installed.
2. Copy or symlink the configuration files to the appropriate location on your system.
3. Pay special attention to the Hyprland configuration and associated scripts.
4. Restart the application or reload its configuration as needed.

## Custom Scripts

- `save.sh`: Saves the current session state
- `restore.sh`: Restores the saved session state
- `workspace_manager.sh`: Manages workspace switching based on the active monitor
- `switch_monitor_workspace.sh`: Allows switching workspaces on specific monitors while closing previous windows

## Notes

- These configurations are tailored for a specific multi-monitor setup. Adjust monitor names and resolutions in `hyprland.conf` to match your setup.
- The workspace management system is designed for a three-monitor setup with specific use cases for each monitor.
- Always backup your existing configurations before replacing them with these.

## Contributing

While these are my personal configurations, I'm open to suggestions and improvements, especially regarding session management, multi-monitor setups, and workspace management. Feel free to open issues or submit pull requests if you have ideas or find any bugs.

## License

This project is open-source and available under the [MIT License](LICENSE).
