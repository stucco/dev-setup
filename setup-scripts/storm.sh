#!/bin/bash

# Install [Storm](http://storm-project.net/)

# Argument is the version to install, or default value
VERSION=${1:-'0.8.2'}

if [ ! -d /usr/local/storm-${VERSION} ]; then 
  echo "Installing Storm ${VERSION}..."
  cd /usr/local
  sudo curl --silent -LO https://dl.dropbox.com/u/133901206/storm-${VERSION}.zip
  sudo unzip -qo storm-${VERSION}.zip
  sudo ln -s ../storm-${VERSION}/bin/storm bin/storm
  sudo rm -f storm-${VERSION}.zip
  sudo chmod +x bin/storm
  echo "Storm has been installed."
fi