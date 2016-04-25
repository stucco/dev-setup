#!/bin/bash

# Update apt cache
apt-get -y update > /dev/null

# upgrade packages
apt-get -yq upgrade

# Install common build packages
apt-get -yq install software-properties-common build-essential

# Customize login message
echo 'Welcome to your Stucco virtual machine.' > /etc/motd

# Set environment variables that ansible roles will need
echo 'STUCCO_DB_TYPE=ORIENTDB' >> /etc/environment
echo 'STUCCO_DB_CONFIG="/stucco/graph-init/config/orientdb.yml"' >> /etc/environment
echo 'STUCCO_DB_INDEX_CONFIG="/stucco/graph-init/config/stucco_orientdb_indexing.json"' >> /etc/environment
#TODO: check if they were set previously