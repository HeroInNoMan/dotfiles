#######################################################
# .bashrc file
# #
# Last Modified 25-09-2010
# Running on Debian
#######################################################

# Misc config
#######################################################
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# load additional files
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ignore case on completion
bind 'set completion-ignore-case on'

# Sets the Mail Environment Variable
MAIL=/var/spool/mail/duncan && export MAIL

# add home-made scripts to path
export PATH=$HOME/Terminalcity/scripts:$PATH
export PATH=$HOME/usr/bin:$PATH

# switch to 256 color term (especially for using emacs inside term)
export TERM=screen-256color

# add ssh key to agent
eval $(ssh-agent) > /dev/null
eval $(ssh-add ~/.ssh/al_polo_rsa &> /dev/null)

# Define a few Color's
#######################################################

BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color

# PROMPT (bolidage de jackie)
#######################################################

RET_SMILEY='$(if [[ $? = 0 ]]; then echo -ne "\[$GREEN\]:)"; else echo -ne "\[$RED\]:("; fi;)'

# other PS1 confuses tramp
# PS1="> "

PS1="\[\033[1;30m\](\[\033[1;32m\]\u\[\033[1;30m\]@\[\033[0;36m\]\h:\[\033[0;33m\]\!\[\033[1;30m\])*(\[\033[0;36m\]\A\[\033[1;30m\])*(\[\033[0;36m\]\j\[\033[1;30m\])(\[\033[0;36m\]\w\[\033[1;30m\])\n\[\033[1;30m\]($RET_SMILEY\[\033[1;30m\])\[\033[0m\] "

# SPECIAL FUNCTIONS
#######################################################

netinfo ()
{
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet addr/ {print $2}'
    echo ""
    /sbin/ifconfig | awk /'Bcast/ {print $3}'
    echo ""
    /sbin/ifconfig | awk /'inet addr/ {print $4}'

    # /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
}

spin ()
{
    echo -ne "${RED}-"
    echo -ne "${WHITE}\b|"
    echo -ne "${BLUE}\bx"
    sleep .02
    echo -ne "${RED}\b+${NC}"
}

scpsend ()
{
    scp -P PORTNUMBERHERE "$@"
    USERNAME@YOURWEBSITE.com:/var/www/html/pathtodirectoryonremoteserver/;
}

# WELCOME SCREEN
#######################################################

# clear
# for i in `seq 1 15` ; do spin; done ;echo -ne "${WHITE} Welcome to the real world. ${NC}"; for i in `seq 1 15` ; do spin; done ;echo "";
# echo -ne ${LIGHTBLUE}"Debian version ";
# echo -e ${LIGHTBLUE}`cat /etc/debian_version` ;
# echo -e "Kernel Information: " `uname -smr`;
# echo -e ${LIGHTBLUE}`bash --version`;
# echo -ne "Connecté en tant que $USER.
# Date : "; date
# echo -ne "${LIGHTBLUE}Uptime : ";uptime | awk /'up/
# {print $3,$4}'
