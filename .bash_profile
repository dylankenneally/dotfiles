# bash profile I typically use, either put in the root (~), or from the ~/.bash_profile already there, call it via "source <path-to-this-file>"

# show all files in list format
alias ll='ls -al'

# NB: add VS code to the path; NB: macOS only, not Linux path
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# show user name, directory and git branch (if in a repo)
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \[\033[33;1m\]\w\[\033[m\] (\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)) \$ "
