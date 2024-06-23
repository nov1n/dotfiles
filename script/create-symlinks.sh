#!/usr/bin/env bash

# Ensure DOTFILES_HOME is set
if [ -z "$DOTFILES_HOME" ]; then
    echo "Please set DOTFILES_HOME environment variable."
    exit 1
fi

# Initialize dry run mode
DRY_RUN=false

# Check for --dry-run flag
for arg in "$@"; do
    if [ "$arg" == "--dry-run" ]; then
        DRY_RUN=true
    fi
done

# Function to create symlink and backup existing files if necessary
create_symlink() {
    local src=$1
    local dst=$2

    if [ "$DRY_RUN" = true ]; then
        echo "Would create symlink: $dst -> $src"
        return
    fi

    # If destination exists and is not a symlink, back it up
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "Backing up existing file/directory: $dst to $dst.bak"
        mv "$dst" "$dst.bak"
    fi

    # Create the parent directory if it doesn't exist
    mkdir -p "$(dirname "$dst")"

    # Create the symlink
    ln -fvs "$src" "$dst"
}

echo "-- Linking files in home directory --"
# Find and link files in the root of the dotfiles directory
find "$DOTFILES_HOME" -mindepth 1 -maxdepth 1 -type f | while read -r file; do
    src=$(readlink -f "$file")
    dst="$HOME/$(basename "$file")"
    create_symlink "$src" "$dst"
done

echo "-- Linking directories in ~/.config --"
# Find and link directories in the .config directory of dotfiles
find "$DOTFILES_HOME/.config" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    src=$(readlink -f "$dir")
    dst="$HOME/.config/$(basename "$dir")"
    create_symlink "$src" "$dst"
done

echo "-- Linking .git_hooks --"
create_symlink "$(readlink -f "$DOTFILES_HOME/.git_hooks")" "$HOME/.git_hooks"

echo "-- Linking .local/bin --"
mkdir -p "$HOME/.local"
create_symlink "$(readlink -f "$DOTFILES_HOME/.local/bin")" "$HOME/.local/bin"

echo "-- Linking .vimrc to .ideavimrc --"
create_symlink "$HOME/.vimrc" "$HOME/.ideavimrc"

echo "All dotfiles have been symlinked."
