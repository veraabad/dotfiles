#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CATPPUCCIN_DIR="$CONFIG_DIR/tmux/plugins/catppuccin"

mkdir -p $CATPPUCCIN_DIR

if [ ! -d $CATPPUCCIN_DIR/tmux ]
then
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git $CATPPUCCIN_DIR/tmux
fi
