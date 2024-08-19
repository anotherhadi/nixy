#!/usr/bin/env bash

[[ -d "./docs" ]] || (echo "Folder ./docs not found" && exit 1)

TAG=$(git describe --tags --abbrev=0)
echo "Current tag: $TAG"

read -rp "Enter the new tag name: " NEW_TAG

read -rp "Do you want to compress the png files? [y/N]: " COMPRESS_PNG
if [[ "$COMPRESS_PNG" == "y" || "$COMPRESS_PNG" == "Y" ]]; then
  echo "Compresing png files..."
  bash ./docs/scripts/compress_png.sh
fi

echo "Creating wallpapers preview..."
bash ./docs/scripts/create_preview_wallpapers.sh
echo "Creating README.md..."
bash ./docs/scripts/create_readme.sh
echo "Creating keybindings.md..."
bash ./docs/scripts/keybindings_to_markdown.sh

git add .
git commit -m "Release $NEW_TAG"
git tag -a "$NEW_TAG" -m "Release $NEW_TAG"
git push origin "$NEW_TAG"
