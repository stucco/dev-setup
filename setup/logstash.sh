#!/bin/bash

# Install [Logstash](http://logstash.net/)

# Argument is the version to install, or default value
VERSION=${1:-'1.1.13'}

if [ ! -d /opt/logstash ]; then
  echo "Installing Logstash ${VERSION}..."
  sudo adduser --system --home /opt/logstash --ingroup adm --disabled-password logstash
  cd /opt/logstash
  sudo curl --silent -LO https://logstash.objects.dreamhost.com/release/logstash-${VERSION}-flatjar.jar
  cd /etc/init
  sudo curl --silent -LO https://github.com/stucco/dev-setup/raw/master/logstash-indexer.conf
  cd /etc/
  sudo curl --silent -LO https://github.com/stucco/rt/raw/master/logstash.conf
  sudo initctl reload-configuration
  sudo initctl start logstash-indexer
  echo "Logstash has been installed."
fi