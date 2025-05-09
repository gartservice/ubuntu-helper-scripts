#!/bin/bash

# Install APT packages
if [ -f packages.list ]; then
  sudo apt update
  xargs sudo apt install -y < packages.list
else
  echo "packages.list not found"
fi

# Install Snap packages
if [ -f snap-packages.list ]; then
  while read pkg; do
    sudo snap install "$pkg"
  done < snap-packages.list
else
  echo "snap-packages.list not found"
fi
