#!/usr/bin/env bash

# https://github.com/anotherhadi/nixy
# Installation script: Should be run on fresh nixos install.

printf "\n\e[0;92m- \e[0m\e[1;77mNixy's Installation Script\e[0;96m [anotherhadi/nixy]\e[0m"

# Check if we're on the good directory
[[ -f "./docs/scripts/install.sh" ]] || (
  printf "\n\e[0;91mx \e[0m\e[1;77mNot in the project root directory\e[0m"
  exit 1
)
DIR=$PWD

# Create a new configuration
read -rp $'\n\e[0;92m+\e[0m\e[1;77m Username: \e[0;96m' username
read -rp $'\n\e[0;92m+\e[0m\e[1;77m Hostname: \e[0;96m' hostname

HOST_DIR="./hosts/$hostname"
mkdir "$HOST_DIR"

nixos-generate-config --show-hardware-config >"$HOST_DIR/hardware-configuration.nix"

printf "\n\e[0;92m? \e[0m\e[1;77mInstall Nvidia drivers?\e[0;96m [y/N]\e[0m"
read -r yn
yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')
if [[ $yn == "y" || $yn == "yes" ]]; then
  nvidia=true
else
  nvidia=false
fi

printf "\n\e[0;92m? \e[0m\e[1;77mInstall prime?\e[0;96m [y/N]\e[0m"
read -r yn
yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')
if [[ $yn == "y" || $yn == "yes" ]]; then
  prime=true
else
  prime=false
fi

cp "$LAPTOP_CONFIG/configuration.nix" "$HOST_DIR/configuration.nix"
cp "$LAPTOP_CONFIG/variables.nix" "$HOST_DIR/variables.nix"

config=$(cat "$LAPTOP_CONFIG/configuration.nix")
if [[ $nvidia == false ]]; then
  config=$(echo "$config" | sed 's/..\/shared\/nvidia/# ..\/shared\/nvidia/')
fi
if [[ $prime == false ]]; then
  config=$(echo "$config" | sed 's/..\/shared\/prime/# ..\/shared\/prime/')
fi
echo "$config" >"$HOST_DIR/configuration.nix"

variables=$(cat "$LAPTOP_CONFIG/variables.nix")
variables=$(echo "$variables" | sed 's/112569860+anotherhadi@users.noreply.github.com/your_email/')
variables=$(echo "$variables" | sed "s/hadi/$username/")
variables=$(echo "$variables" | sed "s/nixy/$hostname/") # FIXME: Host name can be mixed with themes
variables=$(echo "$variables" | sed "s/Hadi/$username/")
variables=$(echo "$variables" | sed 's/sops = true/sops = false/')
variables=$(echo "$variables" | sed 's/obsidian = true/obsidian = false/')
variables=$(echo "$variables" | sed 's/tailscale = true/tailscale = false/')
echo "$variables" >"$HOST_DIR/variables.nix"

# Add it to the git index
git add .

printf "\n\e[0;92m+ \e[0m\e[1;77mHost added!\e[0m"

# REBUILD

printf "\n\e[0;92m? \e[0m\e[1;77mDo you want to rebuild?\e[0;96m [y/N]\e[0m"
read -r yn
yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')
if [[ $yn == "y" || $yn == "yes" ]]; then
  sudo nixos-rebuild switch --flake "$DIR"#"$hostname"
fi

printf "\n\e[0;92m✓ \e[0m\e[1;77mDone!\e[0m"
