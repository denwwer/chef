#!/usr/bin/env bash

function help {
  echo "Usage:"
  echo "  ./chef.sh [user@host] [key.pub] [/chef] [environment]"
  echo ""
  echo "   [user@host]     - user and host for connect to remote server"
  echo "   [key.pub]       - local path to public SSH key"
  echo "   [chef/path]     - path where save chef's on remote server"
  echo "   [environment]   - app enviroment to use"
  exit 0
}

if [ -z "$4" ]; then
  help
fi

echo "Upload chef"
cat $2 > chef/authorized_keys
rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" chef $1:$3
ssh -t $1 "cd $3/chef && sudo chmod 777 setup.sh && ./setup.sh $4" | tee -a chef.log
