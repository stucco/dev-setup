#!/bin/sh

which ansible-galaxy > /dev/null
if [ $? == 1 ]; then
  echo "Install ansible: http://docs.ansible.com/intro_installation.html"
fi

ansible-galaxy install -r requirements.txt -p roles