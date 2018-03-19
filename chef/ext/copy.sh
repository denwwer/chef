#!/usr/bin/env bash

# ARG
# $1 - Config name
# $2 - Source file
# $3 - Desc path
function copy {
  local source=$(_path $1 $2)

  _print "Copy $source to $3"
  sudo -S -u deploy -i /bin/bash -l -c "sudo cp -rf $source $3"
}

# ARG
# $1 - Config name
# $2 - Source file
# $3 - Desc path
function append {
  local source=$(_path $1 $2)

  _print "Append $source to $3"
  sudo -S -u deploy -i /bin/bash -l -c "cat $source >> $3"
}

function _print {
  local green='\033[0;32m'
  local nc='\033[0m' # No Color
  echo -e "${green}$1${nc}"
}

# ARG
# $1 - Config name
# $2 - Source file
function _path {
  local file="$(pwd)/$1/$2"
  local file_with_env="$(pwd)/$1/$APP_ENVIRONMENT/$2"

  if [ -f $file_with_env ]; then
    file=$file_with_env
  fi

  echo "$file"
}