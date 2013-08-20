#!/bin/bash

# Install [Neo4j](http://www.neo4j.org/) using debian package

# Argument is the version to install, or default value
VERSION=${1:-'1.9.2'}
NEO4J_HOME=/usr/local/neo4j-community-${VERSION}

if [ ! -d "${NEO4J_HOME}" ]; then 
  echo "Installing Neo4j..."
  cd /usr/local
  sudo curl --silent -L http://download.neo4j.org/artifact?edition=community\&version=${VERSION}\&distribution=tarball | sudo tar xz
  sudo ln -s ${NEO4J_HOME}/bin/neo4j bin/neo4j
  sudo ln -s ${NEO4J_HOME}/bin/neo4j-shell bin/neo4j-shell
  sudo sed -i -e '/org\.neo4j\.server\.webserver\.address/s/^#//' ${NEO4J_HOME}/conf/neo4j-server.properties
  echo "neo4j" | sudo neo4j install
  echo "Neo4j has been installed."
fi

# start service if neo4j is not running
if [ `ps -ef | grep -v grep | grep -c neo4j` -eq 0 ]; then
  sudo service neo4j-service start
fi