#!/bin/sh

# copy dotfiles to the repo
cp ~/.bash_profile .
cp ~/.bashrc .
cp ~/.gitconfig .
cp ~/.editorconfig .
cp ~/.prettierrc.js .

# update package files & doco re. them
rm Brewfile
brew bundle dump
pip3 freeze > requirements.txt
code --list-extensions > vscode.extensions

[ -d doco ] || mkdir doco
echo "# Brew packages installed" > ./doco/brewlist.md
echo "" >> ./doco/brewlist.md
echo "The following packages are installed via \`brew\`, to install all of them run \`brew bundle\` - this will install them from the [Brewfile](../Brewfile)." >> ./doco/brewlist.md
echo "" >> ./doco/brewlist.md
brew list | xargs -n1 brew desc --eval-all >> ./doco/brewlist.md
echo "" >> ./doco/brewlist.md
echo "To generate the above list, run \`brew list | xargs -n1 brew desc --eval-all\`." >> ./doco/brewlist.md

# copy settings files
cp ~/Library/Application\ Support/Code/User/settings.json .

# copy aliases
# NB: a bare `alias` only lists aliases defined in the *current* shell. This script
#     runs non-interactively under /bin/sh, which never sources ~/.bashrc, so `alias`
#     here would dump nothing. Instead, pull the alias definitions straight out of
#     ~/.bashrc (the source of truth) - no sourcing, so no side effects (thefuck,
#     Kiro shell integration, etc.) that could hang or misbehave non-interactively.
echo "#!/bin/sh" > ./aliases.sh
echo "" >> ./aliases.sh
grep -E '^alias ' ~/.bashrc >> ./aliases.sh
