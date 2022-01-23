# ==============================================================================
# Personal $HOME/.bashrc file by James Blair <mail@jamesblair.net>
# ==============================================================================

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -l --color=auto'
    alias ll='ls -l --color=auto'
fi

# simplify bitwarden cli usage 
alias bwu='export BW_SESSION=$(bw unlock --raw > ~/.bw_session && cat ~/.bw_session)'
function bwgp () { local test=$(export BW_SESSION=~/.bw_session) && bw get password "$1" | xclip -selection c; }
function bwgt () { local test=$(export BW_SESSION=~/.bw_session) && bw get totp "$1" | xclip -selection c; }
function bwgi () { local test=$(export BW_SESSION=~/.bw_session) && bw get item --pretty "$1"; }
function bwli () { local test=$(export BW_SESSION=~/.bw_session) && bw list items --search "$1" --pretty | egrep -i 'name|"id":'; }
function bwol () { local test=$(export BW_SESSION=~/.bw_session) && bw get item --pretty "$1" | grep https | awk '{print $2}' | xclip -selection c; }

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Configure display for vcxsrv in wsl
if [ $(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip') ]; then
    export DISPLAY=`grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0
fi

# Configure emacs location
export EMACSLOADPATH=~/Downloads/humacs:

# Setup prompt
function color_my_prompt {
    local __user_and_host="\[\033[01;32m\]\u@\h"
    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[31m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __prompt_tail="\[\033[35m\]$"
    local __last_color="\[\033[00m\]"
    export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
}

color_my_prompt

# Start from home folder
cd ~/

# Ensure browser environment variable set
export BROWSER="explorer.exe"

# Configure ssh-agent
if [ -z "$(pgrep ssh-agent)" ]; then
    rm -rf /tmp/ssh-*
    eval $(ssh-agent -s) > /dev/null
else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
fi

# If ssh-agent has no identities, add mine
ssh-add -l &>/dev/null
if [ "$?" == 1 ]; then ssh-add ~/.ssh/$USER; fi

# Remove bitwarden sessions older than a day
if [[ $(find ~/.bw_session -mtime +1 -print) ]]; then rm ~/.bw_session; fi

# If bitwarden session already set don't overwrite 
if [ -n "$BW_SESSION" ]; then echo "Bitwarden set";

# Else if there is a session file set from there 
elif [ -f ~/.bw_session ]; then export BW_SESSION=$(cat ~/.bw_session);

# Otherwise unlock to start new session
else bwu; fi

# Try connect to my default tmate socket
if ! tmate -S /tmp/default.tmate attach; then
    tmate -S /tmp/default.tmate.tmate new-session -s default -n default -d
    tmate -S /tmp/default.tmate.tmate attach
fi
