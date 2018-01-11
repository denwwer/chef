#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"
. "$(pwd)/ext/copy.sh"

# Add OpenDKIM
# More on https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy#add-the-public-key-to-the-domain-39-s-dns-records
#
# ARG
# $1 - OpenDKIM Socket
# $2 - Domain name
function chef_opendkim {
  title 'Configure  OpenDKIM'

	sudo postconf -e "milter_protocol = 2"
	sudo postconf -e "milter_default_action = accept"
	sudo postconf -e "smtpd_milters = inet:localhost:$OPENDKIM_SOCKET"
	sudo postconf -e "non_smtpd_milters = inet:localhost:$OPENDKIM_SOCKET"

	sudo service postfix restart

	sudo mkdir -p /etc/opendkim/keys/$DOMAIN_NAME
	cd /etc/opendkim/keys/$DOMAIN_NAME && sudo opendkim-genkey -s mail -d $DOMAIN_NAME
	cd -

	copy "opendkim" "key_table" "/etc/opendkim/"
	copy "opendkim" "signing_table" "/etc/opendkim/"
	copy "opendkim" "trusted_hosts" "/etc/opendkim/"

	append_conf "opendkim" "opendkim.conf" "/etc/opendkim.conf"

	chown -R opendkim:opendkim /etc/opendkim

sudo cat >> /etc/default/opendkim << EOF1
  SOCKET="inet:$OPENDKIM_SOCKET@localhost"
EOF1
}