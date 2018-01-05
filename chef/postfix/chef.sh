#!/usr/bin/env bash

. "$(pwd)/ext/echo_title.sh"

function chef_postfix {
	echo_title 'Configure Postfix'

sudo cat > /etc/postfix/header_checks << EOF1
/^From:[[:space:]]+(.*)/ REPLACE From: Notifier $HOST_IP <notifier@server.com>
EOF1

	cd /etc/postfix && sudo postmap header_checks

	# Person who should get root's mail
	echo "root:          $NOTIFIER_EMAIL" >> /etc/aliases
	sudo newaliases

	sudo postconf -e "inet_interfaces = loopback-only"
	sudo postconf -e "sender_canonical_maps = static:no-reply@<FQDN>"
	sudo postconf -e "smtp_header_checks = regexp:/etc/postfix/header_checks"

	sudo service postfix restart

	# Send test email to $NOTIFIER_EMAIL
	runuser -l deploy -c "echo 'Hello from Postfix' | mailx -s 'Postfix' $NOTIFIER_EMAIL"
}