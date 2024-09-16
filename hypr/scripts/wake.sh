#!/bin/bash

# Function to run a command with a timeout
run_with_timeout() {
    timeout 5s $@ &
    wait $!
}

# Restart Waybar if it's not running
if ! pgrep -x "waybar" > /dev/null; then
    run_with_timeout killall waybar
    run_with_timeout hyprctl dispatch exec waybar
fi

# Set your PulseAudio profile
run_with_timeout pactl set-card-profile alsa_card.pci-0000_0a_00.1 output:hdmi-stereo+output:hdmi-stereo-extra1

# Exit the script
exit 0