# git setup
Typical command aliases I use with git.

```bash
git config --global alias.st status
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.ci "commit -a -m"
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
git config --global alias.lol "log --pretty=oneline --abbrev-commit --graph --decorate"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.su "submodule update --init --recursive"
git config --global alias.remotes "remote -v"
git config --global help.autocorrect 0
```
