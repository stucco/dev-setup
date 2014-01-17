#!/bin/sh

### Download the repositories

DIR=/stucco
sudo mkdir $DIR
sudo chmod 4777 $DIR
cd $DIR
repos="ontology config-loader rt collectors document-service"
for repo in $repos; do
  IFS=" "
  echo "cloning ${repo}"
  git clone --recursive https://github.com/stucco/${repo}.git
done

# Additional setup

# Install node modules
cd $DIR/document-service
sudo npm install -d

# Load configuration
cd $DIR/config-loader
NODE_ENV=vagrant node load.js