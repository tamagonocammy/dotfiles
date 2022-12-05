#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
## Autostart Programs

# Kill already running process
killall -9 picom dunst ksuperkey mpd xfce-polkit xfce4-power-manager python 

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

# Enable power management
xfce4-power-manager &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &

# Restore wallpaper
nitrogen --restore &

# Launch notification daemon
~/.config/i3/bin/i3dunst.sh

# Launch polybar
~/.config/i3/bin/i3bar.sh

# Launch compositor
~/.config/i3/bin/i3comp.sh

# Start mpd
exec mpd &
mpd-mpris --no-instance &

# Start Python web server 
python -m http.server 8000 --directory /home/cammy/.startpage &

# Set keyboard 
setxkbmap es

# Start clipboard
clipit -nd &
