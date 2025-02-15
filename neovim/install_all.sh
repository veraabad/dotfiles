#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

for dir in "$SCRIPT_DIR"/*/; do
    [ -d "$dir" ] || continue  # Skip non-directory files

    dir_name="$(basename "$dir")"
    target_dir="$CONFIG_DIR/$dir_name"

    echo "Setting up $target_dir..."

    if [ -d "$target_dir" ]; then
        read -p "Directory $target_dir exists. Delete it? (y/n): " choice
        case "$choice" in
            y|Y ) rm -rf "$target_dir";;
            n|N ) echo "Keeping $target_dir"; continue;;
            * ) echo "Invalid choice, skipping $dir_name"; continue;;
        esac
    fi

    mkdir -p "$target_dir"

    stow --restow --target="$target_dir" -d "$SCRIPT_DIR" "$dir_name"
done
