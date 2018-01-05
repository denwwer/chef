#!/usr/bin/env bash

. ./ext/echo_title.sh
. ./ufw/chef.sh
. ./opendkim/chef.sh
. ./postfix/chef.sh
. ./ssh_key/chef.sh
. ./rvm/chef.sh
. ./nodejs/chef.sh
. ./passenger/chef.sh
. ./monit/chef.sh
. ./logrotate/chef.sh

# Deploy folder name
APP_NAME="app"

# Email address where send Monit alerts
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

echo "Apply chef $(date)"

echo_title 'Update system'

sudo apt-get update -q=2

echo_title 'Install dependencies'

debconf-set-selections <<< "postfix postfix/mailname string $DOMAIN_NAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

sudo apt-get install -q=2 htop mc git redis-tools ufw vim nano opendkim opendkim-tools mailutils

if id deploy >/dev/null 2>&1; then
 	echo ""
else
  echo_title 'Add deploy user'

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
# only one `chef_passenger` or `chef_nginx` should be used
chef_passenger "ssl"
chef_monit
chef_logrotate

echo ""
echo "======================================="
echo "========== Post installation =========="
echo "======================================="
echo ""
echo " * sudo visudo"
echo "   add 'deploy ALL=NOPASSWD: /usr/bin/monit*, /etc/monit/monitrc, /bin/cp, /bin/mv'"
echo ""
echo " * sudo nano /etc/nginx/nginx.conf"
echo "   set ' access_log off; '"
echo "   uncomment ' # include /etc/nginx/passenger.conf; '"
echo "   sudo service nginx restart"