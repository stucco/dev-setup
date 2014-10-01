#!/bin/bash

DSC_VERSION=21

# Cassandra setup first
if [ ! -e /usr/sbin/cassandra ] 
  then 
  echo "Installing Cassandra..."
  echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
  curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install dsc${DSC_VERSION} -y #This installs the DataStax Community distribution of Cassandra. 
  #Because the Debian packages start the Cassandra service automatically, you must stop the server and clear the data:
  #Doing this removes the default cluster_name (Test Cluster) from the system table. All nodes must use the same cluster name.
  #see http://www.datastax.com/documentation/cassandra/2.0/cassandra/install/installDeb_t.html
  sudo service cassandra stop # kill the default instance
  sudo killall -u cassandra # try this way also
  sudo rm -rf /var/lib/cassandra/data/system/* # remove default data
  echo "Cassandra has been installed."
fi

# Install [Titan](http://thinkaurelius.github.io/titan/)

# Argument is the version to install, or default value
VERSION=${1:-'0.5.0'}
IP=${2:-'10.10.10.100'}
TITAN=titan-${VERSION}-hadoop2

if [ ! -d /usr/local/${TITAN} ] 
  then 
  echo "Installing Titan ${VERSION}..."
  cd /usr/local
  FILE=${TITAN}.zip
  wget -N -P /var/cache/wget http://s3.thinkaurelius.com/downloads/titan/${FILE}
  ln -s /var/cache/wget/${FILE} ${FILE}
  unzip -qo ${FILE}
  echo "Titan has been installed."
  cd ${TITAN}
  #set rexster/doghouse address
  mv conf/rexster-cassandra-es.xml conf/rexster-cassandra-es.xml.orig
  cat conf/rexster-cassandra-es.xml.orig | sed -e "/<base-uri>/s/localhost/""$IP""/" > conf/rexster-cassandra-es.xml
  #bump rexster heap size
  cp bin/rexster.sh bin/rexster.sh.orig
  sudo bash -c 'cat bin/rexster.sh.orig | sed -e "/-server/s/-Xms128m -Xmx512m/-Xms128m -Xmx2048m -XX:MaxPermSize=256m/" > bin/rexster.sh'
  sudo chmod a+x bin/rexster.sh
  sudo killall -u elasticsearch #there is an extra instance already started for some reason, but we need the titan-created instance to be the only one
  sleep 5
  sudo ./bin/titan.sh start
  echo "Titan has been started."
fi
