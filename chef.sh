#!/usr/bin/env bash


function help {
  echo "Usage:"
  echo "  ./chef.sh user@host key.pub chef_path app_environment"
  exit 0
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    help
fi

echo "Upload chef"
cat $2 > chef/authorized_keys
rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" chef $1:$3
ssh -t $1 "cd $3/chef && sudo chmod 777 setup.sh && ./setup.sh $4" | tee -a chef.log
