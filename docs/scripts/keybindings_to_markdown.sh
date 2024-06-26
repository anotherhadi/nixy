#!/usr/bin/env bash

function getList(){
    content=$1
    name=$2
    list_start=$(echo "$content" | sed "/$name = \[/!d;=;Q")
    list=$(echo "$content" | tail +$list_start)
    list_end=$(echo "$list" | sed '/\]/!d;=;Q')
    list=$(echo "$list" | head -n$list_end)

    echo "$list"   
}

[[ -f "./home/system/hyprland/default.nix" ]] || (echo "File ./home/system/hyprland/default.nix not found" && exit 1)

config=$( cat "./home/system/hyprland/default.nix")

# Bind
bind=$(getList "$config" "bind")
echo "$bind"

# Bindm (mouse)
bindm=$(getList "$config" "bindm")
echo "$bindm"

# Bindl (lock)
bindl=$(getList "$config" "bindl")
echo "$bindl"

# Bindle (lock, repetition)
bindle=$(getList "$config" "bindle")
echo "$bindle"

# Join the lists:
# ...

# Remove lines not containing a "
# ...

# Parse the keybindings:
# Example: "mod, key, dispatcher, params" # Description
# 1. Get the description/remove it
# 2. Remove the quotes
# 3. Get mod /remove it (replace $mod and $shiftmod by SUPER and SUPER_SHIFT)
# 4. Get key /remove it
# 5. Get dispatcher /remove it
# 6. Get params

# Manually add workspace shortcuts

# Markdown table:
# | Description | keybinding | params |
# | -- | -- | -- |
# ...
