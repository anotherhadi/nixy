#!/usr/bin/env bash

# A script to parse the Hyprland configuration to store keybindings in a table

[[ -f "./docs/scripts/install.sh" ]] || (
  printf "\n\e[0;91mx \e[0m\e[1;77mNot in the project root directory\e[0m"
  exit 1
)

KEYBINDINGS_FILE="./docs/KEYBINDINGS.md"

function getList() {
  content=$1
  name=$2
  list_start=$(echo "$content" | sed "/$name = \[/!d;=;Q")
  list=$(echo "$content" | tail +"$list_start")
  list_end=$(echo "$list" | sed '/\]/!d;=;Q')
  list=$(echo "$list" | head -n"$list_end")

  echo "$list"
}

[[ -f "./home/system/hyprland/default.nix" ]] || (echo "File ./home/system/hyprland/default.nix not found" && exit 1)

config=$(cat "./home/system/hyprland/default.nix")

# Bind
bind=$(getList "$config" "bind")
# Bindm (mouse)
bindm=$(getList "$config" "bindm")
# Bindl (lock)
bindl=$(getList "$config" "bindl")
# Bindle (lock, repetition)
bindle=$(getList "$config" "bindle")

# Join the lists:
keybindings=$(echo -e "$bind\n$bindm\n$bindl\n$bindle" | grep '"')

echo "# Keybindings" >"$KEYBINDINGS_FILE"
echo "" >>"$KEYBINDINGS_FILE"
echo "The list of the keybindings working on Hyprland:" >>"$KEYBINDINGS_FILE"
echo "" >>"$KEYBINDINGS_FILE"

echo "| Description | Keybinding | Command |" >>"$KEYBINDINGS_FILE"
echo "| -- | -- | -- |" >>"$KEYBINDINGS_FILE"
echo "| Switch Workspace | SUPER + {Number} | workspace {Number} |" >>"$KEYBINDINGS_FILE"
echo "| Move app to Workspace | SUPER SHIFT + {Number} | movetoworkspace {Number} |" >>"$KEYBINDINGS_FILE"
echo "$keybindings" | while read line; do
  comment=$(echo "$line" | cut -d\# -f2)
  line=$(echo "$line" | cut -d\# -f1)
  line=${line:1:${#line}-3}
  mod=$(echo "$line" | cut -d, -f1)
  key=$(echo "$line" | cut -d, -f2)
  dispatcher=$(echo "$line" | cut -d, -f3)
  params=$(echo "$line" | cut -d, -f4)

  [[ $mod == '$mod' ]] && mod="SUPER + "
  [[ $mod == '$shiftMod' ]] && mod="SUPER SHIFT + "

  echo "| $comment | $mod$key | $dispatcher $params |" >>"$KEYBINDINGS_FILE"
done
