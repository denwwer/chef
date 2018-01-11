#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"
. "$(pwd)/ext/copy.sh"

# ARG
# $1 - ssl|aws
# $2 - passenger|[skip]
function chef_nginx {
	title "Install Nginx"

	if [ "$2" == "passenger" ]; then
		sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nginx-extras passenger'
	else
	  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nginx'
	fi

	title 'Configure Nginx'

  # Key Exchange
	openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 >/dev/null 2>&1

  # TODO: move this to chef_letsencrypt?
	# LetsEncrypt
  sudo mkdir -p /var/www/letsencrypt/.well-known/acme-challenge

  # Snippets
  for f in nginx/snippets/*
	do
	  local file=$(basename $f)
	  copy "nginx/snippets" $file "/etc/nginx/snippets/$file"
	done

  # Node.js Proxy
	if [ -z "$2" ]; then
		if [ "$1" == "ssl" ]; then
			copy "nginx" "app.ssl.conf" "/etc/nginx/sites-enabled/app.ssl.conf"
		else
		  copy "nginx" "app.aws.conf" "/etc/nginx/sites-enabled/app.conf"
		fi
	fi

	nginx -t

	if [ -z "$2" ]; then
		sudo service nginx restart
	fi
}