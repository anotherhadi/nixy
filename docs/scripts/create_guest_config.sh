#!/usr/bin/env bash

# This script is used to copy my own configuration to the `./hosts/guest` one, and changing some settings

[[ -d "./hosts" ]] || (
  echo "Folder ./hosts not found"
  exit 1
)

LAPTOP_CONFIG="./hosts/laptop"
GUEST_CONFIG="./hosts/guest"

# Remove the NVIDIA driver import
config=$(cat "$LAPTOP_CONFIG/configuration.nix")
config=$(echo "$config" | sed 's/..\/modules\/nvidia/# ..\/modules\/nvidia/')
config=$(echo "$config" | sed 's/..\/modules\/prime/# ..\/modules\/prime/')
echo "$config" >"$GUEST_CONFIG/configuration.nix"

variables=$(cat "$LAPTOP_CONFIG/variables.nix")
variables=$(echo "$variables" | sed 's/112569860+anotherhadi@users.noreply.github.com/your_email/')
variables=$(echo "$variables" | sed 's/hadi/your_username/')
variables=$(echo "$variables" | sed 's/Hadi/your_username/')
variables=$(echo "$variables" | sed 's/sops = true/sops = false/')
variables=$(echo "$variables" | sed 's/obsidian = true/obsidian = false/')
variables=$(echo "$variables" | sed 's/tailscale = true/tailscale = false/')
echo "$variables" >"$GUEST_CONFIG/variables.nix"

home=$(cat "$LAPTOP_CONFIG/home.nix")
home=$(echo "$home" | sed 's/\.\/sops.nix/# .\/sops.nix/')
echo "$home" >"$GUEST_CONFIG/home.nix"
