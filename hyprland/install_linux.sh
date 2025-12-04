#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TMPDIR=/tmp/hyprland_install

mkdir -p ${TMPDIR}

check_installed() {
    if which $1 &>/dev/null
    then
        return 0
    fi
    return 1
}

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
if ! check_installed hyprland
then
    echo "******************************************************************"
    echo "                 About to install hyprland                        "
    echo "Go with these options: y, ENTER, ENTER, input_group, sddm, sddm_theme, gtk_themes, thunar, ags and nwg-look"
    echo "******************************************************************"
    sleep 5
    bash <(curl -L https://raw.githubusercontent.com/JaKooLit/Ubuntu-Hyprland/24.04/auto-install.sh)
fi

# Install uwsm
if ! check_installed uwsm
then
    cd ${TMPDIR}
    git clone https://github.com/Vladimir-csp/uwsm.git
    cd uwsm
    git checkout v0.24.3
    meson setup --prefix=/usr/local -Duuctl=enabled -Dfumon=enabled -Duwsm-app=enabled build
    meson install -C build
    cd ${SCRIPT_DIR}
fi

# Install walker deps
sudo apt install -y libgtk-4-dev libgtk-layer-shell-dev protobuf-compiler libcairo2-dev libpoppler-glib-dev valac sassc

# Install gtk4-layer-shell
if [ ! -e /usr/local/lib/x86_64-linux-gnu/libgtk4-layer-shell.so ]
then
    cd ${TMPDIR}
    git clone https://github.com/wmww/gtk4-layer-shell.git
    cd gtk4-layer-shell
    git checkout v1.3.0
    meson setup -Dexamples=false -Ddocs=false -Dtests=false build
    ninja -C build
    sudo ninja -C build install
    sudo ldconfig
    cd ${SCRIPT_DIR}
fi

# Install elephant
if ! check_installed elephant
then
    cd ${TMPDIR}
    git clone https://github.com/abenz1267/elephant
    cd elephant
    git checkout v2.15.0
    cd cmd/elephant
    go install elephant.go
    sudo cp ~/go/bin/elephant /usr/local/bin/

    # elephant - Create provider directories
    sudo mkdir -p /etc/xdg/elephant/providers

    # elephant - Build and install a provider (example: desktop applications)
    PROVIDERS=(
        "desktopapplications"
        "bluetooth"
        "files"
        "calc"
        "providerlist"
        "runner"
        "websearch"
        "clipboard"
        "menus"
        "todo"
        "unicode"
        "symbols"
    )
    for provider in "${PROVIDERS[@]}"; do
        cd ${TMPDIR}/elephant/internal/providers/${provider}
        go build -buildmode=plugin
        sudo chmod 755 ${provider}.so
        sudo cp ${provider}.so /etc/xdg/elephant/providers/
    done
    cd ${SCRIPT_DIR}
fi

# Install walker
if ! check_installed walker
then
    cd ${TMPDIR}
    curl -LO https://github.com/abenz1267/walker/releases/download/v2.7.0/walker-v2.7.0-x86_64-unknown-linux-gnu.tar.gz
    tar -xzvf walker-v2.7.0-x86_64-unknown-linux-gnu.tar.gz
    sudo mv walker /usr/local/bin
    cd ${SCRIPT_DIR}
fi

# Install mako
if ! check_installed mako
then
    cd ${TMPDIR}
    curl -LO https://github.com/emersion/mako/releases/download/v1.10.0/mako-1.10.0.tar.gz
    tar -xzvf mako-1.10.0.tar.gz
    cd mako
    meson build
    ninja -C build
    sudo cp build/mako /usr/local/bin/
    sudo cp build/makoctl /usr/local/bin/
    sudo chmod 755 /usr/local/bin/mako*
    cd ${SCRIPT_DIR}
fi

# Install swaybg
if ! check_installed swaybg
then
    cd ${TMPDIR}
    curl -LO https://github.com/swaywm/swaybg/releases/download/v1.2.1/swaybg-1.2.1.tar.gz
    tar -xzvf swaybg-1.2.1.tar.gz
    cd swaybg-1.2.1
    meson build/
    ninja -C build/
    sudo ninja -C build/ install
    cd ${SCRIPT_DIR}
fi

# Install swayosd
if ! check_installed swayosd-server
then
    cd ${TMPDIR}
    git clone https://github.com/ErikReider/SwayOSD.git
    cd SwayOSD
    git checkout v0.2.1
    meson setup build
    ninja -C build
    meson install -C build
    cd ${SCRIPT_DIR}
fi

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
