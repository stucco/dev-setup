
Stucco Dev-Setup
================

This project will set up the test and demonstration environment for Stucco using [Vagrant](http://www.vagrantup.com/). Linux and Mac OS X are supported.

## Setup

1. [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your OS and install. (Tested with version 4.3.x.)
1. [Download Vagrant](http://www.vagrantup.com/downloads.html) for your OS and install. (Tested with version 1.7.x.)
1. [Download Ansible](http://docs.ansible.com/intro_installation.html). (Tested with version 1.7.x.). ([Ansible requires Python 2.6](http://docs.ansible.com/intro_installation.html#control-machine-requirements).)
1. Get this repo from [github](https://github.com/stucco/dev-setup) : `git clone https://github.com/stucco/dev-setup.git stucco && cd stucco`.
1. Start the VM:  `vagrant up`
1. Open a web browser to `http://10.10.10.100:8000/`. Not all data will be there right away, it takes some time to load everything. Start on the [help page](http://10.10.10.100:8000/help). (The default Vagrant IP address is 10.10.10.100; if you change it, change the URL.)


## Usage

Run `vagrant ssh` to log into the VM. The stucco project will be in `/stucco` and/or `stucco-shared` (see below). 

#### Customize IP/hostname

If you want to set an IP address, use the `VM_IP` environment variable before the `vagrant up` command:

        VM_IP="172.17.18.12" vagrant up

If you want to set hostname, use the `VM_HOSTNAME` environment variable before the `vagrant up` command:

        VM_HOSTNAME="stucco-1" vagrant up

To access the VM from the host, use the  host-only IP address defined at the top of the `Vagrantfile`:

    options = {
      :ip => "10.10.10.100"
    }

Networking is set up as *host-only*, so you will not be able to connect to the VM from another machine.

#### Vagrant notes

This `Vagrantfile` assumes your machine can handle 10gb of memory and 4 cores dedicated to the virtual machine, if you need to lower this, edit [this section for your provider](https://github.com/stucco/dev-setup/blob/master/Vagrantfile#L50-L60).

To stop/start the VM, the fastest approach is to use `vagrant suspend` and `vagrant resume`. You can also use `vagrant halt` and `vagrant up`, but this will completely rebuild the VM each time.

To cache some dependencies to make `vagrant up` faster, install the Vagrant cache plugin to use a cache for downloaded software by running `vagrant plugin install vagrant-cachier`. 

To use Vagrant snapshots, see the ['Snapshots' page](https://github.com/stucco/dev-setup/wiki/Snapshots) on the wiki. Install the Vagrant snapshot plugin by running `vagrant plugin install vagrant-vbox-snapshot`. 

If you want less verbose output from vagrant, you can [change the log level](http://docs.vagrantup.com/v2/other/debugging.html):

        VAGRANT_LOG=warn vagrant up


##  Using the VM for demonstration

All Stucco components will be pulled from the repos on Github and built in the `/stucco` directory. Each of the components will be started automatically. To confirm this, log into the VM (`vagrant ssh`) and run `sudo supervisorctl status`). Log files are in `/var/log/supervisord/`.


## Using the VM for development

The parent directory of this project will be mounted within the VM at `/stucco-shared`. It is expected that you will have a directory structure where all of the repositories are in a common folder, so it looks like this:

    - stucco
      - dev-setup
      - document-service
      - collectors
      - rt
      - ui

The Github code is started by default, using [supervisord](http://supervisord.org/). In order to use the repos from your host OS, you will need to change the paths for each of the stucco files in `/etc/supervisor/conf.d` to `/stucco-shared`, and reload the configurations (`supervisorctl reload`), then restart the processes (`supervisorctl start all`).


## Troubleshooting

See the ['Debugging' page](https://github.com/stucco/dev-setup/wiki/Debugging) on the wiki.

#### 64 bit / Virtualization

The host OS machine should be relatively recent and should have Virtualization enabled in the BIOS. A 64-bit machine that supports Intel VT-x or AMD-V should work. If you do not have a 64-bit machine or the BIOS Virtualization enabled, you can try to change this line in the `Vagrantfile`:

    config.vm.box = "hashicorp/precise64"

To:

    config.vm.box = "hashicorp/precise32"

#### VPNs

The Cisco VPN, and maybe others, may screw up the ability to access the guest from the host OS. Turn off the VPN and maybe restart.
