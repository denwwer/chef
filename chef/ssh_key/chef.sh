#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Add SSH pub.key to deploy user
function chef_ssh_key {
  if [ ! -f /home/deploy/.ssh/authorized_keys ]; then
    title 'Add SSH key'

    local auth_keys="$(pwd)/authorized_keys"

    sudo mkdir /home/deploy/.ssh
    sudo chmod 700 /home/deploy/.ssh
    sudo cp $auth_keys /home/deploy/.ssh/authorized_keys
    sudo rm -f $auth_keys
    sudo chmod 600 /home/deploy/.ssh/authorized_keys
    sudo chown -R deploy /home/deploy/.ssh
	fi
}