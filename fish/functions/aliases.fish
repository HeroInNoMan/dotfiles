# ENABLE COLOR SUPPORT OF LS AND ALSO ADD HANDY ALIASES
#######################################################
alias ls 'ls --color=auto'
alias dir 'ls --color=auto --format=vertical'

# SOME MORE LS ALIASES
#######################################################
alias l 'ls -CF'
alias la 'ls -A'
alias ll 'ls -l'
alias lla 'ls -lA'
alias ls 'ls -hF --color'

# CONVENIENCE ALIASES
#######################################################
alias df 'df -hT'
alias du 'du -h'
alias sr 'surfraw -browser=w3m'
alias agi 'apt install'
alias fucking 'sudo'
alias grep 'grep --color'
alias maj 'sudo apt update; sudo apt -y upgrade; sudo apt -y dist-upgrade; sudo apt-get -y autoremove'
alias bepo 'setxkbmap fr bepo -option; xmodmap ~/.Xmodmap'
alias beponocaps 'setxkbmap fr bepo -option ctrl:nocaps; xmodmap ~/.Xmodmap'

# EMACS
#######################################################
alias emacs 'emacs -nw'
alias e 'emacsclient -nw'
alias ec 'emacsclient -c'
# alias E 'SUDO_EDITOR=\"emacsclient -nw -a emacs\" sudoedit'
# alias EC 'SUDO_EDITOR=\"emacsclient -a emacs\" sudoedit'

# GIT
#######################################################
alias co 'git checkout'
alias ga 'git add'
alias gb 'git branch'
alias gba 'git branch -avv'
alias gc 'git commit'
alias gd 'git diff'
alias gf 'git fetch'
alias gi 'git rebase --interactive'
alias gk 'gitk --all&'
alias gl 'git lg'
alias gla 'git lga'
alias glf 'git lf'
alias glfa 'git lfa'
alias glm 'git lg --max-count=10'
alias glma 'git lga --max-count=10'
alias gm 'git merge'
alias go 'git checkout'
alias gp 'git pull'
alias gpp 'git push'
alias gr 'git rebase'
alias gs 'git status -sb'
alias gt 'git stash'
alias gu 'git up'
alias gx 'gitx --all'
alias gw 'git diff --word-diff=color'

# MAVEN
#######################################################
alias mc 'mvn clean compile'
alias md 'maven-debug'
alias me 'maven-eclipse'
alias mi 'mvn clean install'
alias mic 'mvn clean install cf:push'
alias mie 'maven-install-eclipse'
alias mp 'mvn clean package'
alias mt 'mvn test'

# PYTHON
#######################################################
alias python 'python3'
