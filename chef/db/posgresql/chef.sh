#!/usr/bin/env bash

. "$(pwd)/ext/title.sh"

function chef_postgresql {
	title "Install Postgres"

  sudo -S -u deploy -i /bin/bash -l -c 'sudo apt-get install -q=2 postgresql postgresql-contrib libpq-dev'

  cd '/etc/postgresql/';
  version_name=$(ls);
  cd "/etc/postgresql/$version_name/main/";
  sudo sed -i -r  "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "postgresql.conf";

  read -p "PG Database Name: " pg_database;
  read -p "PG Username: " pg_username;
  read -p "PG password for $pg_username: " pg_password; # TODO add confirmation

  sudo -u postgres psql -c "CREATE DATABASE $pg_database;";
  sudo -u postgres psql -c "CREATE USER $pg_username WITH password '$pg_password';";
#    TODO hide password
  sudo -u postgres psql -c "GRANT ALL ON DATABASE $pg_database TO $pg_username;";

  cd "/etc/postgresql/$version_name/main/";

  # TODO fix
  # sudo -i -u deploy echo "local $pg_database $pg_username   md5" >> "/etc/postgresql/$version_name/main/pg_hba.conf";
  sudo -S -u deploy -i /bin/bash -l -c 'sudo service postgresql restart';
}