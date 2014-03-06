#!/bin/sh

# Run this from within the Vagrant VM to run all tests sequentially.

echo "Running stucco tests..."

# Test [rt](https://github.com/stucco/rt)
# cd /stucco/rt
# TODO: mvn test

# Test [document-service](https://github.com/stucco/document-service)
cd /stucco/document-service
NODE_ENV=vagrant npm test
