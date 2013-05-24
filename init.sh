#!/bin/sh

# Install [berkshelf](http://berkshelf.com/) if it isnt installed already
`which berks` || gem install berkshelf

# Install cookbooks specified in Berksfile
berks install

# Initialize the Vagrant vm
vagrant up