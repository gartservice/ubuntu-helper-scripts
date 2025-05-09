#!/bin/bash

# Define the files you want to copy
FILES=("packages.list" "snap-packages.list")

# Find the USB device with a mount point in /media/$USER
USB_MOUNT=$(lsblk -o MOUNTPOINT | grep "/media/$USER" | head -n 1)

# Check if USB is mounted
if [ -z "$USB_MOUNT" ]; then
    echo "No mounted USB drive found in /media/$USER. Please insert and mount the USB."
    exit 1
fi

echo "Found USB mounted at: $USB_MOUNT"

# Copy each file
for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        echo "Copying $FILE to $USB_MOUNT..."
        cp "$FILE" "$USB_MOUNT/"
    else
        echo "Warning: $FILE not found, skipping."
    fi
done

echo "✅ Done. Files copied to USB at $USB_MOUNT"
