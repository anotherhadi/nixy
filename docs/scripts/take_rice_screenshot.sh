#!/usr/bin/env bash

[ "$1" = "" ] && echo "Usage: $0 <theme_name>" && exit 1
theme_name=$1

# Switch to workspace 1
sleep 2

# Step 1
kitty --class peaclock peaclock &
sleep 1
menu &
sleep 1
hyprshot -m "output" -m "active" -o "$HOME/.config/nixos/docs/src/$theme_name" -f "1.png" -d
sleep 2
pkill peaclock
menu
sleep 2

# Step 2
kitty cmatrix &
sleep 1
kitty &
sleep 1
qutebrowser &
sleep 3
hyprshot -m "output" -m "active" -o "$HOME/.config/nixos/docs/src/$theme_name" -f "2.png" -d
sleep 2
pkill cmatrix
pkill --newest qutebrowser ""
pkill --newest kitty
sleep 2

# Step 3
kitty cava &
sleep 1
spotify &
sleep 10
brightness-down
sleep 1
hyprshot -m "output" -m "active" -o "$HOME/.config/nixos/docs/src/$theme_name" -f "3.png" -d
sleep 2
