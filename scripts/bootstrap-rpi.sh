#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   06/06/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: 06/12/2020

# Installer for raspberry pi

# Go to dotfiles directory
cd "$(dirname $0)/.."

DOTFILES_DIR=$(pwd -P)
SCRIPT_DIR="scripts"
set -e

source ./$SCRIPT_DIR/print_source.sh
source ./$SCRIPT_DIR/common.sh

sudo apt-get update
# Install list of programs
< ./$SCRIPT_DIR/apt-get-list.txt xargs sudo apt-get install -y

# Install colorls
sudo chown -R ${USER}:${USER} "/var/lib/gems/"
sudo chown -R ${USER}:${USER} "/usr/local/"
gem install colorls

# Load zshrc file
check_default_shell
install_oh_my_zsh
install_dotfiles -r