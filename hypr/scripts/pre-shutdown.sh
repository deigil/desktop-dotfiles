#!/bin/bash

# Save the session
systemctl --user start save-hypr-session.service

# Wait for save to complete
sleep 1

# Handle different actions based on argument
if [ "$1" == "logout" ]; then
    hyprctl dispatch exit 0
elif [ "$1" == "reboot" ]; then
    systemctl reboot
elif [ "$1" == "shutdown" ]; then
    systemctl -i poweroff
fi
