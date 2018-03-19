#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"
. "$(pwd)/ext/copy.sh"


# Install Monit
function chef_monit {
	title 'Install Monit'
  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 monit'

  title 'Configure Monit'

  copy "monit" "nginx" "/etc/monit/conf.d/nginx"
  copy "monit" "healthcheck" "/etc/monit/conf.d/healthcheck"
  copy "monit" "filesystem" "/etc/monit/conf.d/filesystem"
  copy "monit" "postfix" "/etc/monit/conf.d/postfix"
  copy "monit" "monitrc" "/etc/monit/monitrc"

  monit status
}