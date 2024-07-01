#!/usr/bin/env bash

# Create WALLPAPERS.md to preview wallpapers in ./home/wallpapers

WALLPAPERS_FOLDER="./home/wallpapers"
WALLPAPERS_MD="./docs/WALLPAPERS.md"
[[ -d "$WALLPAPERS_FOLDER" ]] || (echo "Wallpapers folder not found" && exit 1)

echo "# Wallpapers" >"$WALLPAPERS_MD"
echo "" >>"$WALLPAPERS_MD"
echo "Wallpapers can be found in the /home/wallpapers folder." >>"$WALLPAPERS_MD"
echo "" >>"$WALLPAPERS_MD"
echo "| Name | Preview |" >>"$WALLPAPERS_MD"
echo "| -- | -- |" >>"$WALLPAPERS_MD"

for file in $WALLPAPERS_FOLDER/*.png; do
  filename=$(basename $file)
  echo "| $filename | ![$filename](../home/wallpapers/$filename) |" >>"$WALLPAPERS_MD"
done

pandoc -t commonmark_x "$WALLPAPERS_MD" -o "/tmp/wallpapers.md"
mv "/tmp/wallpapers.md" "$WALLPAPERS_MD"