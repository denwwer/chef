#!/usr/bin/env bash

function title {
  local blue='\033[1;34m'
  local nc='\033[0m' # No Color
  echo -e "${blue}[$(date '+%Y-%m-%d %H:%M:%S %Z')][Chef] $1${nc}"
}

function info {
  local green='\033[0;32m'
  local nc='\033[0m' # No Color
  echo -e "${green}$1${nc}"
}
