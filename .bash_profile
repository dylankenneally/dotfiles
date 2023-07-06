# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bash_profile.pre.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.pre.bash"

# setup the interactive shell
test -f ~/.bashrc && builtin source ~/.bashrc

# add VS code to the path; NB: macOS only, not Linux path
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# add python 3 (v3.10) to the front path as XCode has v2.x in there first; NB: macOS only, not Linux path
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

# for fig
export PATH=$PATH:~/.local/bin

# Java Development Kit, via Zulu, ref: https://reactnative.dev/docs/environment-setup?guide=native&platform=android
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

# Android development, ref: https://reactnative.dev/docs/environment-setup?guide=native&platform=android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# silence apple message about switching to zsh (z shell), I'm happy with bash, which I keep up to date, https://itnext.io/upgrading-bash-on-macos-7138bd1066ba
export BASH_SILENCE_DEPRECATION_WARNING=1

# Git commit signing - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
export GPG_TTY=$(tty)

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bash_profile.post.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.post.bash"
