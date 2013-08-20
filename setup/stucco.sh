#!/bin/bash

# Get stucco components

STUCCO_HOME=/usr/local/stucco
STUCCO_REPOS="rt collectors"

if [ ! -d "${STUCCO_HOME}" ]; then
  sudo mkdir -m 0777 $STUCCO_HOME  
fi

for repo in $STUCCO_REPOS; do
  if [ ! -d "${STUCCO_HOME}/${repo}" ]; then
    cd $STUCCO_HOME
    git clone https://github.com/stucco/${repo}.git
  else
    cd $STUCCO_HOME/$repo && sudo git pull && cd ..
  fi
done