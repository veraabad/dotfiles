#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   Sat - 04/25/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: Sat - 04/25/2020
#

# handles installation, updates. Should be run periodically
# to make sure everything is up to date.

export DOTFILES="$HOME/.dotfiles"
cd "$DOTFILES" || exit 1

# add section to pull updates from git repo
#
