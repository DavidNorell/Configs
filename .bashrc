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

spaivpn() {
  sudo resolvconf -u
  wg-quick up wg0
}

query_spintra_db() {
  sql_query="$1"
  sudo docker compose exec db mysql -u spintra -pS3cretpassword -D spintra -e "$sql_query"
}

dagens() {
  dagens_husman
  dagens_chiliolime
}

dagens_husman() {
  printf "\n##################################################################\n"
  printf "Restaurang Husman:\n"
  curl -s https://restauranghusman.se/husman-lunch/ | htmlq 'span.elementor-heading-title' --text | awk 'NR>1 && NR<16 && NR%2==1{gsub(/^0+/,"",prev); print prev". "$0} NR%2==0{prev=$0}'
  printf "##################################################################\n"
}

dagens_chiliolime() {
  printf "\n##################################################################\n"
  printf "Restaurang Chili o Lime:\n"
  curl -s https://www.chili-lime.se/ | htmlq 'td' --text | awk 'NR>13 && NR<31' | awk '
  {
    gsub(/^[[:space:]]+/, "")
    if ($0 == "") next
    if ($0 ~ /^[0-9]+\.$/) { num = $0; next }
  
    if (match($0, /[0-9]+\. [A-Z]\./)) {
      p1 = substr($0, 1, RSTART - 1)
      p2 = substr($0, RSTART)
      sub(/^[A-Z]\. /, "", p1)
      sub(/^[0-9]+\. [A-Z]\. /, "", p2)
      print num "A. " p1
      print num "B. " p2
      next
    }
  
    if ($0 ~ /^[A-Z]\. /) {
      sub(/^[A-Z]\. /, "", $0)
      print num "A. " $0
      next
    }
  
    print num " " $0
  }'
  printf "##################################################################\n"
}


# Node Version Manager, for switching node versions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python Environment, for switching python versions
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Created by `pipx` on 2026-10-19 11:40:25
export PATH="$PATH:/home/david/.local/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# For roslyn ls (C#)
export PATH="$PATH:/home/david/.dotnet/tools"
