#! /usr/bin/env bash

PROJECT_NAME="maas-contributors"
PROJECT_PATH="~/projects/maas-contributors"

func check_lxd_installed() {
    echo "#######################"
    echo "Checking if lxd is installed"
    if ! command -v lxc >/dev/null 2>&1; then
        echo "Error: lxd is not installed" >&2
        exit 1
    else 
        echo "lxd is installed"
        echo "..done"
    fi
}

func create_profile() {
echo "#######################"
echo "Creating profile"

lxc profile create $PROJECT_NAME
cat <<EOF | lxc profile edit $PROJECT_NAME
config:
    raw.idmap: |
        uid $(id -u) 1000
        gid $(id -g) 1000
    user.vendor-data: |
        #cloud-config
        packages:
        - git
        runcmd:
        - cat /dev/zero | ssh-keygen -q -N ""
        ssh_authorized_keys:
        - $(cat ${HOME}/.ssh/id_ed25519.pub | cut -d' ' -f1-2)
description: Development environment for MAAS contributors
devices:
    workspace:
        type: disk
        source: $PROJECT_PATH
        path: /workspace
EOF
}



check_lxd_installed
create_profile