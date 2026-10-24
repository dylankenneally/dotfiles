# Easy Complete pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/easy-complete/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/easy-complete/shell/bash_profile.pre.bash"

# brew installed items go in front of the older macOS system versions (bash 3.2, Xcode's git and python); NB: macOS only, guarded
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$PATH:~/.local/bin

# add VS code to the path; NB: macOS only, not Linux path
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# python.org's python 3.11 goes in front of brew's and Xcode's; NB: macOS only, not Linux path
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH

# Java Development Kit, via Zulu, ref: https://reactnative.dev/docs/environment-setup?guide=native&platform=android
if [[ -d /Library/Java/JavaVirtualMachines/zulu-17.jdk ]]; then
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
fi

# Android development, ref: https://reactnative.dev/docs/environment-setup?guide=native&platform=android
if [[ -d $HOME/Library/Android/sdk ]]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools
fi

# silence apple message about switching to zsh (z shell), I'm happy with bash, which I keep up to date, https://itnext.io/upgrading-bash-on-macos-7138bd1066ba
export BASH_SILENCE_DEPRECATION_WARNING=1

# setup the interactive shell
test -f ~/.bashrc && builtin source ~/.bashrc

# stuff that would be available via brew, but needed to use pip (python) on Windows
export PATH=$PATH:~/AppData/Local/Python/pythoncore-3.14-64/Scripts/

# secrets (e.g. `export NPM_TOKEN=...`) live in ~/.secrets, which is never copied into the repo
[[ -f ~/.secrets ]] && builtin source ~/.secrets

# Easy Complete post block. Keep near the bottom of this file.
[[ -f "${HOME}/Library/Application Support/easy-complete/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/easy-complete/shell/bash_profile.post.bash"
