#!/usr/bin/env bash
# Install the scripts of this project into ~/.local/bin.
#
# Usage: ./install.sh [--copy]
#   default   symlink each script into ~/.local/bin (edits in the repo take effect immediately)
#   --copy    copy the scripts instead of symlinking them
set -euo pipefail

MODE=link
for arg in "$@"; do
    case "$arg" in
        --copy) MODE=copy ;;
        -h|--help) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
SELF="$(basename "${BASH_SOURCE[0]}")"

mkdir -p "$BIN_DIR"

# Ensure ~/.local/bin is on PATH (via ~/.profile).
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
        PROFILE="$HOME/.profile"
        if [ -f "$PROFILE" ] && grep -q 'linuxtools: add ~/.local/bin to PATH' "$PROFILE"; then
            echo "~/.local/bin is not in the current PATH, but $PROFILE already adds it; log out and back in."
        else
            echo "~/.local/bin is not in PATH; adding it to $PROFILE"
            {
                echo ''
                echo '# linuxtools: add ~/.local/bin to PATH'
                echo 'if [ -d "$HOME/.local/bin" ] ; then'
                echo '    case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac'
                echo 'fi'
            } >> "$PROFILE"
            echo "Run '. $PROFILE' or log out and back in for it to take effect."
        fi
        ;;
esac

# Install every script (regular file starting with a shebang) except this installer.
count=0
for src in "$SRC_DIR"/*; do
    name="$(basename "$src")"
    [ -f "$src" ] || continue
    [ "$name" = "$SELF" ] && continue
    [ "$(head -c 2 "$src")" = '#!' ] || continue

    dest="$BIN_DIR/$name"
    chmod +x "$src"
    if [ "$MODE" = copy ]; then
        rm -f "$dest"   # don't write through an existing symlink into the repo
        cp "$src" "$dest"
        chmod +x "$dest"
        echo "copied   $name -> $dest"
    else
        ln -sfn "$src" "$dest"
        echo "linked   $dest -> $src"
    fi
    count=$((count + 1))
done

echo "Installed $count script(s) into $BIN_DIR ($MODE mode)."
