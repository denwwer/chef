#!/usr/bin/env bash

. ././../ext/echo_title.sh

function chef_nginx {
	echo_title "Install Nginx"
	sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nginx'
}