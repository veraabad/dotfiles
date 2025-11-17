# Install hyperland on ubuntu

## Install Hyperland
* Install sddm
    `sudo apt install --no-install-recommends -y sddm`
* Re-run installer if sddm doesn't make you choose over gdm3
    `sudo dpkg-reconfigure sddm`
* Install timeshift to backup
    `sudo apt install timeshift -y`
* Update
    `sudo apt update && sudo apt upgrade -y`
* Backup
    `sudo timeshift --create --comments "Initial full backup"`
* Run install script
    `bash <(curl -L https://raw.githubusercontent.com/JaKooLit/Ubuntu-Hyprland/24.04/auto-install.sh)`
* Choose sddm, thunar, and other packages
* Reboot after done

## Setup Hyperland
### Uwsm
* Install uwsm
    `git clone https://github.com/Vladimir-csp/uwsm.git`
* Checkout latest branch
    `git checkout vX.Y.Z`
* Build and install
    `meson setup --prefix=/usr/local -Duuctl=enabled -Dfumon=enabled -Duwsm-app=enabled build`
    `meson install -C build`

### walker
* Install deps
    `sudo apt install -y libgtk-4-dev libgtk-layer-shell-dev protobuf-compiler libcairo2-dev libpoppler-glib-dev valac sassc`
* Install gtk4-layer-shell
    `git clone https://github.com/wmww/gtk4-layer-shell.git`
    `git checkout v1.3.0`
    `meson setup -Dexamples=false -Ddocs=false -Dtests=false build`
    `ninja -C build`
    `sudo ninja -C build install`
    `sudo ldconfig`
* Install elephant
    `git clone https://github.com/abenz1267/elephant`
    `git checkout v2.15.0`
    `cd elephant/cmd/elephant`
    ```
    go install elephant.go
    sudo cp ~/go/bin/elephant /usr/local/bin/

    # Create configuration directories
    mkdir -p ~/.config/elephant/providers

    # Build and install a provider (example: desktop applications)
    cd internal/providers/desktopapplications
    go build -buildmode=plugin
    cp desktopapplications.so ~/.config/elephant/providers/
    ```

* Install walker
    `curl -LO https://github.com/abenz1267/walker/releases/download/v2.10.0/walker-v2.10.0-x86_64-unknown-linux-gnu.tar.gz`
    `tar -xzvf walker-v2.10.0-x86_64-unknown-linux-gnu.tar.gz`
    `sudo mv walker /usr/local/bin`

### Other deps
* Install mako
    `curl -LO https://github.com/emersion/mako/releases/download/v1.10.0/mako-1.10.0.tar.gz`
    `tar -xzvf mako-1.10.0.tar.gz`
    `sudo mv mako /usr/bin/local/bin`
    `cd mako`
    `meson build`
    `ninja -C build`
    `sudo cp build/mako /usr/local/bin/`
    `sudo cp build/makoctl /usr/local/bin/`
    `sudo chmod 755 /usr/local/bin/mako*`

* Install swaybg
    `curl -LO https://github.com/swaywm/swaybg/releases/download/v1.2.1/swaybg-1.2.1.tar.gz`
    `tar -xzvf swaybg-1.2.1.tar.gz`
    `cd swaybg-1.2.1`
    `meson build/`
    `ninja -C build/`
    `sudo ninja -C build/ install`

* Install swayosd
    `git clone https://github.com/ErikReider/SwayOSD.git`
    `cd SwayOSD`
    `git checkout v0.2.1`
    `meson setup build`
    `ninja -C build`
    `meson install -C build`

* Install polkit-gnome

