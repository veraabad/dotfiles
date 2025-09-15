#!/usr/bin/env bash
[ "$(uname -s)" != "Darwin" ] && exit 0
if [ ! -d "$DOTFILES_DIR"/iterm/com.googlecode.iterm2.plist ]
then
    sed "s;/Users/carlos;$HOME;g" \
        "$DOTFILES_DIR"/iterm/com.googlecode.iterm2.plist.example >"$DOTFILES_DIR"/iterm/com.googlecode.iterm2.plist
    defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "$DOTFILES_DIR/iterm"
    defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
fi
