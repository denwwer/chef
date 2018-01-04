#!/usr/bin/env bash

. ././../ext/echo_title.sh

function chef_monit {
	echo_title 'Install Monit'
  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 monit'
}