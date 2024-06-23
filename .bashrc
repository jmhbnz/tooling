# ==============================================================================
# Personal $HOME/.bashrc file by James Blair <mail@jamesblair.net>
# ==============================================================================

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# also ensure we write to history immediately instead of only on terminal close
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -l --color=auto -h --group-directories-first'
    alias ll='ls -l --color=auto -h --group-directories-first'
fi

# Custom git alias for pushing to all remotes at once
alias gpa='git remote | xargs -L1 git push --all'

# simplify bitwarden cli usage
cpcmd="xclip -selection c"; if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then cpcmd="wl-copy"; fi
alias bwu='export BW_SESSION=$(bw unlock --raw > ~/.bw_session && cat ~/.bw_session)'

function bwgp () {
    local test=$(export BW_SESSION=~/.bw_session) && bw get password "$1" | $cpcmd;

    # If the login has a totp associated we should leave a follow-up prompt for it
    if totp=$(bw get totp "$1"); then
        read -p "Press enter when ready for totp"
        echo "${totp}" | $cpcmd
    fi
}
function bwgt () { local test=$(export BW_SESSION=~/.bw_session) && bw get totp "$1" | $cpcmd; }
function bwgi () { local test=$(export BW_SESSION=~/.bw_session) && bw get item --pretty "$1"; }
function bwli () { local test=$(export BW_SESSION=~/.bw_session) && bw list items --search "$1" --pretty | egrep -i 'name|"id":'; }
function bwol () { local test=$(export BW_SESSION=~/.bw_session) && bw get item --pretty "$1" | grep https | awk '{print $2}' | $cpcmd; }
function bwgu () { local test=$(export BW_SESSION=~/.bw_session) && bw get username "$1" | $cpcmd; }

# Custom function for creating new entries
function bwai () {

    # Verify enough parameters are supplied
    if [ "$#" -lt "2" ]; then
        echo 'Ensure all required parameters are supplied:'
        echo '  $1 = Name for item'
        echo '  $2 = Username for item'
        echo '  $3 = Secret for item (optional)'
        echo '  $4 = Url for item (optional)'
        return 2
    fi

    # Use a generated password if none supplied
    local pass="${3:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20; echo)}"

    # Pad the url with required json
    bw_uris=$(bw get template item.login.uri | jq ".match="0" | .uri=\"${4}\"" | jq -c)

    bw get template item | \
        jq ".name=\"${1}\" | \
        .login=$(bw get template item.login | jq ".username=\"${2}\" | .password=\"${pass}\" | .uris=[${bw_uris}] | .totp=null")" | \
        jq '.notes=null' | \
        bw encode | bw create item && bw sync
}

# custom git credential cache implementation for bitwarden
# https://github.com/bitwarden/cli/blob/master/examples/git-credential-bw.sh
function bw_gitea () {
   declare -A params

   if [[ "$1" == "get" ]]; then
       read -r line
       while [ -n "$line" ]; do
           key=${line%%=*}
           value=${line#*=}
           params[$key]=$value
           read -r line
       done

       if [[ "${params['protocol']}" != "https" ]]; then
           exit
       fi

       if [[ -z "${params["host"]}" ]]; then
           exit
       fi

       if ! bw list items --search "asdf" > /dev/null 2>&1; then
           echo "Please login to Bitwarden to use git credential helper" > /dev/stderr
           exit
       fi

       id=$(bw list items --search "${params["host"]}"|jq ".[] | select(.name == \"${params["host"]}\").id" -r)

       if [[ -z "$id" ]]; then
           echo "Couldn't find item id in Bitwarden DB." > /dev/stderr
           echo "${params}"
           exit
       fi

       user=$(bw get username "${id}")
       pass=$(bw get password "${id}")

       if [[ -z "$user" ]] || [[ -z "$pass" ]]; then
           echo "Couldn't find host in Bitwarden DB." > /dev/stderr
           exit
       fi

       echo username="$user"
       echo password="$pass"
   fi
}

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

# Configure fuzzy find
export FZF_DEFAULT_COMMAND="rg --files --follow --no-ignore-vcs --hidden -g '!{**/node_modules/*,**/.git/*,**.emacs.d/*}'"
eval "$(fzf --bash)"

# Configure emacs location and aliases
export PATH=$PATH:/home/james/.config/emacs/bin/
alias emacs="emacsclient -nw -a 'doom run --bg-daemon && emacsclient -nw'"
alias nano="emacsclient -nw -a 'doom run --bg-daemon' && emacsclient -nw"

function e {

    # If the file exists just open it
    if test -f "$1"; then
    emacsclient -nw -a 'doom run --bg-daemon && emacsclient -nw' "$1"

    # Otherwise we should search for it
    else emacsclient -nw -a 'doom run --bg-daemon && emacsclient -nw' $(fzf --height 40% --reverse -i --query "$1")
    fi
}

# Configure go location
export PATH=$PATH:/var/home/james/go/bin

# Setup prompt
function color_my_prompt {
    local __user_and_host="\[\033[01;32m\]\u@\h"
    local __cur_location="\[\032[01;34m\]\w"
    local __git_branch_color="\[\033[31m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __prompt_tail="\[\033[35m\]$"
    local __last_color="\[\033[00m\]"
    export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
}

color_my_prompt

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

# Try connect to my default tmux socket
if ! tmux -S /tmp/default.tmux attach; then
    tmux -S /tmp/default.tmux new-session -s default -n default -d
    tmux -S /tmp/default.tmux attach
fi
SBP_PATH=/home/james/Downloads/sbp
source /home/james/Downloads/sbp/sbp.bash
export NODE_OPTIONS="--no-deprecation"
