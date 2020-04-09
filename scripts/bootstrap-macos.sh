#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   Wed - 04/08/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: Wed - 04/08/2020
#

# Installer for macOS

# Go to dotfiles directory
cd "$(dirname $0)/.."

DOTFILES_DIR=$(pwd -P)

# Exit if there are any errors along the way
set -e

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

check_dependencies
