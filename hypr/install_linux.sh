#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

sudo apt update && sudo apt upgrade -y

# Install sddm
sudo apt install --no-install-recommends -y sddm

# Re-run installer if sddm doesn't make you choose over gdm3
#     `sudo dpkg-reconfigure sddm`

# Run install script
bash <(curl -L https://raw.githubusercontent.com/JaKooLit/Ubuntu-Hyprland/24.04/auto-install.sh)

# Choose sddm, thunar, and other packages

# Install uwsm
git clone https://github.com/Vladimir-csp/uwsm.git
git checkout v0.24.3
meson setup --prefix=/usr/local -Duuctl=enabled -Dfumon=enabled -Duwsm-app=enabled build
meson install -C build
