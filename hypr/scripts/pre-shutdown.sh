#!/bin/bash

# Save the session
systemctl --user start save-hypr-session.service

# Wait for save to complete
sleep 1
