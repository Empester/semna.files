#!/bin/bash

REPO_DIR="$(pwd)"
CONFIG_DIR="$REPO_DIR/.config"
HOME_DIR="$REPO_DIR/home"

install_files() {
    local source_dir=$1
    local target_dir=$2

    for src_file in "$source_dir"/*; do
        if [ -d "$src_file" ]; then
            local target_subdir="$target_dir/$(basename "$src_file")"
            mkdir -p "$target_subdir"
            install_files "$src_file" "$target_subdir"
        elif [ -f "$src_file" ]; then
            local target_file="$target_dir/$(basename "$src_file")"
            if [[ -e "$target_file" ]]; then
                echo "File $target_file already exists. Skipping..."
            else
                cp "$src_file" "$target_dir"
                echo "Installed $(basename "$src_file") to $target_dir"
            fi
        fi
    done
}

if [ ! -d "$REPO_DIR" ]; then
    echo "Error: This script must be run from the repository directory."
    exit 1
fi

install_files "$CONFIG_DIR" "$HOME/.config"
install_files "$HOME_DIR" "$HOME"

echo "Installation complete!"
