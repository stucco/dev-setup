#!/bin/sh

### Download the repositories

DIR=/stucco
sudo mkdir $DIR
sudo chmod 4777 $DIR
cd $DIR
repos="ontology config rt collectors document-service"
for repo in $repos; do
  IFS=" "
  echo "cloning ${repo}"
  git clone https://github.com/stucco/${repo}.git
done

# Additional setup

# Install node modules
cd $DIR/document-service
sudo npm install -d