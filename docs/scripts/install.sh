#!/usr/bin/env bash

# https://github.com/anotherhadi/nixy
# Installation script: Should be run on fresh nixos install.

printf "\n\e[0;92m- \e[0m\e[1;77mNixy's Installation Script\e[0;96m [anotherhadi/nixy]\e[0m"

# Check if we're on the good directory
[[ -f "./docs/scripts/install.sh" ]] || (printf "\n\e[0;91mx \e[0m\e[1;77mNot in the project root directory\e[0m"; exit 1)
DIR=$(pwd)

# Create a new configuration
read -p $'\n\e[0;92m+\e[0m\e[1;77m Username: \e[0;96m' username
read -p $'\n\e[0;92m+\e[0m\e[1;77m Hostname: \e[0;96m' hostname

HOST_DIR="./hosts/$hostname"
mkdir $HOST_DIR

nixos-generate-config # check that hardware-configuration.nix is indeed created and with user right
rm configuration.nix
mv hardware-configuration.nix "$HOST_DIR"

printf "\n\e[0;92m? \e[0m\e[1;77mInstall Nvidia drivers?\e[0;96m [y/N]\e[0m"
read yn
yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')
if [[ $yn == "y" || $yn == "yes" ]]; then
    nvidia=true
else
    nvidia=false
fi

printf "\n\e[0;92m? \e[0m\e[1;77mInstall prime?\e[0;96m [y/N]\e[0m"
read yn
yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')
if [[ $yn == "y" || $yn == "yes" ]]; then
    prime=true
else
    prime=false
fi

GUEST_CONFIG="./hosts/guest"

cp "$LAPTOP_CONFIG/configuration.nix" "$HOST_DIR/configuration.nix"
cp "$LAPTOP_CONFIG/variables.nix" "$HOST_DIR/variables.nix"

config=$(cat "$LAPTOP_CONFIG/configuration.nix")
if [[ $nvidia == false ]];then
    config=$(echo "$config" | sed 's/..\/shared\/nvidia/# ..\/shared\/nvidia/')
fi
if [[ $prime == false ]];then
    config=$(echo "$config" | sed 's/..\/shared\/prime/# ..\/shared\/prime/')
fi
echo "$config" >"$HOST_DIR/configuration.nix"

variables=$(cat "$LAPTOP_CONFIG/variables.nix")
variables=$(echo "$variables" | sed 's/112569860+anotherhadi@users.noreply.github.com/your_email/')
variables=$(echo "$variables" | sed 's/hadi/$username/')
variables=$(echo "$variables" | sed 's/nixy/$username/') # FIXME: Host name can be mixed with themes
variables=$(echo "$variables" | sed 's/Hadi/your_username/')
variables=$(echo "$variables" | sed 's/sops = true/sops = false/')
variables=$(echo "$variables" | sed 's/obsidian = true/obsidian = false/')
variables=$(echo "$variables" | sed 's/tailscale = true/tailscale = false/')
echo "$variables" >"$HOST_DIR/variables.nix"

# printf "\n\e[0;92m✓ \e[0m\e[1;77mSucess Message\e[0m"
# printf "\n\e[0;92m+ \e[0m\e[1;77mAdded Message\e[0m"
# printf "\n\e[0;92m? \e[0m\e[1;77mAn issue? Open an issue/pull request at : \e[0;96mhttps://github.com/anotherhadi/nixy \e[0m"