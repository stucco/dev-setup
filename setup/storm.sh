#!/bin/bash

# Install [Storm](http://storm-project.net/)

# Argument is the version to install, or default value
VERSION=${1:-'0.9.0.1'}

if [ ! -d /usr/local/storm-${VERSION} ]; then 
  echo "Installing Storm ${VERSION}..."
  cd /usr/local
  sudo curl --silent -L https://dl.dropboxusercontent.com/s/tqdpoif32gufapo/storm-${VERSION}.tar.gz -o storm.tgz
  sudo tar xzfv storm.tgz
  sudo ln -s ../storm-${VERSION}/bin/storm bin/storm
  sudo rm -f storm.tgz
  sudo chmod +x bin/storm
  echo "Storm has been installed."
fi