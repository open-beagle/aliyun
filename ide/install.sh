#!/bin/bash

set -ex

GIT_LIB_PATH="${GIT_LIB_PATH:-/usr/local/lib}"

# apt
if ! [[ -e $HOME/apt.touch ]]; then
  apt update -y 
  apt install -y make gcc python3 connect-proxy openssh-server git curl vim iputils-ping podman crun ca-certificates fuse-overlayfs sudo openssh-client file
  apt clean
  touch $HOME/apt.touch
fi

if ! [[ -e ssh_host_rsa_key ]]; then
  sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config 
  sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
  sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
  # ssh-keygen -A
fi
