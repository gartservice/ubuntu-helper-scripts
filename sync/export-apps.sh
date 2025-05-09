#!/bin/bash

# Save APT packages
sudo bash -c 'comm -23 <(apt-mark showmanual | sort) <(gzip -dc /var/log/installer/* 2>/dev/null | awk "/Package: / {print \$2}" | sort)' > packages.list

# Save Snap packages
snap list | awk 'NR>1 {print $1}' > snap-packages.list

echo "Saved APT and Snap packages to packages.list and snap-packages.list"
