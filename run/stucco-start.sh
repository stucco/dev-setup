#!/bin/sh

### Start Stucco Components

# Start rt (Storm topology)
RT_DIR=/stucco/rt
if [ -d ${RT_DIR} ]; then
  echo 'Starting rt storm topology...'
  cd ${RT_DIR}
  mvn exec:java
else
  echo 'The rt repository is not available. Do a `git clone https://github.com/stucco/rt.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi

# Start document-service
DS_DIR=/stucco/document-service
if [ -d ${DS_DIR} ]; then
  echo 'Starting document-service...'
  cd ${DS_DIR}
  forever start --append -l /var/log/doc-service-forever.log -o /var/log/doc-service-out.log -e /var/log/doc-service-err.log --pid /var/run/document-service.pid server.js
else
  echo 'The document-service repository is not available. Do a `git clone https://github.com/stucco/document-service.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi

# Start collectors / replayer

## TODO
