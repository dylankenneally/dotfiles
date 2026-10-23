#!/usr/bin/env bash
#
# snapshot this machine's dotfiles, settings and package lists into the repo
# - safe on macOS and Windows (git-bash): VS Code settings and package lists are per OS, so one machine never overwrites another's
# - every file is generated into a temp file first, and only replaces the repo copy if the command succeeded with output
# - a dotfile or settings file that looks like it holds a secret stops the run; secrets live in ~/.secrets, which is never copied
# - nothing is staged or committed, review with `git diff` afterwards
#
# usage: ./update-repo.sh [dotfiles] [settings] [packages]   (no args = all)

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    echo "[dotfiles] run ./update-repo.sh rather than sourcing it" >&2
    return 1
fi

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source lib/common.sh

# usage: generate <dest> <command...>; replaces dest with the command's stdout (LF line endings) or fails, leaving dest untouched
generate() {
    local dest=$1
    shift
    local tmp
    tmp=$(mktemp)
    if ! "$@" >"$tmp"; then
        rm -f "$tmp"
        die "'$*' failed, $dest left untouched"
    fi
    if [[ ! -s $tmp ]]; then
        rm -f "$tmp"
        die "'$*' produced no output, $dest left untouched"
    fi

    mkdir -p "$(dirname "$dest")"
    tr -d '\r' <"$tmp" >"$dest"
    rm -f "$tmp"
    log "updated $dest"
}

# secrets belong in ~/.secrets (never copied), so refuse a file that looks like it holds one: a shell `X_TOKEN=...` / `X_PAT=...` or a JSON `"apiKey": "..."`
refuse_secrets() {
    local lines
    # line numbers only, so the secret itself isn't echoed to the terminal
    lines=$(grep -inE -e '^[[:space:]]*(export[[:space:]]+)?[a-z0-9_]*((token|secret|password|key)[a-z0-9_]*|_pat)=' -e '"[^"]*(token|secret|password|apikey|api_key)"[[:space:]]*:[[:space:]]*"[^"]+"' "$1" | cut -d: -f1 | paste -sd, - || true)
    if [[ -n $lines ]]; then
        die "$1 looks like it holds a secret on line(s) $lines, move it to ~/.secrets and re-run"
    fi
}

# brew can only dump to a file, so dump to a temp one and print it
brew_dump() {
    local tmp rc=0
    tmp=$(mktemp)
    brew bundle dump --force --file="$tmp" >/dev/null && cat "$tmp" || rc=$?
    rm -f "$tmp"
    return $rc
}

brewlist_md() {
    local descs
    descs=$(brew list | xargs -n1 brew desc --eval-all) || return 1

    echo '# Brew packages installed'
    echo
    echo 'The following packages are installed via `brew`, to install all of them run `brew bundle` - this will install them from the [Brewfile](../Brewfile).'
    echo
    echo "$descs"
    echo
    echo 'To generate the above list, run `brew list | xargs -n1 brew desc --eval-all`.'
}

# winget can only export to a file, and stamps it with the time; drop that so an unchanged machine gives an unchanged file
winget_export() {
    local tmp rc=0
    tmp=$(mktemp)
    winget export -o "$(cygpath -w "$tmp")" --accept-source-agreements --disable-interactivity >/dev/null && grep -v '"CreationDate"' "$tmp" || rc=$?
    rm -f "$tmp"
    return $rc
}

update_dotfiles() {
    local f
    for f in "${DOTFILES[@]}"; do
        if [[ ! -f "$HOME/$f" ]]; then
            skip "$f" "not found in $HOME"
            continue
        fi

        refuse_secrets "$HOME/$f"
        generate "$f" cat "$HOME/$f"
    done
}

update_settings() {
    local settings
    settings=$(vscode_settings_path)
    if [[ ! -f $settings ]]; then
        skip "$SETTINGS" "VS Code settings not found at $settings"
        return
    fi

    refuse_secrets "$settings"
    generate "$SETTINGS" cat "$settings"
}

update_os_packages() {
    case "$OS" in
        macos)
            if ! has brew; then
                skip "$BREWFILE" "'brew' not found"
                return
            fi
            generate "$BREWFILE" brew_dump
            generate "$BREWLIST" brewlist_md
            ;;
        windows)
            if ! has winget; then
                skip "$WINGET" "'winget' not found"
                return
            fi
            generate "$WINGET" winget_export
            ;;
    esac
}

update_packages() {
    update_os_packages

    local pip
    pip=$(pip_cmd)
    if [[ -n $pip ]]; then
        generate "$REQUIREMENTS" "$pip" freeze
    else
        skip "$REQUIREMENTS" "'pip3' / 'pip' not found"
    fi

    if has code; then
        generate "$VSCODE_EXTENSIONS" code --list-extensions
    else
        skip "$VSCODE_EXTENSIONS" "'code' not found"
    fi
}

parse_sections "dotfiles settings packages" "$@"
log "updating the repo from this $OS machine: ${REQUESTED[*]}"

if wants dotfiles; then
    update_dotfiles
fi
if wants settings; then
    update_settings
fi
if wants packages; then
    update_packages
fi

report_skipped
log "done, review the changes with: git status && git diff"
