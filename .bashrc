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

# Alias docker to podman
alias docker=podman

# Custom git alias for pushing to all remotes at once
alias gpa='git remote | xargs -L1 git push --all'

# simplify bitwarden cli usage
cpcmd="xclip -selection c"; if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then cpcmd="wl-copy"; fi
alias bw='NODE_OPTIONS="--no-deprecation" /home/linuxbrew/.linuxbrew/bin/bw'
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

# If ssh-agent is not already running
if [ -z "$(pgrep ssh-agent)" ]; then

    # Cleanup any old ssh directory from tmp
    if [ -d "/tmp/ssh" ]; then
        rm --recursive --force /tmp/ssh-*
    fi

    # Start ssh-agent and set pid + auth sock
    eval $(ssh-agent -s) > /dev/null
else
    # Set pid + auth sock to ensure existing ssh-agent will be re-used
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    if [ -d "/tmp/ssh" ]; then 
	export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
    fi
fi

# If ssh-agent has no identities, add mine
ssh-add -l &>/dev/null
if [ "$?" == 1 ]; then ssh-add ~/.ssh/$USER; fi

# Remove bitwarden sessions older than a day
if [ -f ~/.bw_session ] && [[ $(find ~/.bw_session -mtime +1 -print) ]]; then rm ~/.bw_session; fi

# If we have a bitwarden session file available set from it
if [ -f ~/.bw_session ]; then export BW_SESSION=$(cat ~/.bw_session);

# Otherwise unlock to start new session
elif [ -z "$BW_SESSION" ]; then bwu; fi

# Try connect to my default tmux socket
if [ -z "$TMUX" ]; then
    if ! tmux -S /tmp/default.tmux attach; then
        tmux -S /tmp/default.tmux new-session -s default -n default -d
        tmux -S /tmp/default.tmux attach
    fi
fi

SBP_PATH=/home/james/Downloads/sbp
source /home/james/Downloads/sbp/sbp.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/var/home/james/.var/bin/google-cloud-sdk/path.bash.inc' ]; then . '/var/home/james/.var/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/var/home/james/.var/bin/google-cloud-sdk/completion.bash.inc' ]; then . '/var/home/james/.var/bin/google-cloud-sdk/completion.bash.inc'; fi
