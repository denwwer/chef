#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"
. "$(pwd)/ext/copy.sh"
. "$(pwd)/nginx/chef.sh"

# Install Passenger with Nginx
#
# ARG
# $1 http|https|aws
#   http  - standalone config (default)
#   https - standalone SSL config
#   aws   - AWS config
function chef_passenger {
	title "Install Passenger with Nginx"

	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
	sudo apt-get install -y apt-transport-https ca-certificates
	sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
	sudo apt-get -q update

  # Apply Nginx chef's
	chef_nginx $1 "passenger"

	sudo /usr/bin/passenger-config validate-install --auto

	if [ "$1" == "aws" ]; then
	  copy "passenger" "app.aws.conf" "/etc/nginx/sites-enabled/app.conf"
	else
		if [ "$1" == "https" ]; then
			copy "passenger" "app.ssl.conf" "/etc/nginx/sites-enabled/app.ssl.conf"
		else
		  copy "passenger" "app.conf" "/etc/nginx/sites-enabled/app.conf"
		fi
	fi

	local conf=$(cat /etc/nginx/nginx.conf | grep "# include /etc/nginx/passenger.conf")

  # Uncomment Passenger config
	sudo sed -i -r 's/# (include.*passenger\.conf)/\1/' /etc/nginx/nginx.conf

	sudo service nginx restart
}