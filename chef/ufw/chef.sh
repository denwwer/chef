#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Setup UFW firewall
function chef_ufw {
	title 'Configure UFW'

	# More on https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands
	sudo ufw allow 22      # ssh
	sudo ufw allow 80      # http
	sudo ufw allow 443     # https
	sudo ufw allow 2812    # monit
	sudo ufw allow out 587 # SMTP
	sudo ufw allow out 25  # SMTP
	sudo ufw default deny
}