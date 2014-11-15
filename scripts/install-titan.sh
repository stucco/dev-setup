#!/bin/bash

# Install [Titan](http://thinkaurelius.github.io/titan/)

# Argument is the version to install, or default value
VERSION=${1:-'0.5.1'}
IP=${2:-'10.10.10.100'}
TITAN=titan-${VERSION}-hadoop2
FILE=${TITAN}.zip

if [ ! -d /usr/local/${TITAN} ] 
  then 
  echo "Installing Titan ${VERSION}..."
  cd /var/cache/wget #TODO should rename cache dir also
  curl -sS -z ${FILE} -O http://s3.thinkaurelius.com/downloads/titan/${FILE}
  cd /usr/local
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
  sudo ./bin/titan.sh start
  echo "Titan has been started."
fi
