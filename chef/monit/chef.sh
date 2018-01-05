#!/usr/bin/env bash

. "$(pwd)/ext/echo_title.sh"
. "$(pwd)/ext/copy.sh"

function chef_monit {
	echo_title 'Install Monit'
  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 monit'

  echo_title 'Configure Monit'
  copy_conf "monit" "monitrc" "/etc/monit/monitrc"
}