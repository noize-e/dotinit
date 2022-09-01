#!/usr/bin/env bash

printf """Debian/Ubuntu Environment Setup

Installing required packages...
"""
sudo apt update &>>/.ubuntu-setup.log && echo "apt updated" ;
sudo apt-get update &>>/.ubuntu-setup.log && echo "apt-get updated" ;

# git*
echo "Installing git tools..."
sudo apt install git &>>/.ubuntu-setup.log && echo "package 'git' installed" ;
sudo apt install gh &>>/.ubuntu-setup.log && echo "package 'gh' installed" ;
sudo apt-get install git-lfs &>>/.ubuntu-setup.log && echo "package 'git-lfs' installed" ;

# network*
echo "Installing network tools..."
sudo apt install net-tools &>>/.ubuntu-setup.log && echo "package 'net-tools' installed" ;
sudo apt install nmap &>>/.ubuntu-setup.log && echo "package 'nmap' installed" ;
sudo apt install tshark &>>/.ubuntu-setup.log && echo "package 'tshark' installed" ;
sudo apt install wireshark &>>/.ubuntu-setup.log && echo "package 'wireshark' installed" ;

# system tools*
echo "Installing system tools..."
sudo apt install curl &>>/.ubuntu-setup.log && echo "package 'curl' installed" ;
sudo apt install tmux &>>/.ubuntu-setup.log && echo "package 'tmux' installed" ;
sudo apt install htop &>>/.ubuntu-setup.log && echo "package 'htop' installed" ;
sudo apt install binwalk &>>/.ubuntu-setup.log && echo "package 'binwalk' installed" ;
sudo apt-get install xclip &>>/.ubuntu-setup.log && echo "package 'xclip' installed" ;
sudo apt-get install build-essential &>>/.ubuntu-setup.log && echo "package 'build-essential' installed" ;
sudo apt-get install libc6-dev &>>/.ubuntu-setup.log && echo "package 'libc6-dev' installed" ;
sudo apt install make &>>/.ubuntu-setup.log && echo "package 'make' installed" ;
sudo chmod o+w /usr/local/bin/ && sudo mkdir ls /usr/local/man/man1

# docker (optional)
read -p "Install Docker[y|n]: " docker
if [[ -z ${docker} ]] && [[ "${docker}" ~= "[yY]" ]] ; then
  sudo apt install docker &>>/.ubuntu-setup.log && echo "package 'docker' installed" ;
  sudo apt install docker-compose &>>/.ubuntu-setup.log && echo "package 'docker-compose' installed" ;
fi

# server (optional)
read -p "Install server utils[y|n]: " server
if [[ -z ${server} ]] && [[ "${server}" ~= "[yY]" ]] ; then
  sudo apt install apache2 &>>/.ubuntu-setup.log && echo "package 'apache2' installed" ;
  sudo apt install nginx &>>/.ubuntu-setup.log && echo "package 'nginx' installed" ;
fi

# utils (optional)
# dmg2img:
#   Convert compressed dmg to standard (hfsplus) image disk files
#   Usage: dmg2img [-s] [-v] [-V] [-d] -i <input.dmg> -o <output.img>
read -p "Install Utils[y|n]: " utils
if [[ -z ${utils} ]] && [[ "${utils}" ~= "[yY]" ]] ; then
  sudo apt install gnome-disk-utility &>>/.ubuntu-setup.log && echo "package 'gnome-disk-utility' installed" ;
  sudo apt install gpart &>>/.ubuntu-setup.log && echo "package 'gpart' installed" ;
  sudo apt install dmg2img &>>/.ubuntu-setup.log && echo "package 'dmg2img' installed" ;
fi

# legacy
read -p "Install legacy utils[y|n]: " legacy
if [[ -z ${legacy} ]] && [[ "${legacy}" ~= "[yY]" ]] ; then
  sudo apt install python2 &>>/.ubuntu-setup.log && echo "package 'python2' installed" ;
fi