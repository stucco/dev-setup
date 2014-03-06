#!/bin/sh

echo "Installing node.js..."

sudo apt-get install python-software-properties python g++ make -y
sudo add-apt-repository ppa:chris-lea/node.js -y
sudo apt-get update
sudo apt-get install nodejs -y

echo "Node.js has been installed"