#!/usr/bin/env bash

# set -o errexit
# set -o errtrace
# set -o nounset
#
#   get_functions
#   local_ip
#   check_port
#   today
#   lower
#   upper
#   trim_string
#   lower_filenames
#   extract
#   google
#   gen_pwd
#   encrypt_disk
#   checksum
#   parse_git_branch
#   spoof_mac
#   dns_clean
#   archive
#   unique
#   findme
#   findd
#   new_bin
#   set_no_write_perms
#   set_only_read_perms
#   mem_stats
#   rm_dotstore
#   rm_pycache
#   addpath
#   rcp


get_functions() {
    # Get the list of functions in a script
    # Usage: get_functions
    IFS=$'\n' read -d "" -ra functions < <(declare -F)
    printf '%s\n' "${functions[@]//declare -f }"
}

local_ip(){
  # Show Local IP Address
  ipconfig getifaddr en0
}

check_port(){
  # Confirm whether sshd is enabled or disabled:
  local port="${1:?arg-err: port expected}"
  sudo lsof -Pni TCP:${port}
}

today(){
  # Get current date
  echo "$(date +'%m/%d/%Y')";
}

lower() {
    # Usage: lower "string"
    printf '%s\n' "${1,,}"
}

upper() {
    # Usage: upper "string"
    printf '%s\n' "${1^^}"
}

trim_string() {
    # Usage: trim_string "   example   string    "
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

lower_filenames(){
  for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`; done
}

extract() {
    # Usage: extract file "opening marker" "closing marker"
    #
    #   ...get code blocks from MarkDown file.
    #
    #       extract ~/projects/pure-bash/README.md '```sh' '```'
    # 
    while IFS=$'\n' read -r line; do
        [[ $extract && $line != "$3" ]] &&
            printf '%s\n' "$line"

        [[ $line == "$2" ]] && extract=1
        [[ $line == "$3" ]] && extract=
    done < "$1"
}

google(){ 
  open /Applications/Google\ Chrome.app/ "http://www.google.com/search?q= $1"; 
}

gen_pwd(){
  openssl rand -base64 30
}

encrypt_disk(){
  local name="${1:?arg 'name' missing}"
  local size="${2:-1GB}"
  local path="${3:-.}"
  local volume="${path}/${name}.dmg"

  if read -p "Is correct: ${size} - ${volume}" ; then
    hdiutil create ${volume} -encryption -size ${size} -volname "${name}" -fs JHFS+ && \
    hdiutil mount ${volume}
  fi
}

checksum(){
  find -s ${1:?arg-err: path ./root/} -type f -exec shasum {} \; | shasum
}

parse_git_branch(){
  # Function which prints current 
  # git branch name (used in prompt)
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

spoof_mac(){
  # You may want to [spoof the MAC address](https://en.wikipedia.org/wiki/MAC_spoofing) 
  # of the network card before connecting to new and untrusted wireless networks to mitigate passive fingerprinting:
  # [NOTICE] MAC addresses will reset to hardware defaults on each boot.
  sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')
}

dns_clean(){
  # sudo dscacheutil -flushcache ; \ sudo killall -HUP mDNSResponder
  sudo dscacheutil -flushcache ; 
  sudo killall -HUP mDNSResponder
}

archive(){
  # Create a tarball file with gzip compression
  tarball="${1}"; resource="${2}"
  tar -czvf ${tarball}.tar.gz ${resource}
}

unique(){ sort "${1:?arg-err: file-path}" | uniq -u ; }

findme(){
  # Find a file globaly
  sudo find / -name "*${1}*";
}

findd(){
  # Find a launchctl service
  sudo grep -lR "${1}" /System/Library/Launch* /Library/Launch* ~/Library/LaunchAgents
}

new_bin(){
  bin="${1:-}"; [[ -z "${bin}" ]] && exit 1 ;
  binpath="${HOME}/bin/${bin}"
  touch ${binpath} && \
  chmod +x ${binpath} && \
  echo "Binary created: $bin" && \
  sleep 1 && \
  subl ${binpath}
}


set_no_write_perms(){
  item="${1:-}"
  opt='' ; [[ -d "$item" ]] && opt='-R' ;
  chmod ${opt} go-w ${item} && \
    echo "no write set: ${item}"
}

set_only_read_perms(){
  item="${1:-}"
  opt='' ; [[ -d "$item" ]] && opt='-R' ;
  chmod ${opt} ugo-wx ${item} && \
    chmod ${opt} ugo+r ${item} && \
      echo "no write set: ${item}"
}

# --- Memory -------------------------------------------------------

# Show Memory Statistics
# sudo purge: Purge memory cache
mem_stats(){
  # Table of data, repeat 10 times total, 1 second wait between each poll
  vm_stat -c 10 1
}

rm_dotstore(){
  find . -name '*.DS_Store*' -print -delete
}

rm_pycache(){
  find -L . -name '*__pycache__*' -print | while read line; do rm -rvf ${line}; done
}

addpath(){
  local name="${1:?[err] path name}"
  local path="${2:-$(pwd)}"
  echo -e "\nalias ${name}=\"cd ${path}\"" >> ${HOME}/.bash_aliases && \
  eval "source ${HOME}/.bash_aliases" && \
  echo "[ok] create alias '${name}' to ${path}";
}

rcp(){
    cat ${1:?paths} | while read line ; do
        aws s3 cp s3://${2:?bucket}/${line} ${4:-.}/${line}
    done
}
