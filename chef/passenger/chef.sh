#!/usr/bin/env bash

. "$(pwd)/ext/echo_title.sh"
. "$(pwd)/ext/copy.sh"
. "$(pwd)/nginx/chef.sh"

# ARG
# $1 - ssl|aws
function chef_passenger {
	echo_title "Install Passenger with Nginx"

	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
	sudo apt-get install -y apt-transport-https ca-certificates
	sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
	sudo apt-get -q update

	chef_nginx $1 "passenger"

	sudo /usr/bin/passenger-config validate-install

	if [ "$1" == "ssl" ]; then
		copy "passenger" "app.ssl.conf" "/etc/nginx/sites-enabled/app.ssl.conf"
	else
	  copy "passenger" "app.aws.conf" "/etc/nginx/sites-enabled/app.conf"
	fi

	sudo service nginx restart
}