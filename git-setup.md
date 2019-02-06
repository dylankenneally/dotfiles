# git setup
Typical command aliases/settings I use with git.

```bash
# been bitten too many times with autocorrect - turning it off
git config --global help.autocorrect 0

# short-cuts for common commands
git config --global alias.st status
git config --global alias.br branch
git config --global alias.co checkout

# stage changes and commit with message, use as `git ci "Did cool stuff"`
#   `-a` auto stage modified/deleted (`git rm ...`) files; does _not_ auto `git add ...`
#   `-m` for the commit message
git config --global alias.ci "commit -a -m"

# update sub-modules so they point to the correct commit for the master / parent repo
git config --global alias.su "submodule update --init --recursive"

# verbose remote details - very handy if you work with multiple remotes for given repo
git config --global alias.remotes "remote -v"

# `git log` helpers
#   `git hist` - short, simple
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
#   `git lol` - short, simple, colourful
git config --global alias.lol "log --pretty=oneline --abbrev-commit --graph --decorate"
#   `git lg` - short, simple, colourful, with how long ago the commit was
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```
