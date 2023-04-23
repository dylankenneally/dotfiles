# setup the interactive shell
test -f ~/.bashrc && builtin source ~/.bashrc

# add VS code to the path; NB: macOS only, not Linux path
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# add python 3 (v3.10) to the front path as XCode has v2.x in there first; NB: macOS only, not Linux path
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

# silence apple message about switching to zsh (z shell), I'm happy with bash, which I keep up to date, https://itnext.io/upgrading-bash-on-macos-7138bd1066ba
export BASH_SILENCE_DEPRECATION_WARNING=1

# Git commit signing - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
export GPG_TTY=$(tty)
