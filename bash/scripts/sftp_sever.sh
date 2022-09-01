#!/usr/bin/env bash

set -o errexit 
set -o pipefail

echo "--- SFTP Server Setup Bash script ---"

case "$1" in
  -user|-u) 
    _sftp_user="${2:-sftp_user}"
    ;;
  -help|-h|*)
    echo "Configure a SSH File Transfer Protocol server in Ubuntu using OpenSSH"
    echo "Usage: bash sftp_server -[option] {username}"
    echo "Options:"
    echo -n "\t-user {name} User to be added into the SFTP group"
    echo -n "\nNotice!!\nScript's execution needs root privileges."
    exit 1
    ;;
esac

_sftp_group='sftp'
_sftp_dir='/var/sftp'
_sftp_user_dir="${_sftp_dir}/${_sftp_user}"

# Install OpenSSH-server & SSH
if ! dpkg -s ssh &>/dev/null ; then
  apt install openssh-server && \
  systemctl enable ssh  && \
  systemctl start ssh
fi

if dpkg -s ufw &>/dev/null ; then
  ufw allow ssh
  ufw allow enable
end

# sed -i 's/^Subsystem sftp /usr/lib/openssh/sftp-server/#Subsystem sftp /usr/lib/openssh/sftp-server/' /etc/ssh/sshd_config
# Subsystem sftp internal-sftp

# sshd_config Settings
printf "Port <your_port_number>
Match group ${_sftp_group}
ForceCommand internal-sftp
ChrootDirectory ${_sftp_dir}
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
" >> /etc/ssh/sshd_config

# Create SFTP user's group and user
addgroup ${_sftp_group} && \
useradd -m ${_sftp_user} -g sftp && \
passwd ${_sftp_user} && \
less /etc/passwd | grep ${_sftp_user} && \
grep ${_sftp_group} /etc/group

# Create SFTP dir
if [[ ! -d ${_sftp_dir} ]] ; 
  then
    mkdir -p "${_sftp_dir}" && \
    chown root:root ${_sftp_dir}  && \
    chmod 755 ${_sftp_dir} && \
    ls -lrth -d ${_sftp_dir}
fi

# Create SFTP user dir
if [[ ! -d ${_sftp_user_dir} ]] ; 
  then
    mkdir -p ${_sftp_user_dir} && \
    chown ${_sftp_user}:${_sftp_group} ${_sftp_user_dir} && \
    chmod 755 ${_sftp_user_dir} && \
    ls -lrth -d ${_sftp_user_dir}
fi

# Try accessing the system using SSH - ssh user@server-name

# Restart the service
systemctl restart sshd

exit 0
