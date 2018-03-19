#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

function chef_imagemagick {
  # More on https://stackoverflow.com/questions/3704919/installing-rmagick-on-ubuntu
	title 'Install Image Magick'

  sudo apt-get install imagemagick libmagickwand-dev
}