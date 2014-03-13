#!/bin/sh

echo "Installing node.js..."

VERSION=${1:-'0.10.26'}
PLATFORM=linux-x64

cd /usr/local
curl http://nodejs.org/dist/v${VERSION}/node-v${VERSION}-${PLATFORM}.tar.gz | tar xvz --strip-components=1 && rm ChangeLog LICENSE README.md

echo "Node.js has been installed"