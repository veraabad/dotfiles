#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   Wed - 04/08/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: Sat - 04/11/2020
#

# Installer for macOS

# Go to dotfiles directory
cd "$(dirname $0)/.."

DOTFILES_DIR=$(pwd -P)

# Exit if there are any errors along the way
set -e

info() {
    # shellcheck disable=SC2059
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
    # shellcheck disable=SC2059
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
    # shellcheck disable=SC2059
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
    # shellcheck disable=SC2059
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

print_installed() {
    echo "$1 is already installed"
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
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        print_installed Homebrew
    fi

    if does_not_exist tmux
    then
        brew install tmux
    else
        print_installed tmux
    fi

    if does_not_exist ssh
    then
        brew install openssh
    else
        # check for updates
        brew upgrade openssh
    fi

    if does_not_exist vim
    then
        brew install vim
    else
        print_installed vim
    fi

    if does_not_exist keychain
    then
        brew install keychain
    else
        print_installed keychain
    fi
}

# check_dependencies
setup_gitconfig
