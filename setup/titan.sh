#!/bin/bash

# Install [Titan](http://thinkaurelius.github.io/titan/)

# Argument is the version to install, or default value
VERSION=${1:-'0.3.2'}
BACKEND=cassandra  # cassandra or hbase
TITAN=titan-${BACKEND}-${VERSION}

if [ ! -d /usr/local/${TITAN} ]; then 
  echo "Installing Titan ${VERSION}..."
  cd /usr/local
  FILE=${TITAN}.zip
  sudo curl --silent -LO http://s3.thinkaurelius.com/downloads/titan/${FILE}
  sudo unzip -qo ${FILE}
  sudo rm -f ${FILE}
  echo "Titan has been installed."
fi