#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

sudo apt update && sudo apt upgrade -y

# Install meson, ninja and rust
sudo apt install -y meson ninja-build
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

if [ $(cat /etc/X11/default-display-manager) != /usr/bin/sddm ]
then
    # Install sddm
    sudo apt install --no-install-recommends -y sddm
    sudo reboot now
    exit 0
fi

# Run install script
echo "******************************************************************"
echo "                 About to install hyprland                        "
echo "Go with these options: y, ENTER, ENTER, input_group, sddm, sddm_theme, gtk_themes, thunar, ags and nwg-look"
echo "******************************************************************"
sleep 5
bash <(curl -L https://raw.githubusercontent.com/JaKooLit/Ubuntu-Hyprland/24.04/auto-install.sh)

# Choose sddm, thunar, and other packages

# Install uwsm
git clone https://github.com/Vladimir-csp/uwsm.git
cd uwsm
git checkout v0.24.3
meson setup --prefix=/usr/local -Duuctl=enabled -Dfumon=enabled -Duwsm-app=enabled build
meson install -C build
cd ..

# Install walker deps
sudo apt install -y libgtk-4-dev libgtk-layer-shell-dev protobuf-compiler libcairo2-dev libpoppler-glib-dev valac sassc

# Install gtk4-layer-shell
git clone https://github.com/wmww/gtk4-layer-shell.git
cd gtk4-layer-shell
git checkout v1.3.0
meson setup -Dexamples=false -Ddocs=false -Dtests=false build
ninja -C build
sudo ninja -C build install
sudo ldconfig
cd ..

# Install elephant
git clone https://github.com/abenz1267/elephant
cd elephant
git checkout v2.15.0
cd cmd/elephant
go install elephant.go
sudo cp ~/go/bin/elephant /usr/local/bin/
cd ..

# elephant - Create configuration directories
mkdir -p ~/.config/elephant/providers

# elephant - Build and install a provider (example: desktop applications)
cd internal/providers/desktopapplications
go build -buildmode=plugin
cp desktopapplications.so ~/.config/elephant/providers/
cd ${SCRIPT_DIR}

# Install walker
curl -LO https://github.com/abenz1267/walker/releases/download/v2.7.0/walker-v2.7.0-x86_64-unknown-linux-gnu.tar.gz
tar -xzvf walker-v2.7.0-x86_64-unknown-linux-gnu.tar.gz
sudo mv walker /usr/local/bin

# Install mako
curl -LO https://github.com/emersion/mako/releases/download/v1.10.0/mako-1.10.0.tar.gz
tar -xzvf mako-1.10.0.tar.gz
cd mako
meson build
ninja -C build
sudo cp build/mako /usr/local/bin/
sudo cp build/makoctl /usr/local/bin/
sudo chmod 755 /usr/local/bin/mako*
cd ..

# Install swaybg
curl -LO https://github.com/swaywm/swaybg/releases/download/v1.2.1/swaybg-1.2.1.tar.gz
tar -xzvf swaybg-1.2.1.tar.gz
cd swaybg-1.2.1
meson build/
ninja -C build/
sudo ninja -C build/ install
cd ..

# Install swayosd
git clone https://github.com/ErikReider/SwayOSD.git
cd SwayOSD
git checkout v0.2.1
meson setup build
ninja -C build
meson install -C build
cd ..

# Install config files
for dir in "$SCRIPT_DIR"/*/; do
    [ -d "$dir" ] || continue  # Skip non-directory files

    dir_name="$(basename "$dir")"
    target_dir="$CONFIG_DIR/$dir_name"

    echo "Setting up $target_dir..."

    if [ -d "$target_dir" ]; then
        read -p "Directory $target_dir exists. Delete it? (y/n): " choice
        case "$choice" in
            y|Y ) rm -rf "$target_dir";;
            n|N ) echo "Keeping $target_dir"; continue;;
            * ) echo "Invalid choice, skipping $dir_name"; continue;;
        esac
    fi

    mkdir -p "$target_dir"

    stow --restow --target="$target_dir" -d "$SCRIPT_DIR" "$dir_name"
done
