#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   Sat - 04/25/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: Sat - 04/25/2020
#

# handles installation, updates. Should be run periodically
# to make sure everything is up to date.

set -e

export DOTFILES="$HOME/.dotfiles"
SCRIPT_DIR="scripts"
cd "$DOTFILES" || exit 1

source ./$SCRIPT_DIR/print_source.sh
source ./$SCRIPT_DIR/common.sh

OS_FLAG=$(detect_os)
echo "Found OS_FLAG: ${OS_FLAG}"

# add section to pull updates from git repo
# TODO

# Link dotfiles
install_dotfiles ${OS_FLAG}

# Re-run install scripts
run_install ${OS_FLAG}
