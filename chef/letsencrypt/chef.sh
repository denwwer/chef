#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Get the SSL/TLS certificate from LetsEncrypt
# will save the files in /etc/letsencrypt/live/www.mydomain.com
#
# ARG
# $1 - your@email.com | opts out of signing up for the EFF mailing list
function chef_letsencrypt {
	if [ -z "$1" ]; then
	    title "[ERROR] email is required"
	    exit 0
	fi

  title "Configure LetsEncrypt"

	sudo apt-get install -q=2 software-properties-common
	sudo add-apt-repository -y ppa:certbot/certbot
	sudo apt-get -q=2 update
	sudo apt-get install -q=2 certbot

	local www_domaim="www.$DOMAIN_NAME"

	sudo certbot certonly --webroot --agree-tos --no-eff-email --email $1 -w /var/www/letsencrypt -d www_domaim -d $DOMAIN_NAME
  sudo certbot renew --dry-run

  local croncmd="Automatic renewal LetsEncrypt"
  local cronjob=`cat letsencrypt/crontab`

  ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

	echo "Check SLL rating on https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN_NAME"
}
