#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

function chef_swap {
	title 'Extend SWAP usage'

  # More on https://stackoverflow.com/questions/22272339/rake-assetsprecompile-gets-killed-when-there-is-a-console-session-open-in-produ

  # to see current usage
  #  sudo swapon -s

  # Step 1: Allocate a file for swap
  sudo fallocate -l 2048m /mnt/swap_file.swap

  # Step 2: Change permission
  sudo chmod 600 /mnt/swap_file.swap

  # Step 3: Format the file for swapping device
  sudo mkswap /mnt/swap_file.swap

  #Step 4: Enable the swap
  sudo swapon /mnt/swap_file.swap

  # Make sure it is installed
  echo "Result SWAP usage"
  sudo swapon -s
}