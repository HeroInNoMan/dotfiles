# ~/.bashrc: executed by bash(1) for non-login shells.

# ENABLE COLOR SUPPORT OF LS AND ALSO ADD HANDY ALIASES
#######################################################
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# SOME MORE LS ALIASES
#######################################################
alias ls='ls -hF --color'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# ALIASES FOR TASKWARRIOR
#######################################################
alias cal='task cal'
alias tl='task long'

# CONVENIENCE ALIASES
#######################################################
alias du='du -h'
alias df='df -hT'
alias e='emacsclient -t'
alias ec='emacsclient'
alias EC="SUDO_EDITOR=\"emacsclient -a emacs\" sudoedit"
alias E="SUDO_EDITOR=\"emacsclient -t -a emacs\" sudoedit"
alias emacs='emacs -nw'
alias tremote='transmission-remote'
alias sr='surfraw -browser=w3m'

# GIT
#######################################################
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gl='git lg '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias co='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
