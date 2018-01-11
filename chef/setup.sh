#!/usr/bin/env bash

# TODO: make this dynamically
. ./ext/title.sh
. ./ufw/chef.sh
. ./opendkim/chef.sh
. ./postfix/chef.sh
. ./ssh_key/chef.sh
. ./rvm/chef.sh
. ./nodejs/chef.sh
. ./passenger/chef.sh
. ./monit/chef.sh
. ./logrotate/chef.sh
. ./letsencrypt/chef.sh

# Deploy folder name
APP_NAME="app"

# Email address where send alerts from Monit|System
NOTIFIER_EMAIL="my@mail.com"

# Domain name
DOMAIN_NAME="mydomain.com"

# OpenDKIM Socket
OPENDKIM_SOCKET="56371"

# Host IP
HOST_IP="$(echo -e "$(hostname -I)" | tr -d '[:space:]')"

# App environment provided by first argument
APP_ENVIRONMENT=$1

if [ -z "$1" ]; then
    echo 'APP_ENVIRONMENT argument is required'
    exit 0
fi

title 'Start'
title "Environment $APP_ENVIRONMENT"
title 'Update system'

sudo apt-get update -q=2

title 'Install dependencies'

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

debconf-set-selections <<< "debconf debconf/frontend select Noninteractive"
debconf-set-selections <<< "postfix postfix/mailname string $DOMAIN_NAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

sudo apt-get install -q=2 htop mc git redis-tools ufw vim nano opendkim opendkim-tools mailutils

# for test
sudo apt-get install -q=2 debconf-utils

# TODO: add deploy user password to debconf
if id deploy >/dev/null 2>&1; then
 	echo ""
else
  title 'Add deploy user'

  sudo useradd --create-home -s /bin/bash deploy
	sudo adduser deploy sudo
	sudo passwd deploy
fi

# ============================
# ========== Chef's ==========
# ============================

chef_ssh_key
chef_ufw
chef_postfix
chef_opendkim
chef_rvm "2.5.0"
chef_nodejs "9.x"
# Only one `chef_passenger` or `chef_nginx` should be used,
# because `chef_passenger` include Nginx as well
chef_passenger "ssl"
chef_letsencrypt "my@mail.com"
chef_monit
chef_logrotate