
# Setup for development, test, and demo environment

This project will set up the test and demonstration environment for Stucco using [Vagrant](http://www.vagrantup.com/). 

## Setup

Note: to use the provided setup, **you must have a 64-bit machine that supports Intel VT-x or AMD-V**.

1. [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your OS and install. This was tested with version 4.3.x.
2. [Download Vagrant](http://www.vagrantup.com/downloads.html) for your OS and install. This was tested with version 1.6.x.
3. [Download Ansible](http://docs.ansible.com/intro_installation.html). This was tested with version 1.7.x.
4. Optionally, install [Vagrant plugins](http://docs.vagrantup.com/v2/plugins/index.html) by running `install-vagrant-plugins.sh`. This will enable the use of a cache for downloading software and the ability to use Vagrant to create VM snapshots.
5. Get this repo from [github](https://github.com/stucco/dev-setup) and any other repos that you need.

        mkdir stucco && cd $_
        git clone https://github.com/stucco/dev-setup.git
      
6. Run `vagrant up` to build the VM: 

        cd dev-setup
        vagrant up

If you want less verbose output from vagrant, you can [change the log level](http://docs.vagrantup.com/v2/other/debugging.html):

        VAGRANT_LOG=warn vagrant up

If you want to set an IP address, use the `VM_IP` environment variable before the `vagrant up` command:

        VM_IP="172.17.18.12" vagrant up

If you want to set hostname, use the `VM_HOSTNAME` environment variable before the `vagrant up` command:

        VM_HOSTNAME="stucco-1" vagrant up

7. Run `vagrant ssh` to log into the VM. The stucco project will be in `/stucco` and/or `stucco-shared` (see below). To start loading data, run the following in the VM:  

    cd /stucco && ./collectors/scheduler-vm.sh demo-load


## Usage

To stop/start the VM, the fastest approach is to use `vagrant suspend` and `vagrant resume`. You can also use `vagrant halt` and `vagrant up`, but this will completely rebuild the VM each time.

To access the VM from the host, use the  host-only IP address defined at the top of the `Vagrantfile`:

    options = {
      :ip => "10.10.10.100"
    }

Networking is set up as *host-only*, so you will not be able to connect to the VM from another machine.

### Shared Directory

Using the Shared directory from the host OS is a good way to test your code.  The Github code is started by default, using [supervisord](http://supervisord.org/). You will need to change the paths to point to `/stucco-shared` in `/etc/supervisor/conf.d`, and reload the configurations (`supervisorctl reload`), then restart the processes (`supervisorctl start all`).

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

To run tests: `/vagrant/scripts/run-stucco-tests.sh` 

## Demonstration

To run the demonstration or test, you should start up vagrant and then send data into the RabbitMQ queue.

    vagrant ssh
    /vagrant/scripts/load-stucco-data.sh

For more information, see the ['Demo' page](https://github.com/stucco/dev-setup/wiki/Demo) on the wiki.

## Troubleshooting

See the ['Debugging' page](https://github.com/stucco/dev-setup/wiki/Debugging) on the wiki.

## Snapshots

See the ['Snapshots' page](https://github.com/stucco/dev-setup/wiki/Snapshots) on the wiki.

## Notes

### VPN

The Cisco VPN, and maybe others, may screw up the ability to access the guest from the host OS. Turn off the VPN and maybe restart.
