# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"

# lazy navigation
alias ..="cd .."

# show all files (-a), in list format (-l), with annotation for types (-F) and colorized output (--color=always)
# NB: don't use -G for colour output, as -G means grid in exa (below)
alias ll='ls -alF --color=always'

# use exa instead of ls, https://the.exa.website/
alias ls=exa

# use bat instead of cat, https://github.com/sharkdp/bat
alias cat=bat

# Always enable coloured `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# read the fucking manual (rtfm) has been in my vocabulary my entire career, too long didn't read (tldr) hasn't.
# also, I find "tldr" rude, odd how I don't find find "rtfm" rude, even though it clearly is...
alias rtfm=tldr

# because my first terminal was DOS 3.2, and I still can't get past these two
alias cls=clear
alias where=which

# running a shell in a shell? state how many
# NB: output intended for use in prompts (PS1/PS2)
get_shell_count_display() {
    [[ $SHLVL != 1 ]] && echo "x$SHLVL"
}

# returns the current git branch, for use in the prompt below
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Docker CLI helpers, start containers in an interactive shell
# Note that bash is used, so it will need to be the container being started
# Examples:
#   dockershell centos
#   dockershell node
#   dockershell nginx
#   dockershell your-container
# Example of bash not being present
#   dockershell hello-world # docker example container - has no `bash`, hence fails
#
# Examples where the current directory is mapped into the container
#   dockermappedshell [centos | node | nginx | your-container]
# Example of bash not being present
#   dockermappedshell hello-world # docker example container - has no `bash`, hence fails

function dockershell() {
    docker run --rm -i -t --entrypoint=/bin/bash "$@"
}

function dockermappedshell() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}

# use my preferred prompt, includes the nested shell count & the current git branch
# bash PS1 generator/helper at: https://kirsle.net/wizards/ps1.html
export PS1="\[$(tput setaf 5)\]\$(get_shell_count_display)➜ \[$(tput setaf 6)\]\w\[$(tput setaf 3)\]\$(parse_git_branch) \[$(tput sgr0)\]"
export PS2="\[$(tput setaf 5)\]\$(get_shell_count_display)➜➜ \[$(tput sgr0)\]"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"

eval "$(thefuck --alias)"
