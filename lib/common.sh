#!/usr/bin/env bash
#
# shared by install.sh and update-repo.sh, so both agree on what lives where
# - shared files: the dotfiles are the same on every OS (OS-specific lines in them guard themselves)
# - per-OS files: VS Code settings, the alias snapshot and package lists are named by OS, so a run on one machine never overwrites another's

# dotfiles that live in $HOME and are mirrored, as-is, in the repo root
DOTFILES=(.bash_profile .bashrc .gitconfig .gitconfig-personal .gitconfig-work .editorconfig .prettierrc.js)

log() { echo "[dotfiles] $*"; }

# fail fast: log, then exit non-zero
die() {
    echo "[dotfiles] error: $*" >&2
    exit 1
}

has() { command -v "$1" >/dev/null 2>&1; }

# usage: skip <what> <why>; things skipped (e.g. a missing tool) are reported again at the end so they aren't lost in the scroll
SKIPPED=()
skip() {
    log "skipping $1: $2"
    SKIPPED+=("$1: $2")
}

report_skipped() {
    if [[ ${#SKIPPED[@]} -eq 0 ]]; then
        return
    fi

    log "skipped (fix the cause and re-run that section):"
    printf '  - %s\n' "${SKIPPED[@]}"
}

detect_os() {
    case "$(uname -s)" in
        Darwin) echo macos ;;
        MINGW* | MSYS* | CYGWIN*) echo windows ;;
        *) die "unsupported OS '$(uname -s)', only macOS and Windows (git-bash) are supported" ;;
    esac
}

OS=$(detect_os)

# per-OS files, relative to the repo root
SETTINGS="settings.$OS.json"
ALIASES="aliases.$OS.sh"
REQUIREMENTS="requirements.$OS.txt"
VSCODE_EXTENSIONS="vscode.$OS.extensions"
BREWFILE="Brewfile"
BREWLIST="doco/brewlist.md"
WINGET="winget.json"

vscode_settings_path() {
    case "$OS" in
        macos) echo "$HOME/Library/Application Support/Code/User/settings.json" ;;
        windows) echo "$(cygpath -u "$APPDATA")/Code/User/settings.json" ;;
    esac
}

# pip3 on macOS, pip3 or pip on Windows depending on how python was installed
pip_cmd() {
    if has pip3; then
        echo pip3
    elif has pip; then
        echo pip
    fi
}

# usage: parse_sections "<allowed sections>" "$@" -> REQUESTED array (no args means all of them)
parse_sections() {
    local allowed=$1
    shift
    REQUESTED=("$@")
    if [[ ${#REQUESTED[@]} -eq 0 ]]; then
        read -r -a REQUESTED <<<"$allowed"
    fi

    local s
    for s in "${REQUESTED[@]}"; do
        if [[ " $allowed " != *" $s "* ]]; then
            die "unknown section '$s', expected one or more of: $allowed"
        fi
    done
}

wants() { [[ " ${REQUESTED[*]} " == *" $1 "* ]]; }
