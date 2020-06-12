#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   Wed - 04/08/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: 06/11/2020
#

# Installer for macOS

# Go to dotfiles directory
cd "$(dirname $0)/.."

DOTFILES_DIR=$(pwd -P)
SCRIPT_DIR="scripts"

# Exit if there are any errors along the way
set -e

source ./$SCRIPT_DIR/print_source.sh
source ./$SCRIPT_DIR/common.sh

print_installed() {
    success "$1 is already installed"
}

does_not_exist() {
    if ! prog_location="$(type -p $1)" || [ -z $prog_location ]
    then
        return
    else
        false
    fi
}

setup_gitconfig() {
    info 'setup gitconfig'
    # if there is no user.email, we'll assume it's a new machine/setup and ask it
    if [ -z "$(git config --global --get user.email)" ]; then
        user ' - What is your github author name?'
        read -r user_name
        user ' - What is your github author email?'
        read -r user_email

        git config --global user.name "$user_name"
        git config --global user.email "$user_email"
    elif [ "$(git config --global --get dotfiles.managed)" != "true" ]; then
        # if user.email exists, let's check for dotfiles.managed config. If it is
        # not true, we'll backup the gitconfig file and set previous user.email and
        # user.name in the new one
        user_name="$(git config --global --get user.name)"
        user_email="$(git config --global --get user.email)"
        mv ~/.gitconfig ~/.gitconfig.backup
        success "moved ~/.gitconfig to ~/.gitconfig.backup"
        git config --global user.name "$user_name"
        git config --global user.email "$user_email"
    else
        # otherwise this gitconfig was already made by the dotfiles
        info "already managed by dotfiles"
    fi
    # include the gitconfig.local file
    git config --global include.path ~/.gitconfig.local
    # finally make git knows this is a managed config already, preventing later
    # overrides by this script
    git config --global dotfiles.managed true
    success 'gitconfig'
}

check_dependencies() {
    if does_not_exist brew
    then
        info "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        print_installed Homebrew
    fi

    if does_not_exist tmux
    then
        info "Installing tmux"
        brew install tmux
    else
        print_installed tmux
    fi

    if does_not_exist ssh
    then
        info "Installing openssh"
        brew install openssh
    else
        # check for updates
        brew upgrade openssh
    fi

    if does_not_exist vim
    then
        info "Installing vim"
        brew install vim
    else
        print_installed vim
    fi

    if does_not_exist keychain
    then
        info "Installing Keychain"
        brew install keychain
    else
        print_installed keychain
    fi

    if does_not_exist htop
    then
        info "Installing htop"
    else
        print_installed htop
    fi
}

install_zsh() {
    # TODO: remove this function and brew install of zsh
    brew install zsh
    chsh -s $(which zsh)
    success "$($(which zsh) --version) has been setup"
}

# instal notify,
install_zsh_plugins() {
    git clone https://github.com/marzocchi/zsh-notify.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/notify
    git clone https://github.com/unixorn/tumult.plugin.zsh.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tumult
    git clone https://github.com/oldratlee/hacker-quotes.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/hacker-quotes
}

# Turn on when git config files saved to dotfiles
# setup_gitconfig
# check_dependencies
# check_default_shell
install_dotfiles -a
