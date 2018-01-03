#!/usr/bin/env bash

# ARG
# $1 - Config name
# $2 - Source file
# $3 - Desc path
function copy_conf {
  local source=$(_path $1 $2)

  echo "Copy $source to $3"
  sudo -S -u deploy -i /bin/bash -l -c "sudo cp -rf $source $3"
}

# ARG
# $1 - Config name
# $2 - Source file
# $3 - Desc path
function append_conf {
  local source=$(_path $1 $2)

  echo "Append $source to $3"
  sudo -S -u deploy -i /bin/bash -l -c "cat $source >> $3"
}

# ARG
# $1 - Config name
# $2 - Source file
function _path {
	local file=./../$1/$2
	local file_with_env=./../$1/$APP_ENVIRONMENT/$2

	if [ -d $file_with_env ]; then
	 file=$file_with_env
	fi

  echo "$file"
}