#!/bin/sh

# copy dotfiles to the repo
cp ~/.bash_profile .
cp ~/.bashrc .
cp ~/.gitconfig .

# update package files
rm Brewfile
brew bundle dump
pip3 freeze > requirements.txt
code --list-extensions > vscode.extensions

# copy settings files
cp ~/Library/Application\ Support/Code/User/settings.json .

# copy aliases
echo "#!/bin/sh" > ./aliases.sh
echo "" >> ./aliases.sh
alias >> ./aliases.sh
