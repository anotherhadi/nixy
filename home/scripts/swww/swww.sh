#!/usr/bin/env bash

DIR="/etc/nixos/Wallpapers"
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

swww query || swww-daemon

#change-wallpaper using swww
swww img ${DIR}/${RANDOMPICS} --transition-fps 60 --transition-type wipe --transition-duration 3
