#!/bin/sh

# Start Stucco Components

# Start collectors / replayer

# Start rt (Storm topology)

# Start document-service
DS_DIR=/stucco/document-service
if [ -d ${DS_DIR} ]; then
  echo 'Starting document-service...'
  cd ${DS_DIR}
  npm start
else
  echo 'The document-service repository is not available. Do a `git clone https://github.com/stucco/document-service.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi