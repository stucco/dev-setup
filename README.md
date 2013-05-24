
This project will set up the test and demonstration environment for Stucco using Vagrant. Your directory structure should look something like this:

    stucco
      vagrant-setup
      other-stucco-project-1
      other-stucco-project-2

# Usage

First, [download VirtualBox](https://www.virtualbox.org/wiki/Downloads) and install. This was tested with version 4.2.12, but any 4.2.x version should work.

[Download a Vagrant installer](http://downloads.vagrantup.com/) for Mac OS, Windows, and Linux and install it. This was tested with version 1.2.2, but any 1.x version should work.

To build the VM, run `init.sh`. This script installs the [Vagrant Plugins](http://docs.vagrantup.com/v2/plugins/index.html) and runs `vagrant up` to build the VM.

To log into the VM, run `vagrant ssh`. The parent directory from this project (where you ran the `init.sh` script) will be mounted under /stucco within the VM.