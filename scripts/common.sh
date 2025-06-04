#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   06/09/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: Thu - 06/23/2022

# Go to dotfiles directory
cd "$(dirname $0)/.."

export DOTFILES_DIR=$(pwd -P)
SCRIPT_DIR="scripts"

# Exit if there are any errors along the way
set -e

ZSH_THEMES_DIR=$HOME/.oh-my-zsh/custom/themes
ZSH_PLUGINS_DIR=$HOME/.oh-my-zsh/custom/plugins

install_zsh() {
    chsh -s $(which zsh) || sudo chsh -s $(which zsh) $(whoami)
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

check_ohmzysh_plugin() {
    case "$1" in
        "-p")SRC_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins ;;
        "-t")SRC_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes ;;
    esac
    if [[ ! -d $SRC_DIR/$2 ]]; then
        git clone $3 ${SRC_DIR}/$2
    fi
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

install_eza() {
    if [[ ! $(command -v exa 2>/dev/null) ]]; then
        # Detect CPU architecture
        ARCH=$(uname -m)

        case "$ARCH" in
            x86_64)
                ARCH_TAG="x86_64-unknown-linux-gnu"
                ;;
            aarch64 | arm64)
                ARCH_TAG="aarch64-unknown-linux-gnu"
                ;;
            *)
                echo "Unsupported architecture: $ARCH"
                exit 1
                ;;
        esac

        # Download and extract the correct binary
        URL="https://github.com/eza-community/eza/releases/latest/download/eza_${ARCH_TAG}.tar.gz"
        wget -c "$URL" -O - | tar xz
        sudo chmod +x eza
        sudo chown root:root eza
        sudo mv eza /usr/local/bin/eza        # For raspberry pi exa needs to be built
    fi
}

install_tmux_plugins() {
    mkdir -p $HOME/.tmux/plugins
    if [[ ! -e $HOME/.tmux/plugins/tpm ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

install_neovim_latest() {
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
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

    # Create the destination directory if it doesn't exist
    mkdir -p "$(dirname "$2")"
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
            dst="$HOME/.$(echo "$(basename "${src%_*.*}")" | tr ':' '/')"
            link_file "$src" "$dst"
        done
}

run_install() {
    case "$1" in
        "-a")OS_EXT="macos" ;;
        "-l")OS_EXT="linux" ;;
        "-r")OS_EXT="rpi" ;;
    esac
    info "Running Install Scripts"
    git ls-tree --name-only -r HEAD | grep -E "\w*install_($OS_EXT|all).sh" | while read -r installer; do
        info "› ${installer}..."
        $installer
    done
}

install_pyenv_linux() {
    curl -fsSL https://pyenv.run | bash
}

install_starship_linux() {
    curl -sS https://starship.rs/install.sh | sh
}
