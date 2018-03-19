#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

# Install Postfix for send notification to developers
# for example System notification, Monit, etc
function chef_postfix {
	title 'Configure Postfix'

sudo cat > /etc/postfix/header_checks << EOF1
/^From:[[:space:]]+(.*)/ REPLACE From: Notifier $(hostname) <notifier@server.com>
EOF1

	cd /etc/postfix && sudo postmap header_checks
	cd -

	# Person who should get root's mail
	echo "root:          $NOTIFIER_EMAIL" >> /etc/aliases
	sudo newaliases

	sudo postconf -e "inet_interfaces = loopback-only"
	sudo postconf -e "sender_canonical_maps = static:no-reply@<FQDN>"
	sudo postconf -e "smtp_header_checks = regexp:/etc/postfix/header_checks"

	sudo service postfix restart

	info "Send test email to $NOTIFIER_EMAIL, check your inbox/spam folder"
	info "For enable DKIM sender authentication system, check chef/opendkim"
	runuser -l deploy -c "echo 'Hello from Postfix' | mailx -s 'Postfix' $NOTIFIER_EMAIL"
}