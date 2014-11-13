#!/bin/sh

STUCCO_HOME=${1:-'/stucco'}

echo "Installing remaining dependencies..." 

sudo apt-get -qq install supervisor -y

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
    git clone --recursive https://github.com/stucco/${repo}.git
  fi
done

# Download exogenous data and put in data dir
echo "Downloading exogenous data"
cd $STUCCO_HOME/get-exogenous-data
node download.js

# Load configuration into etcd
echo "Loading configuration"
cd $STUCCO_HOME/config-loader
NODE_ENV=vagrant node load.js

# Compile rt
echo "Building rt"
cd $STUCCO_HOME/rt
./maven-rt-build.sh
cd streaming-processor
mvn -q clean package

# Install node modules and start document-service
cd $STUCCO_HOME/document-service
sudo npm install --silent > /dev/null

# Install collectors
echo "Building collectors"
cd $STUCCO_HOME/collectors
./maven-collectors-build.sh

#set various permissions
sudo gpasswd -a logstash vagrant
if [ "/stucco-shared" != $STUCCO_HOME ]; then
  sudo chmod g+w $STUCCO_HOME/rt/
  sudo chmod g+w $STUCCO_HOME/rt/streaming-processor 
  sudo chown -R vagrant:vagrant $STUCCO_HOME
fi

echo "Stucco has been installed."
