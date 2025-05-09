#!/bin/bash

# ===[ Settings ]===
EXPORT_DIR="$1"  # Path to exported list directory (must be passed as an argument)
APT_LIST="$EXPORT_DIR/apt-packages.list"
SNAP_LIST="$EXPORT_DIR/snap-packages.list"
MANUAL_LIST="$EXPORT_DIR/manual-install.md"

# Check if directory exists
if [ ! -d "$EXPORT_DIR" ]; then
  echo "❌ Error: Directory '$EXPORT_DIR' not found. Please provide a valid directory."
  exit 1
fi

# ===[ Reinstall APT Packages ]===
if [ -f "$APT_LIST" ]; then
  echo "🔄 Reinstalling APT packages..."
  sudo apt update

  # Install APT packages from the list
  while IFS= read -r package; do
    echo "Installing $package..."
    sudo apt install -y "$package"
  done < "$APT_LIST"

  echo "✅ APT packages installed."
else
  echo "⚠️ No APT package list found at: $APT_LIST"
fi

# ===[ Reinstall Snap Packages ]===
if [ -f "$SNAP_LIST" ]; then
  echo "🔄 Reinstalling Snap packages..."

  # Install Snap packages from the list
  while IFS= read -r snap; do
    echo "Installing Snap: $snap..."
    sudo snap install "$snap"
  done < "$SNAP_LIST"

  echo "✅ Snap packages installed."
else
  echo "⚠️ No Snap package list found at: $SNAP_LIST"
fi

# ===[ Manual Install Instructions ]===
if [ -f "$MANUAL_LIST" ]; then
  echo "📋 Check manual install instructions at: $MANUAL_LIST"
else
  echo "⚠️ No manual install instructions found at: $MANUAL_LIST"
fi

echo "🎉 Reinstallation complete!"
