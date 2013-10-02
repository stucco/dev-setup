#!/bin/sh

# Install the Vagrant plugins (for Vagrant 1.1.0 and greater)
vagrant plugin install vagrant-librarian-chef
vagrant plugin install vagrant-omnibus

echo "Now you can start the VM with the command: vagrant up"