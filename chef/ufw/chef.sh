#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Setup UFW firewall
function chef_ufw {
	title 'Configure UFW'

	# More on https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands
	sudo ufw allow 22      # SSH
	sudo ufw allow 80      # HTTP
	sudo ufw allow 443     # HTTPS
	sudo ufw allow 2812    # Monit
	sudo ufw allow out 587 # SMTP RFC
	sudo ufw allow out 25  # SMTP
	sudo ufw default deny
}