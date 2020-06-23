#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   06/09/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: 06/23/2020

# Go to dotfiles directory
cd "$(dirname $0)/.."

DOTFILES_DIR=$(pwd -P)
SCRIPT_DIR="scripts"

# Exit if there are any errors along the way
set -e

ZSH_THEMES_DIR=$HOME/.oh-my-zsh/custom/themes
ZSH_PLUGINS_DIR=$HOME/.oh-my-zsh/custom/plugins

install_zsh() {
    chsh -s $(which zsh)
    success "$($(which zsh) --version) has been setup"
}

check_default_shell() {
    case $SHELL in
        *"zsh"* )
            success "$($SHELL --version) is the default shell"
            ;;
        *"bash"* )
            info "BASH is the default shell"
            info "Will install zsh"
            install_zsh
            ;;
    esac
}

install_oh_my_zsh() {
    if [[ ! -e $HOME/.oh-my-zsh ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    if [[ ! -e $ZSH_THEMES_DIR/spaceship-prompt ]]; then
        git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt
        ln -s ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme
    fi
    if [[ ! -e $ZSH_PLUGINS_DIR/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    if [[ ! -e $ZSH_PLUGINS_DIR/zsh-syntax-highlighting ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
}

install_exa() {
    if [[ ! $(command -v exa 2>/dev/null) ]]; then
        # For raspberry pi exa needs to be built
        # check rust compiler is installed
        if [[ ! $(command -v rustup 2>/dev/null) ]]; then
            # cap RAM usage as rpi zero does not have enough
            if [[ $(cat /proc/cpuinfo | grep "Raspberry Pi Zero") ]]; then
                export RUSTUP_UNPACK_RAM=204472320
            fi
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        fi
        # Install libgit2
        source $HOME/.cargo/env
        cd ~/
        wget -c https://github.com/libgit2/libgit2/releases/download/v1.0.1/libgit2-1.0.1.zip
        unzip libgit2-1.0.1.zip
        cd libgit2-1.0.1
        mkdir build && cd build
        cmake ..
        cmake --build .
        cmake --build . --target install
        cd ~/
        git clone https://github.com/ogham/exa.git
        cd exa
        make install
        cd $DOTFILES_DIR
    fi
}

install_tmux_plugins() {
    mkdir -p $HOME/.tmux/plugins
    if [[ ! -e $HOME/.tmux/plugins/tpm ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

link_file() {
    if [ -e "$2" ]
    then
        if [ "$(readlink "$2")" = "$1" ]
        then
            success "skipped $1"
            return 0
        else
            mv "$2" "$2.backup"
            success "moved $2 to $2.backup"
        fi
    fi
    ln -sf "$1" "$2"
    success "linked $1 to $2 "
}

install_dotfiles() {
    case "$1" in
        "-a")OS_EXT="macos" ;;
        "-l")OS_EXT="linux" ;;
        "-r")OS_EXT="rpi" ;;
    esac
    info "Installing dotfiles"
    find -H $DOTFILES_DIR -maxdepth 3 -name '*.symlink' -not -path '*.git*' | grep -E "\w*($OS_EXT|all).symlink$" |
        while read -r src
        do
            dst="$HOME/.$(basename "${src%_*.*}")"
            link_file "$src" "$dst"
        done
}
