#!/bin/sh

# Install the Vagrant plugins (for Vagrant 1.1.0 and greater)
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus

# Initialize the Vagrant vm
vagrant up