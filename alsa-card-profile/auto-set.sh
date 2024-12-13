#!/bin/bash

# Delete the existing custom HDMI configuration
sudo rm /usr/share/alsa-card-profile/mixer/profile-sets/9999-custom.conf

# Create a symbolic link to the custom configuration
sudo ln -s /home/dei/.config/alsa-card-profile/mixer/profile-sets/9999-custom.conf /usr/share/alsa-card-profile/mixer/profile-sets/9999-custom.conf

# Restart the audio services
systemctl --user restart pipewire{,-pulse} wireplumber
