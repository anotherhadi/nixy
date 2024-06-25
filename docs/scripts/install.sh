#!/usr/bin/env bash

# https://github.com/anotherhadi/nixy
# Installation script: Should be run on fresh nixos install.

printf "\n\e[0;92m- \e[0m\e[1;77mNixy's Installation Script\e[0;96m [anotherhadi/nixy]\e[0m"

# Check if we're on the good directory
[[ -f "./docs/scripts/install.sh" ]] || (printf "\n\e[0;91mx \e[0m\e[1;77mNot in the project root directory\e[0m"; exit 1)
DIR=$(pwd)

# Create a new configuration
