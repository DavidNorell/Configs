#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

source /usr/share/nvm/init-nvm.sh

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

eval "$(fzf --bash)"

checkcert() {
  sudo openssl x509 -in $1 -text -noout
}

checkremotecert() {
  local SERVERNAME="$1"
  local SERVERADDRESS="${2:-$1}"
  echo | openssl s_client -servername $SERVERNAME -connect $SERVERADDRESS:443 2>/dev/null | openssl x509 -inform pem -noout -text
}
