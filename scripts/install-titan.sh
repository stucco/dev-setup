#!/bin/bash

# Cassandra setup first
if [ ! -e /usr/sbin/cassandra ]; then 
  echo "Installing Cassandra 1.2 branch..."
  sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 12x main" > /etc/apt/sources.list.d/cassandra.list'
  sh -c 'echo "deb-src http://www.apache.org/dist/cassandra/debian 12x main" >> /etc/apt/sources.list.d/cassandra.list'
  gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
  gpg --export --armor F758CE318D77295D | apt-key add -
  gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
  gpg --export --armor 2B5C1B00 | apt-key add -
  apt-get update
  apt-get -y install cassandra
  service cassandra stop # kill the default instance
  echo "Cassandra has been installed."
fi

# Install [Titan](http://thinkaurelius.github.io/titan/)

# Argument is the version to install, or default value
VERSION=${1:-'0.4.2'}
IP=${2:-'10.10.10.100'}
BACKEND=server  #"server" includes rexter, cassandra, and all other backend/indexing support
TITAN=titan-${BACKEND}-${VERSION}

if [ ! -d /usr/local/${TITAN} ]; then 
  echo "Installing Titan ${VERSION}..."
  cd /usr/local
  FILE=${TITAN}.zip
  curl --silent -LO http://s3.thinkaurelius.com/downloads/titan/${FILE}
  unzip -qo ${FILE}
  rm -f ${FILE}
  echo "Titan has been installed."
  cd ${TITAN}
  #set rexster/doghouse address
  mv conf/rexster-cassandra-es.xml conf/rexster-cassandra-es.xml.orig
  cat conf/rexster-cassandra-es.xml.orig | sed -e "/<base-uri>/s/localhost/""$IP""/" > conf/rexster-cassandra-es.xml
  #bump rexster heap size
  cp bin/rexster.sh bin/rexster.sh.orig
  sudo bash -c 'cat bin/rexster.sh.orig | sed -e "/-server/s/-Xms128m -Xmx512m/-Xms128m -Xmx2048m -XX:MaxPermSize=256m/" > bin/rexster.sh'
  sudo chmod a+x bin/rexster.sh
  ./bin/titan.sh start
  echo "Titan has been started."
fi
