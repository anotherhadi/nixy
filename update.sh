#!/usr/bin/env bash
if [ -f ./check ]; then
  rm -rf ./home ./hosts ./nixos ./themes ./Wallpapers ./flake.nix ./flake.lock
  cp -r /etc/nixos/* ./
  git add . --all
  echo "Enter commit name (enter to default)"
  read name
  if [ -n "$name" ]; then
    git commit -m "$name"
    git pull
    git push -u
  else
    git commit -m "lil update"
    git pull
    git push -u
  fi
else
  echo "change your working directory to dotfiles already"
fi

