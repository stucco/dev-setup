#!/bin/sh

echo "Installing node.js..."

VERSION=${1:-'0.10.26'}
PLATFORM=linux-x64
FILE=node-v${VERSION}-${PLATFORM}.tar.gz

cd /usr/local
wget -N -P /var/cache/wget http://nodejs.org/dist/v${VERSION}/${FILE}
ln -s /var/cache/wget/${FILE} ${FILE}

tar xvz --strip-components=1 -f ${FILE}

rm ChangeLog LICENSE README.md

echo "Node.js has been installed"