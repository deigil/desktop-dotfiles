#!/bin/bash

# Kill any currently running instances of mpvpaper
killall mpvpaper

# Run both mpvpaper commands in the background
mpvpaper -o "--mute=yes --profile=fast --hwdec=auto-safe --video-scale-x=1 --video-scale-y=1 --speed=1 --loop=inf" DP-5 /home/dei/Videos/nissan-skyline-gtr32-blurry-street.mp4 &
mpvpaper -o "--mute=yes --profile=fast --hwdec=auto-safe --video-scale-x=3.2 --video-scale-y=3.2 --video-pan-x=0 --speed=1 --loop=inf" DP-4 /home/dei/Videos/porsche-gt3-drift.mp4 &

# Wait for both background processes to finish
wait
