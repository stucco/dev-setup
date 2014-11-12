#!/bin/sh

echo "Installing node.js..."

VERSION=${1:-'0.10.32'}
PLATFORM=linux-x64
FILE=node-v${VERSION}-${PLATFORM}.tar.gz

cd /var/cache/wget #TODO rename cache dir
curl -sS -z ${FILE} -O http://nodejs.org/dist/v${VERSION}/${FILE}
cd /usr/local
ln -s /var/cache/wget/${FILE} ${FILE}

tar xz --strip-components=1 -f ${FILE}

rm ChangeLog LICENSE README.md

echo "Node.js has been installed"