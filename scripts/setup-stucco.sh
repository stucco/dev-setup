#!/bin/sh

STUCCO_HOME=/stucco

echo "Installing Stucco components..."

sudo mkdir -p $STUCCO_HOME
sudo chmod 4777 $STUCCO_HOME
sudo chown vagrant:vagrant $STUCCO_HOME


### Download the repositories
cd $STUCCO_HOME
repos="ontology config-loader rt collectors document-service endogenous-data-uc1 get-exogenous-data jetcd"
for repo in $repos; do
  IFS=" "
  echo "cloning ${repo}"
  git clone --recursive https://github.com/stucco/${repo}.git
done

# Download exogenous data and put in data dir
cd $STUCCO_HOME/get-exogenous-data
npm start

# Move endogenous data into data dir
cd $STUCCO_HOME/endogenous-data-uc1

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

# Install jetcd
cd $STUCCO_HOME/jetcd
./gradlew install

# Install collectors
cd $STUCCO_HOME/collectors
mvn install

sudo chown -R vagrant:vagrant $STUCCO_HOME

echo "Stucco has been installed."
