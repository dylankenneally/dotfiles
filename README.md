# dotfiles and notes my dev env

Here to make it easier for me to setup new developer environments quickly, _probably of no use to anyone but me._

## Software to install

- [Visual Studio Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)
- [Brew](https://brew.sh/) (on macOS)
- [Python](https://www.python.org/)
- [Node](https://nodejs.org/en)
- [Chrome](https://www.google.com/intl/en_au/chrome/)
- [Docker](https://www.docker.com/)

## tl;dr: once the above are installed, run this for a quick setup

### Installing dotfiles

**NB:** this _replaces_ the systems current dotfiles.

```bash
# copy dotfiles to the repo
cp .bash_profile ~/.bash_profile
cp .bashrc ~/.bashrc
cp .gitconfig ~/.gitconfig
cp .editorconfig ~/.editorconfig
```

### Installing common packages/settings

```bash
brew bundle
pip install -r requirements.txt
source ./install_vscode_extensions.sh
cp settings.json ~/Library/Application\ Support/Code/User/settings.json
```

## Details: once the software above is installed, run this for a typical setup

### After Brew has been installed (on macOS)

The following packages are installed via `brew`, to install all of them run `brew bundle` - this will install them from the [Brewfile](./Brewfile).

- bash: Bourne-Again SHell, a UNIX command interpreter
- bat: Clone of cat(1) with syntax highlighting and Git integration
- exa: Modern replacement for 'ls'
- git: Distributed revision control system
- gnupg: GNU Pretty Good Privacy (PGP) package
- htop: Improved top (interactive process viewer)
- httpie: User-friendly cURL replacement (command-line HTTP client)
- imagemagick: Tools and libraries to manipulate images in many formats
- nginx: HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server
- rename: Perl-powered file rename script with many helpful built-ins
- thefuck: Programmatically correct mistyped console commands
- tldr: Simplified and community-driven man pages
- tree: Display directories as trees (with optional color/HTML output)
- wget: Internet file retriever

To generate the above list, run `brew leaves | xargs -n1 brew desc --eval-all`.

#### Working with Brewfile's

```bash
# creates Brewfile in the current directory from currently-installed packages
brew bundle dump

# install everything from the Brewfile
brew bundle
```

### After Python has been installed

Typical python packages are listed in [requirements.txt](./requirements.txt).

```bash
pip install -r requirements.txt
```

#### Working with `requirements.txt`

```bash
# create a requirements file in the current directory from currently-installed packages
pip freeze > requirements.txt

# install everything from the requirements file
pip install -r requirements.txt
```

### After Visual Studio Code has been installed (on macOS)

#### Install typical extensions

Typical python packages are listed in [vscode.extensions](./vscode.extensions), and can be installed by running [`source ./install_vscode_extensions.sh`](./install_vscode_extensions.sh).

To update the extensions list: `code --list-extensions > vscode.extensions`.

#### Install typical settings

Place the [settings file](./settings.json) in the following locations:

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

## Windows OS

Been a few years since I've developed on Windows, the below was handy then, may be handy in future.

- [7-zip](https://www.7-zip.org/download.html)
- [curl](https://curl.haxx.se/windows/)
- [Dependency Walker](http://www.dependencywalker.com/)
- [Process Explorer](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- [Cpp Check](http://cppcheck.sourceforge.net/)
- [paint.net](https://www.getpaint.net/)
- [WinDiff / WinMerge](https://portableapps.com/apps/utilities/winmerge_portable)

## Updating this repo

When new items are installed/removed from your dev env, or just periodically, run the following to update this repo with a snapshot of the current system

```bash
# copy dotfiles to the repo
cp ~/.bash_profile .
cp ~/.bashrc .
cp ~/.gitconfig .

# update package files
brew bundle dump
pip freeze > requirements.txt
code --list-extensions > vscode.extensions

# copy settings files
cp ~/Library/Application\ Support/Code/User/settings.json .
```
