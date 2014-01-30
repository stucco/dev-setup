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

# [forever](https://github.com/nodejitsu/forever) for starting node.js daemons
sudo npm install -g forever --quiet

# Load configuration into etcd
cd $DIR/config-loader
NODE_ENV=vagrant node load.js

# Compile rt
cd $DIR/rt
sudo sbt compile
# sudo sbt run

# Install node modules and start document-service
cd $DIR/document-service
sudo npm install --quiet
sudo forever start --append -l /var/log/doc-service-forever.log -o /var/log/doc-service-out.log -e /var/log/doc-service-err.log --pid /var/run/document-service.pid server.js
