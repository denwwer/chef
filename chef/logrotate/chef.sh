#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"
. "$(pwd)/ext/copy.sh"

function chef_logrotate {
	title 'Configure Logrotate'

	copy "logrotate" "app" "/etc/logrotate.d/app"
	copy "logrotate" "monit" "/etc/logrotate.d/monit"
}