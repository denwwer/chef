#!/usr/bin/env bash

. ././../ext/echo_title.sh

function chef_passenger {
	echo_title "Install Passenger with Nginx"

	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
	sudo apt-get install -y apt-transport-https ca-certificates
	sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
	sudo apt-get -q update
	sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nginx-extras passenger'
	sudo /usr/bin/passenger-config validate-install
}