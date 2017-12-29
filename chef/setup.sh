#!/usr/bin/env bash

# Ruby version to install via RVM
RUBY_VERSION="2.5.0"

# Deploy folder name
APP_NAME="app"

# App environment provided by first argument
APP_ENVIRONMENT=$1

# Default tool name and his location
CONFIGS="logrotate /etc/logrotate.d
				 monit     /etc/monit
         nginx     /etc/nginx/sites-enabled"

if [ -z "$1" ]; then
    echo 'APP_ENVIRONMENT argument is required'
    exit 0
fi

echo "Apply chef $(date)"

echo_title 'Update system'

sudo apt-get update -q=2

echo ""
echo "======================================="
echo "========= Install dependencies ========"
echo "======================================="
echo ""

sudo apt-get install -q=2 htop mc git redis-tools ufw

echo ""
echo "======================================="
echo "============ Configure UFW ============"
echo "======================================="
echo ""

sudo ufw allow 22 # ssh
sudo ufw allow 80 # http
sudo ufw allow 443 # https
sudo ufw allow 587 # smtp
sudo ufw allow 2812 # monit
sudo ufw default deny

if id deploy >/dev/null 2>&1; then
 	echo ""
else
	echo ""
	echo "====================================="
	echo "=========== Add deploy user ========="
	echo "====================================="
	echo ""

  sudo useradd --create-home -s /bin/bash deploy
	sudo adduser deploy sudo
	sudo passwd deploy
fi

if [ ! -f /home/deploy/.ssh/authorized_keys ]; then
  echo ""
	echo "====================================="
	echo "============ Add ssh key ============"
	echo "====================================="
	echo ""

	sudo mkdir /home/deploy/.ssh
  sudo chmod 700 /home/deploy/.ssh
  sudo cp authorized_keys /home/deploy/.ssh/authorized_keys
  sudo rm -f authorized_keys
  sudo chmod 600 /home/deploy/.ssh/authorized_keys
  sudo chown -R deploy /home/deploy/.ssh/authorized_keys
fi

echo ""
echo "======================================="
echo "============= Install RVM ============="
echo "======================================="
echo ""

sudo -S -u deploy -i /bin/bash -l -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
sudo -S -u deploy -i /bin/bash -l -c "curl -sSL https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION"
source /home/deploy/.rvm/scripts/rvm
sudo -i -u deploy echo 'source /home/deploy/.rvm/scripts/rvm' >> /home/deploy/.bashrc
sudo -S -u deploy -i /bin/bash -l -c "rvm use $RUBY_VERSION --default"
sudo -S -u deploy -i /bin/bash -l -c 'gem install bundler'

echo ""
echo "======================================="
echo "========== Install Passenger =========="
echo "======================================="
echo ""

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get -q update
sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nginx-extras passenger'
sudo /usr/bin/passenger-config validate-install

echo ""
echo "======================================="
echo "=========== Install Node.js ==========="
echo "======================================="
echo ""

sudo -S -u deploy -i /bin/bash -l -c 'curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -'
sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 nodejs'

echo ""
echo "======================================="
echo "============ Install Monit ============"
echo "======================================="
echo ""

sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 monit'

while read -r conf
do
	conf_array=( $conf )
	name=${conf_array[0]}
	path=${conf_array[1]}

	echo "========= Configure $name"

	files=$name

	if [ -d $name/$APP_ENVIRONMENT ]; then
	 files=$name/$APP_ENVIRONMENT
	fi

	for f in $files/*
	do
	  dest=$path/$(basename $f)
	  echo "cp $f $dest"
	  sudo -S -u deploy -i /bin/bash -l -c "sudo cp -rf $f $dest"
	done

	echo ""
done <<< "$CONFIGS"

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