#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# ARG
# $1 - Ruby version
function chef_rvm {
	title "Install RVM with Ruby $1"

	sudo -S -u deploy -i /bin/bash -l -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
	sudo -S -u deploy -i /bin/bash -l -c "curl -sSL https://get.rvm.io | bash -s stable --ruby=$1"
	source /home/deploy/.rvm/scripts/rvm
	sudo -i -u deploy echo 'source /home/deploy/.rvm/scripts/rvm' >> /home/deploy/.bashrc
	sudo -S -u deploy -i /bin/bash -l -c "rvm use $1 --default"
	sudo -S -u deploy -i /bin/bash -l -c 'gem install bundler --no-rdoc --no-ri'
}