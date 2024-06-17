#!/usr/bin/env bash

LAPTOP_CONFIG="./hosts/laptop"
GUEST_CONFIG="./hosts/guest"

mv "$LAPTOP_CONFIG/configuration.nix" "$GUEST_CONFIG/configuration.nix"
mv "$LAPTOP_CONFIG/variables.nix" "$GUEST_CONFIG/variables.nix"

# Remove the NVIDIA driver import
cat "$GUEST_CONFIG/configuration.nix" | sed 's/\.\.\/shared\/nvidia/# ..\/shared\/nvidia/' > "$GUEST_CONFIG/configuration.nix"
cat "$GUEST_CONFIG/configuration.nix" | sed 's/\.\.\/shared\/prime/# ..\/shared\/prime/' > "$GUEST_CONFIG/configuration.nix"

cat "$GUEST_CONFIG/variables.nix" | sed 's/hadi/your username/' > "$GUEST_CONFIG/variables.nix"
cat "$GUEST_CONFIG/variables.nix" | sed 's/Hadi/your username/' > "$GUEST_CONFIG/variables.nix"
cat "$GUEST_CONFIG/variables.nix" | sed 's/112569860+anotherhadi@users.noreply.github.com/your email/' > "$GUEST_CONFIG/variables.nix"
cat "$GUEST_CONFIG/variables.nix" | sed 's/sops = true/sops = false/' > "$GUEST_CONFIG/variables.nix"
cat "$GUEST_CONFIG/variables.nix" | sed 's/nextcloud = true/nextcloud = false/' > "$GUEST_CONFIG/variables.nix"
