#!/bin/bash
# install.sh - Symlink Claude Code configuration to ~/.claude/
#
# Run this after cloning the repo to set up your Claude Code CLI config.
# Symlinks ensure changes are tracked in git and visible across machines.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Claude Code configuration from: $SCRIPT_DIR"
echo ""

# Create ~/.claude if it doesn't exist
mkdir -p ~/.claude

# Items to symlink (safe, no secrets)
ITEMS="CLAUDE.md skills settings.local.json settings.json commands hooks"

for item in $ITEMS; do
    target="$HOME/.claude/$item"
    source="$SCRIPT_DIR/$item"

    # Check source exists
    if [ ! -e "$source" ]; then
        echo "SKIP: $item (not found in repo)"
        continue
    fi

    # Handle existing file/directory
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ]; then
            # Already a symlink - check if it points to us
            current_link=$(readlink "$target")
            if [ "$current_link" = "$source" ]; then
                echo "OK:   $item (already linked)"
                continue
            else
                echo "UPDATE: $item (was linked to $current_link)"
                rm "$target"
            fi
        else
            # Real file/directory - back it up
            backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
            echo "BACKUP: $item -> $backup"
            mv "$target" "$backup"
        fi
    fi

    # Create symlink
    ln -s "$source" "$target"
    echo "LINK: $item -> $source"
done

echo ""

# Handle bin items (symlink to ~/.local/bin/)
BIN_DIR="$SCRIPT_DIR/bin"
if [ -d "$BIN_DIR" ]; then
    mkdir -p ~/.local/bin

    for item in "$BIN_DIR"/*; do
        [ -e "$item" ] || continue
        name=$(basename "$item")
        target="$HOME/.local/bin/$name"
        source="$item"

        # Handle existing file
        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ -L "$target" ]; then
                current_link=$(readlink "$target")
                if [ "$current_link" = "$source" ]; then
                    echo "OK:   bin/$name (already linked)"
                    continue
                else
                    echo "UPDATE: bin/$name (was linked to $current_link)"
                    rm "$target"
                fi
            else
                backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
                echo "BACKUP: bin/$name -> $backup"
                mv "$target" "$backup"
            fi
        fi

        ln -s "$source" "$target"
        echo "LINK: bin/$name -> $source"
    done
fi

echo ""
echo "Done. Your ~/.claude/ now symlinks to this repo."
echo "      Your ~/.local/bin/ commands are also linked."
echo ""
echo "To verify:"
echo "  ls -la ~/.claude/CLAUDE.md"
echo "  ls -la ~/.claude/skills"
echo "  ls -la ~/.local/bin/cc"
echo ""
echo "Changes you make will be tracked in git. Remember to commit and push."
