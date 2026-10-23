#!/usr/bin/env bash
#
# install this repo's dotfiles, settings and packages onto this machine (macOS or Windows git-bash)
# - files that would be overwritten, and differ, are backed up to ~/.dotfiles-backup/<timestamp>/ first
# - VS Code settings and packages come from this OS's files (settings.<os>.json, Brewfile or winget.json, requirements.<os>.txt, vscode.<os>.extensions)
# - missing tools are skipped and reported at the end, re-run the section once they're installed
#
# usage: ./install.sh [dotfiles] [settings] [packages]   (no args = all)

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    echo "[dotfiles] run ./install.sh rather than sourcing it" >&2
    return 1
fi

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source lib/common.sh

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# usage: install_file <repo file> <destination>; backs up the destination first if it exists and differs
install_file() {
    local src=$1 dest=$2
    if [[ -f $dest ]] && ! cmp -s "$src" "$dest"; then
        mkdir -p "$BACKUP_DIR"
        cp "$dest" "$BACKUP_DIR/$(basename "$dest")"
        log "backed up $dest to $BACKUP_DIR"
    fi

    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    log "installed $dest"
}

# the repo copy has secrets blanked out by update-repo.sh, so point out which ones need setting again
warn_redacted() {
    local f lines
    for f in "$@"; do
        lines=$(grep -n 'REDACTED' "$f" || true)
        if [[ -n $lines ]]; then
            log "$f has redacted values, set them in $HOME/$(basename "$f"):"
            echo "$lines" | sed 's/^/  /'
        fi
    done
}

install_dotfiles() {
    local f
    for f in "${DOTFILES[@]}"; do
        install_file "$f" "$HOME/$f"
    done
    warn_redacted "${DOTFILES[@]}"
}

install_settings() {
    if [[ ! -f $SETTINGS ]]; then
        skip "$SETTINGS" "not in the repo yet, run ./update-repo.sh on a $OS machine first"
        return
    fi

    install_file "$SETTINGS" "$(vscode_settings_path)"
}

install_os_packages() {
    case "$OS" in
        macos)
            if ! has brew; then
                skip "$BREWFILE" "'brew' not found, install it from https://brew.sh"
                return
            fi
            brew bundle --file="$BREWFILE"
            ;;
        windows)
            if ! has winget; then
                skip "$WINGET" "'winget' not found, install 'App Installer' from the Microsoft Store"
                return
            fi
            if [[ ! -f $WINGET ]]; then
                skip "$WINGET" "not in the repo yet, run ./update-repo.sh on a Windows machine first"
                return
            fi
            winget import -i "$(cygpath -w "$WINGET")" --accept-package-agreements --accept-source-agreements --ignore-unavailable --ignore-versions --disable-interactivity
            ;;
    esac
}

install_vscode_extensions() {
    if ! has code; then
        skip "$VSCODE_EXTENSIONS" "'code' not found, install VS Code and its 'code' command"
        return
    fi
    if [[ ! -f $VSCODE_EXTENSIONS ]]; then
        skip "$VSCODE_EXTENSIONS" "not in the repo yet, run ./update-repo.sh on a $OS machine first"
        return
    fi

    local ext
    while IFS= read -r ext || [[ -n $ext ]]; do
        ext=${ext%$'\r'}
        if [[ -z $ext ]]; then
            continue
        fi
        # stdin from /dev/null so code can't swallow the rest of the list
        code --install-extension "$ext" </dev/null
    done <"$VSCODE_EXTENSIONS"
}

install_python_packages() {
    local pip
    pip=$(pip_cmd)
    if [[ -z $pip ]]; then
        skip "$REQUIREMENTS" "'pip3' / 'pip' not found, install python"
        return
    fi
    if [[ ! -f $REQUIREMENTS ]]; then
        skip "$REQUIREMENTS" "not in the repo yet, run ./update-repo.sh on a $OS machine first"
        return
    fi

    "$pip" install -r "$REQUIREMENTS"
}

install_packages() {
    install_os_packages
    install_vscode_extensions
    install_python_packages
}

parse_sections "dotfiles settings packages" "$@"
log "installing onto this $OS machine: ${REQUESTED[*]}"

if wants dotfiles; then
    install_dotfiles
fi
if wants settings; then
    install_settings
fi
if wants packages; then
    install_packages
fi

report_skipped
if [[ -d $BACKUP_DIR ]]; then
    log "replaced files were backed up to $BACKUP_DIR"
fi
log "done, open a new shell to pick up the dotfiles"
