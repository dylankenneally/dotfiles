# bash profile I typically use, either replace/merge it with your user profile at ~/.bash_profile,
# or have that one call this one via  "source <path-to-this-file>"

# show all files (-a), in list format (-l), with annotation for types (-F) and colorized output (-G)
alias ll='ls -alFG'

# add VS code to the path; NB: macOS only, not Linux path
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# show user name, directory and git branch (if in a repo)
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \[\033[33;1m\]\w\[\033[m\] (\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)) \$ "

# add python 3 (v3.10) to the front path as XCode has v2.x in there first; NB: macOS only, not Linux path
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

# silence apple message about switching to zsh (z shell), I'm happy with bash; NB: macOS only, not Linux path
export BASH_SILENCE_DEPRECATION_WARNING=1
