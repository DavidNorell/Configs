#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# source /usr/share/nvm/init-nvm.sh

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# fzf for command history, install with package manager
eval "$(fzf --bash)" 

# checkcert() {
#   sudo openssl x509 -in $1 -text -noout
# }

# checkremotecert() {
#   local SERVERNAME="$1"
#   local SERVERADDRESS="${2:-$1}"
#   echo | openssl s_client -servername $SERVERNAME -connect $SERVERADDRESS:443 2>/dev/null | openssl x509 -inform pem -noout -text
# }

# Node Version Manager, for switching node versions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python Environment, for switching python versions
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
