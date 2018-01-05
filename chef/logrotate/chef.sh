#!/usr/bin/env bash

. "$(pwd)/ext/echo_title.sh"
. "$(pwd)/ext/copy.sh"

function chef_logrotate {
	echo_title 'Configure Logrotate'

	copy_conf "logrotate" "app" "/etc/logrotate.d/app"
	copy_conf "logrotate" "monit" "/etc/logrotate.d/monit"
}