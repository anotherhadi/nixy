#!/usr/bin/env bash

# Compress png files in ./docs/src

[[ -d "./docs" ]] || (echo "Folder ./docs not found" && exit 1)

# Main images
for file in ./docs/src/*.png; do
  optipng "$file"
done

# Theme's images
for file in ./docs/src/*/*.png; do
  optipng "$file"
done

for file in ./home/wallpapers/*.png; do
  optipng "$file"
done
