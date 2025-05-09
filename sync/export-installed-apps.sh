#!/bin/bash

# ===[ Settings ]===
TODAY=$(date +%F)
EXPORT_DIR="$HOME/export-$TODAY"
mkdir -p "$EXPORT_DIR"

echo "📦 Exporting user-installed APT packages..."

# Save all manually installed APT packages
apt-mark showmanual > "$EXPORT_DIR/all-manual.txt"

# Get list of default Ubuntu system packages (from seed)
curl -s https://raw.githubusercontent.com/ubuntu/seed/master/noble/minimal/packages.seed | \
  grep -v '^#' | sort > "$EXPORT_DIR/ubuntu-default.txt"

# Remove system defaults to get only user-installed
comm -23 "$EXPORT_DIR/all-manual.txt" "$EXPORT_DIR/ubuntu-default.txt" > "$EXPORT_DIR/apt-packages.list"

echo "✅ Saved cleaned APT packages to: $EXPORT_DIR/apt-packages.list"

# ===[ Snap packages ]===
echo "📦 Exporting Snap packages..."
snap list | awk 'NR>1 {print $1}' | grep -vE '^(core|core18|core20|core22|bare|snapd|gnome.*)$' > "$EXPORT_DIR/snap-packages.list"
echo "✅ Saved Snap package list to: $EXPORT_DIR/snap-packages.list"

# ===[ Manual Install Reference List ]===
echo "📝 Creating manual install reference list..."
cat <<EOL > "$EXPORT_DIR/manual-install.md"
# Manual Install Required (Not in APT Repos)

These apps need to be installed manually or via external repos:

- google-chrome-stable
  - Website: https://www.google.com/chrome/
  - Install: wget + sudo apt install .deb

- cloudflared
  - Docs: https://developers.cloudflare.com/cloudflared/

You can later automate this with a post-install script.
EOL
echo "✅ Created manual-install.md"

# ===[ Try Copy to USB ]===
USB_MOUNT=$(lsblk -o MOUNTPOINT | grep "/media/$USER" | head -n 1)
if [ -n "$USB_MOUNT" ]; then
  echo "📁 USB drive found at: $USB_MOUNT"
  cp -r "$EXPORT_DIR" "$USB_MOUNT/"
  echo "✅ Copied export to USB"
else
  echo "⚠️ No USB drive detected. Skipping USB copy."
fi

echo "🎉 All done. Files saved in: $EXPORT_DIR"
