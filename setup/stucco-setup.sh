#!/bin/sh

### Download the repositories

export STUCCO_HOME=${DIR}

sudo mkdir $STUCCO_HOME
sudo chmod 4777 $STUCCO_HOME
sudo chown vagrant:vagrant $STUCCO_HOME

cd $STUCCO_HOME
repos="ontology config-loader rt collectors document-service"
for repo in $repos; do
  IFS=" "
  echo "cloning ${repo}"
  git clone --recursive https://github.com/stucco/${repo}.git
done

# Additional setup

# [forever](https://github.com/nodejitsu/forever) for starting node.js daemons
npm install -g forever --quiet

# Load configuration into etcd
cd $STUCCO_HOME/config-loader
NODE_ENV=vagrant node load.js

# Compile rt
cd $STUCCO_HOME/rt
./maven-rt-build.sh
cd stucco-topology
mvn clean package

# Install node modules and start document-service
cd $STUCCO_HOME/document-service
npm install --quiet