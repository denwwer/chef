#!/usr/bin/env bash
. ././../ext/echo_title.sh
. ././../ext/conf_operations.sh

# ARG
# $1 - OpenDKIM Socket
# $2 - Domain name
function chef_opendkim {
  echo_title 'Configure  OpenDKIM'
	# More on https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy#add-the-public-key-to-the-domain-39-s-dns-records

	sudo mkdir -p /etc/opendkim/keys/$DOMAIN_NAME
	cd /etc/opendkim/keys/$DOMAIN_NAME && sudo opendkim-genkey -s mail -d $DOMAIN_NAME

	copy_conf "opendkim" "key_table" "/etc/opendkim/"
	copy_conf "opendkim" "signing_table" "/etc/opendkim/"
	copy_conf "opendkim" "trusted_hosts" "/etc/opendkim/"

	append_conf "opendkim" "opendkim.conf" "/etc/opendkim.conf"

	chown -R opendkim:opendkim /etc/opendkim

	sudo cat >> /etc/default/opendkim << EOF1
	  SOCKET="inet:$OPENDKIM_SOCKET@localhost"
	EOF1
}