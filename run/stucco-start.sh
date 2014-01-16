#!/bin/sh

### Start Stucco Components

# Start rt (Storm topology)
RT_DIR=/stucco/rt
if [ -d ${RT_DIR} ]; then
  echo 'Starting rt storm topology...'
  cd ${RT_DIR}
  sbt run
else
  echo 'The rt repository is not available. Do a `git clone https://github.com/stucco/rt.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi

# Start document-service
DS_DIR=/stucco/document-service
if [ -d ${DS_DIR} ]; then
  echo 'Starting document-service...'
  cd ${DS_DIR}
  npm start
else
  echo 'The document-service repository is not available. Do a `git clone https://github.com/stucco/document-service.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi

# Start collectors / replayer

## TODO
