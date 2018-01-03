#!/usr/bin/env bash
. ././../ext/echo_title.sh

function chef_ssh_key {
	if [ ! -f /home/deploy/.ssh/authorized_keys ]; then
	  echo_title 'Add SSH key'

		sudo mkdir /home/deploy/.ssh
	  sudo chmod 700 /home/deploy/.ssh
	  sudo cp ./../authorized_keys /home/deploy/.ssh/authorized_keys
	  sudo rm -f authorized_keys
	  sudo chmod 600 /home/deploy/.ssh/authorized_keys
	  sudo chown -R deploy /home/deploy/.ssh/authorized_keys
	fi
}