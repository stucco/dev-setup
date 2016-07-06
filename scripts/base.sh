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
echo 'STUCCO_DB_TYPE=POSTGRESQL' >> /etc/environment
echo 'STUCCO_DB_CONFIG="/stucco/rt/graph-db-connection/config/postgresql.yml"' >> /etc/environment
echo 'STUCCO_DB_INDEX_CONFIG=""' >> /etc/environment
#TODO: check if they were set previously