#!/bin/bash

# Kill any currently running instances of mpvpaper
killall mpvpaper

# Run both mpvpaper commands in the background
mpvpaper -o "--profile=fast --keepaspect=no --speed=2 --loop=inf" DP-2 /home/dei/Videos/mylivewallpapers-com-Black-BMW-Rain-4K.mp4 &
mpvpaper -o "--profile=fast --hwdec=auto-safe --keepaspect=no --speed=1 --loop=inf" DP-1 /home/dei/Videos/mercedes-amg-c63-s-coupe-forza-horizon-4-moewalls-com.mp4 &

# Wait for both background processes to finish
wait
