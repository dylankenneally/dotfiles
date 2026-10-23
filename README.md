# dotfiles and notes on my dev env

Here to make it easier for me to setup new developer environments quickly, _probably of no use to anyone but me._

## Quick setup (recommended)

Quick setup details: software to install, config/dotfiles & packages

### Software to install

- [Visual Studio Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)
- [Brew](https://brew.sh/) (on macOS)
- [Python](https://www.python.org/)
- [Node](https://nodejs.org/en)
- [Chrome](https://www.google.com/intl/en_au/chrome/)
- [Docker](https://www.docker.com/)

### Install the repo onto a machine

Works on macOS and on Windows (from `git-bash`).

```bash
git clone https://github.com/dylankenneally/dotfiles.git
cd dotfiles
./install.sh                     # everything
./install.sh dotfiles settings   # or just some sections: dotfiles, settings, packages
```

- **dotfiles** copies the dotfiles to your home directory. These are shared by every OS.
- **settings** copies this OS's editor settings into place.
- **packages** installs this OS's system, editor and python packages.

Files that are shared by every OS sit in the repo as-is; files that are specific to an OS are named for it (e.g. `*.macos.*`, `*.windows.*`). The list of what goes where lives in [lib/common.sh](./lib/common.sh).

Any file that would be replaced, and differs, is backed up to `~/.dotfiles-backup/<timestamp>/` first. Missing tools are skipped and listed at the end, so install them and re-run that section.

Secrets (tokens, passwords, keys) never go in the repo. Put them in `~/.secrets` (e.g. `export NPM_TOKEN=...`), which `.bash_profile` sources and neither script copies.

## Detailed setup

Install the software above, then cherry pick from below

### Typical brew packages (macOS)

A full list of packages installed via `brew` can be found in the [doco folder](./doco/brewlist.md). To install all of them, run `brew bundle` - this will install them from the [Brewfile](./Brewfile).

#### Working with Brewfile's

```bash
# creates Brewfile in the current directory from currently-installed packages
brew bundle dump --force

# install everything from the Brewfile
brew bundle
```

### Typical winget packages (Windows)

Packages installed via `winget` are listed in [winget.json](./winget.json). To install all of them, run `winget import -i winget.json`.

### Typical python packages

Typical python packages are listed per OS, in `requirements.<os>.txt`, and are installed by `./install.sh packages`.

### Typical Visual Studio Code extensions

Typical extensions are listed per OS, in `vscode.<os>.extensions`, and are installed by `./install.sh packages`.

### Typical Visual Studio Code settings

Settings are kept per OS, in `settings.<os>.json`. `./install.sh settings` places this OS's file in the following locations:

- macOS `$HOME/Library/Application\ Support/Code/User/settings.json`
- Linux `$HOME/.config/Code/User/settings.json`
- Windows `%APPDATA%\Code\User\settings.json`

### Working with editors (including Visual Studio Code)

There is a default [editorconfig](https://editorconfig.org/) file in [this repo](.editorconfig), with sensible overrides - particularly if you are using [Prettier](https://prettier.io/). Simple copy it to your code location (or your home directory).

### Working with Docker

The [.bashrc](./.bashrc) files includes a couple of Docker helper functions:

`dockershell`: start containers in an interactive shell.
`dockermappedshell`: start containers in an interactive shell, with the current directory is mapped into the container.

Examples:

```bash
dockershell centos
dockershell node
dockershell nginx
dockershell your-container

dockermappedshell centos
dockermappedshell node
dockermappedshell nginx
dockermappedshell your-container
```

### Working on Windows OS

#### From 10th June 2026

Based on using `git-bash` on Windows 11.

```bash
bash: thefuck: command not found
bash: rbenv: command not found
# removed them from bash files in ~/
```

Installed:

- `bat` winget install sharkdp.bat
- `eza` winget install eza-community.eza
- [Process explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
  - Installed to `C:\Utils`
- [WinDiff / WinMerge](https://portableapps.com/apps/utilities/winmerge_portable)
- [tldr](https://tldr.sh/#installation)
- [Sourcetree](https://www.atlassian.com/software/sourcetree)
- [HTTPPie](https://httpie.io/docs/cli/pypi), `pip install httpie`
- [postman](https://www.postman.com/downloads/)

#### Pre 10th June 2026

Been a few years since I've developed on Windows, the below was handy then, may be handy in future.

- [7-zip](https://www.7-zip.org/download.html)
- [curl](https://curl.haxx.se/windows/)
- [Dependency Walker](http://www.dependencywalker.com/)
- [Process Explorer](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- [Cpp Check](http://cppcheck.sourceforge.net/)
- [paint.net](https://www.getpaint.net/)
- [WinDiff / WinMerge](https://portableapps.com/apps/utilities/winmerge_portable)

## Updating this repo

When new items are installed/removed from your dev env, or just periodically, run the following (on macOS or Windows) to update this repo with a snapshot of the current system, then review it with `git diff` before committing.

```bash
./update-repo.sh                    # everything
./update-repo.sh dotfiles packages  # or just some sections: dotfiles, settings, packages
```

- The dotfiles are shared by every OS, so keep OS-specific lines in them safe to run elsewhere (e.g. guarded by `[[ -f ... ]]` or `[[ -d ... ]]`).
- Editor settings and package lists are per OS, so a run on one machine never touches another's.
- A file is only replaced when its command succeeds with output, so a missing or failing tool can't empty it.
- A dotfile or settings file that looks like it holds a secret stops the run, move the secret to `~/.secrets` and re-run.
