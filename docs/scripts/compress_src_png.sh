#!/usr/bin/env bash

# Compress png files in ./docs/src

[[ -d "./docs" ]] || (echo "Folder ./docs not found" && exit 1)

for file in ./docs/src/*.png; do
  optipng "$file"
done
