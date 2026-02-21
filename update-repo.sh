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
echo "#!/bin/sh" > ./aliases.sh
echo "" >> ./aliases.sh
alias >> ./aliases.sh
