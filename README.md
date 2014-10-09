
# Setup for development, test, and demo environment

This project will set up the test and demonstration environment for Stucco using [Vagrant](http://www.vagrantup.com/). 

## Setup

Note: to use the provided setup, **you must have a 64-bit machine that supports Intel VT-x or AMD-V**.

1. [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your OS and install. This was tested with version 4.3.x.
2. [Download Vagrant](http://www.vagrantup.com/downloads.html) for your OS and install. This was tested with version 1.6.x.
3. Install [Vagrant plugins](http://docs.vagrantup.com/v2/plugins/index.html) by running `install-vagrant-plugins.sh`. (Note that you'll need to reinstall these plugins whenever you update vagrant.)
4. Get this repo from [github](https://github.com/stucco/dev-setup) and any other repos that you need.

        mkdir stucco && cd $_
        git clone https://github.com/stucco/dev-setup.git
      
5. Run `vagrant up` to build the VM. If you have multiple networks interfaces, you may be asked what interface should the network bridge to - pick whichever one you normally use on your host OS. This will take a few minutes as your VM is built. 

        cd dev-setup
        vagrant up

If you want to set an IP address, use the `VM_IP` environment variable before the `vagrant up` command:

        VM_IP="172.17.18.12" vagrant up

If you want to set hostname, use the `VM_HOSTNAME` environment variable before the `vagrant up` command:

        VM_HOSTNAME="stucco-1" vagrant up

6. Run `vagrant ssh` to log into the VM. The stucco project will be in `/stucco` and/or `stucco-shared` (see below). To start loading data, run the following in the VM:  `/vagrant/scripts/load-stucco-data.sh`


## Usage

To stop/start the VM, the fastest approach is to use `vagrant suspend` and `vagrant resume`. You can also use `vagrant halt` and `vagrant up`, but this will completely rebuild the VM each time.

To access the VM from the host, use the  host-only IP address defined at the top of the `Vagrantfile`:

    options = {
      :ip => "10.10.10.100"
    }

Networking is set up as *host-only*, so you will not be able to connect to the VM from another machine. A public network is also set up, but no ports are forwarded on that interface; this allows the VM to connect to the Internet.

Within the created Virtual Machine, you can either run the shared source code from your machine or the [version on github](https://github.com/stucco).

### Shared Directory

Using the Shared directory from the host OS is a good way to test your code. 

The parent directory of this project will be mounted within the VM at `/stucco-shared`. It is expected that you will have a directory structure where all of the repositories are in a common folder, so it looks like this:

    - stucco
      - dev-setup
      - collectors
      - rt
      - other required repos...

###  Github Directory

Using the Github directory is a good way to demonstrate stucco, since it ensures that the version of code on Github is used.

All Stucco components will be pulled from github and built in the `/stucco` directory.


## Testing

Tests are run automatically at the end of the VM building process. All commands in `scripts/run-stucco-tests.sh` will execute. To run all tests you can execute this script manually from within the VM.


## Demonstration

To run the demonstration or test, you should start up vagrant and then send data into the RabbitMQ queue.

    vagrant ssh
    # send data to queue to process
    /vagrant/scripts/load-stucco-data.sh

For more information, see the ['demo' page on the wiki.](https://github.com/stucco/dev-setup/wiki/Demo)

## Troubleshooting

See the ['debugging' page on the wiki.](https://github.com/stucco/dev-setup/wiki/Debugging)

## Snapshots

See the ['Snapshots' page on the wiki.](https://github.com/stucco/dev-setup/wiki/Snapshots)

## Uninstall

To completely remove everything:

    vagrant plugin uninstall vagrant-librarian-chef
    vagrant plugin uninstall vagrant-omnibus
    rm -rf .vagrant cookbooks tmp

Then uninstall Vagrant and VirtualBox. (Look at disk images to see if there is an uninstall script for your OS.)


## Notes

### VPN

The Cisco VPN, and maybe others, may screw up the ability to access the guest from the host OS. Turn off the VPN and maybe restart.

### Librarian-Chef

Vagrant uses [a plugin](https://github.com/jimmycuadra/vagrant-librarian-chef) to interface with [Librarian-Chef](https://github.com/applicationsonline/librarian-chef) to manage the Chef cookbooks, which define how applications are installed on the VM. To get new versions of cookbooks, you will need to delete the `Cheffile.lock` file, which locks in the versions of the cookbooks that are used.
