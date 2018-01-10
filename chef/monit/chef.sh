#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"
. "$(pwd)/ext/copy.sh"

function chef_monit {
	title 'Install Monit'
  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 monit'

  title 'Configure Monit'
  copy "monit" "monitrc" "/etc/monit/monitrc"
}