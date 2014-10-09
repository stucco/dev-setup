#!/bin/sh

STUCCO_HOME=${1:-'/stucco'}

echo "Installing remaining dependencies..." 

echo y | sudo apt-get install supervisor
sudo easy_install supervisor

echo "Installing Stucco components..."

if [ ! -d $STUCCO_HOME ]; then
  sudo mkdir -p $STUCCO_HOME
  sudo chmod 4777 $STUCCO_HOME
  sudo chown vagrant:vagrant $STUCCO_HOME
fi

### Download the repositories
cd $STUCCO_HOME
repos="ontology config-loader rt collectors document-service endogenous-data-uc1 get-exogenous-data ui"
for repo in $repos; do
  if [ -d $repo ]; then
  	echo "not cloning ${repo}, already exists"
  else
    IFS=" "
    echo "cloning ${repo}"
    git clone --recursive https://github.com/stucco/${repo}.git
  fi
done

#configure ui dependencies, start ui
sudo npm install -g bower
sudo npm install -g http-server
cd $STUCCO_HOME/ui
http-server ./ > server.log &

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
cd streaming-processor
mvn clean package

# Install node modules and start document-service
cd $STUCCO_HOME/document-service
npm install --quiet

# Install collectors
cd $STUCCO_HOME/collectors
./maven-collectors-build.sh

#set various permissions
sudo gpasswd -a logstash vagrant
sudo chmod g+w /stucco/rt/
sudo chmod g+w /stucco/rt/streaming-processor 
sudo chown -R vagrant:vagrant $STUCCO_HOME

echo "Stucco has been installed."
