#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Install Node.js
#
# ARG
# $1 - Node.js version
function chef_nodejs {
	if [ -z "$1" ]; then
	    title "[ERROR] Node.js version is required"
	    exit 0
	fi

	title "Install Node.js $1"

	sudo -S -u deploy -i /bin/bash -l -c "curl -sL https://deb.nodesource.com/setup_$1 | sudo -E bash -"
  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nodejs'
}