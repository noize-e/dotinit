alias python="python3.10"
alias a="subl ~/.bash_aliases"
alias b="subl ~/.bashrc"
alias .a="source ${HOME}/.bash_aliases"
alias .b="source ${HOME}/.bashrc"
alias .u="source ${HOME}/.bash_utils"
alias extract="tar -xzvf"
alias sources="sudo subl /etc/apt/sources.list"
alias docker="sudo docker"
alias compose="sudo docker-compose"
alias apt="sudo apt"
alias pylib="python -m pip install"
alias pyenv="python -m venv venv"
alias venv="source ./venv/bin/activate"
alias gp="gh"
alias repos="gh repo list"
alias gorepo="gh browse --repo"
alias repo="gh repo create"
alias aptget="sudo apt-get"
alias gsts="git status"
alias gph="git push"
alias gadd="git add"
alias gddu="git add -u ."
alias gck="git checkout"
alias gmg="git merge"
alias gbrch="git branch"
alias glog="git log --pretty=oneline"
alias aps="sudo ps -efc | sort -k 1 -r" # lists information about all running processes.
alias nps="ps -efc | grep"
alias eps="sudo ps -ceo pcpu,pid,user,args | sort -k 1" # Get process gathering most of the CPU load
alias procs="sudo ps -ceo pcpu,pid,user,args | sort -k 1"
alias sof="sudo lsof -Pni"
alias net="sudo netstat -atln"
alias wps="watch -n 3 'sudo ps -ceo pcpu,pid,user,args | sort -k 1 -r'"
alias wsof="watch -n 1 'sudo lsof -Pni'"
alias wnet="watch -n 1 'sudo netstat -atln'"
alias indomain="curl -sILk"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

alias serve="jekyll serve"
alias serve="bundle exec jekyll serve --trace"

print_b64(){
  echo ${1:?base64 string} | base64 --decode
}

sshkeygen(){
  echo -e "Generating a RSA-4096 SSH Key: ~/.ssh/id_rsa"
  ssh-keygen -t rsa -b 4096 -C "wirdlog@gmail.com"
  eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
  sudo apt-get install xclip
  xclip -sel clip < ~/.ssh/id_rsa.pub
}

showme(){
  sudo netstat -atln ;
  sudo lsof -i ;
}

search(){
  local query="${1// /%20}"
  xdg-open "https://www.google.com/search?q=$query"
}

bc(){
  local fn=${1:?script name}
  local sfn=${fn%.*}

  shc -T -f $fn && mv $fn.x $sfn && chmod ugo+x $sfn ;
  setarch "$(arch)" -R bash ; 
}

chkusr(){
  sudo cat /etc/passwd|grep ${1:?usr-id}
}

goto(){
  case "${1}" in
    gh-tokens ) xdg-open https://github.com/settings/tokens ;;
  esac
}

compress(){
  tar -czvf ${1:?tar (file.tar.gz)} ${2:?tar contents folder/file}
}

extract(){
  tar -xzvf ${1:?tar (file.tar.gz)}
}

copy(){
  # sudo apt-get install xclip
  cat "${1}" | xclip -selection clipboard
}

gen-pwd(){
  echo $(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 20 | xargs)
}

im-online(){
  wget -q --spider http://google.com
  if [ $? -eq 0 ]; then
      echo -e "\n [+] Connected!"
  else
      echo -e '\n [!] No Internet access! Quitting...'
      exit 1
  fi
}

rdk-hfs(){
  disk="${1:?arg-err: mounted disk path}"

  df | grep "${disk}" && \
  read -p "device:[/dev/sdc2] " disk 

  disk="${device:-/dev/sdc2}"
  
  sudo umount ${device} && \
  sudo fsck.hfsplus -f ${device} && \
  sudo mkdir ${disk} && \
  sudo mount -t hfsplus -o force,rw ${device} ${disk}
}

fstnd(){
  if [[ $# -eq 0 ]] ;
    then
      echo "File Name Standarize"
      echo "Usage: fstnd (r-pattern) (r-pattern)"
      echo "Example: fstnd '[, •�\(\)\]' '-' && fstnd '[A-Z]' '[a-z]' && ll;"
  fi

  ls | while read line; do 
    [[ -f $line ]] && mv -i "${line}" "`echo "${line}" | tr "${1:?regex-pattern}" "${2:?regex-pattern}"`" &>/dev/null || echo 0
  done
}

findmv(){
  sudo finlld -name "${1:?filename}" -printf "'%p' '${2:?dest-dir}/%f'\n" | while read line; do eval "mv $line" ; done
}