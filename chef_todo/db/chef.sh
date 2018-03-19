#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Install DB server
#
# ARG
# $1 DB hostname. One of
#   - postgresql
function chef_db {
  if [ -z "$1" ]; then
    title "[ERROR] DB is not specified. Valid are: ['postgresql']"
    exit 0
  fi

  if [ "$2" == "postgresql" ]; then
    chef_postgresql
  fi
}