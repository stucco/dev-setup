#!/bin/bash

# Cassandra setup first
if [ ! -e /usr/sbin/cassandra ]; then 
  echo "Installing Cassandra 1.2 branch..."
  sudo  sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 12x main" > /etc/apt/sources.list.d/cassandra.list'
  sudo  sh -c 'echo "deb-src http://www.apache.org/dist/cassandra/debian 12x main" >> /etc/apt/sources.list.d/cassandra.list'
  gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
  gpg --export --armor F758CE318D77295D | sudo apt-key add -
  gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
  gpg --export --armor 2B5C1B00 | sudo apt-key add -
  sudo apt-get update
  sudo apt-get -y install cassandra
  echo "Cassandra has been installed."
fi

# Install [Titan](http://thinkaurelius.github.io/titan/)

# Argument is the version to install, or default value
VERSION=${1:-'0.4.2'}
BACKEND=server  #"server" includes rexter, cassandra, and all other backend/indexing support
TITAN=titan-${BACKEND}-${VERSION}

if [ ! -d /usr/local/${TITAN} ]; then 
  echo "Installing Titan ${VERSION}..."
  cd /usr/local
  FILE=${TITAN}.zip
  sudo curl --silent -LO http://s3.thinkaurelius.com/downloads/titan/${FILE}
  sudo unzip -qo ${FILE}
  sudo rm -f ${FILE}
  echo "Titan has been installed."
  /usr/local/titan-server-0.4.2/bin/titan.sh start
  echo "Titan has been started."
fi