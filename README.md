# Setup for development and test environment

This project will set up the test and demonstration environment for Stucco using [Vagrant](http://www.vagrantup.com/). 

## Setup

Note: to use the provided setup, **you must have a 64-bit machine that supports Intel VT-x or AMD-V**.

1. [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your OS and install. This was tested with version 4.3.x.
2. [Download Vagrant](http://www.vagrantup.com/downloads.html) for your OS and install. This was tested with version 1.4.x.
3. Install [Vagrant plugins](http://docs.vagrantup.com/v2/plugins/index.html) by running `install-vagrant-plugins.sh`. 
4. Get this repo from [github](https://github.com/stucco/dev-setup) and any other repos that you need.

        mkdir stucco && cd $_
        git clone https://github.com/stucco/dev-setup.git
      
5. Run `vagrant up` to build the VM. If you have multiple networks interfaces, you may be asked what interface should the network bridge to - pick whichever one you normally use on your host OS. This will take a few minutes as your VM is built.

        cd dev-setup
        vagrant up

6. Run `vagrant ssh` to log into the VM. The stucco project will be in `/stucco` and/or `stucco-shared` (see below).


## Usage

To stop/start the VM, the fastest approach is to use `vagrant suspend` and `vagrant resume`. You can also use `vagrant halt` and `vagrant up`, but this will completely rebuild the VM each time.

To access the VM from the host, use the  host-only IP address defined at the top of the `Vagrantfile`:

    options = {
      :ip => "10.10.10.100"
    }

For example, to connect to riak, do:

    curl -XGET http://10.10.10.100:8098/

Networking is set up as *host-only*, so you will not be able to connect to the VM from another machine. A public network is also set up, but no ports are forwarded on that interface; this allows the VM to connect to the Internet.

Within the created Virtual Machine, you can either run the shared source code from your machine or the [version on github](https://github.com/stucco):

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

### Configured Ports

Services generally use defaults and exposed interfaces bind to the host-only IP.

* RabbitMQ: 5672
* Riak: 8087 (Protobufs), 8098 (HTTP)
* Neo4J: 1337, 7474 (webadmin)
* Logstash: 9200/9300 (elasticsearch), 8000 (kibana web ui), 9562 (log4j input), 9563 (tcp input)


## Testing

Tests are run automatically at the end of the VM building process. All commands run in `test/run-tests.sh` will run. To run all tests you can run this script manually.


## Demonstration

To run the demonstration or test, you should start up vagrant, start up the rt project, and then send data into the RabbitMQ queue.

    vagrant ssh
    cd /stucco/rt
    sbt run
    # send data to queue to process


## Uninstall

To completely remove everything:

    vagrant plugin uninstall vagrant-librarian-chef
    vagrant plugin uninstall vagrant-omnibus
    rm -rf .vagrant cookbooks tmp

Then uninstall Vagrant and VirtualBox.


## Notes

### VPN

The Cisco VPN, and maybe others, may screw up the ability to access the guest from the host OS. Turn off the VPN and maybe restart.

### Librarian-Chef

Vagrant uses [a plugin](https://github.com/jimmycuadra/vagrant-librarian-chef) to interface with [Librarian-Chef](https://github.com/applicationsonline/librarian-chef) to manage the Chef cookbooks, which define how applications are installed on the VM. To get new versions of cookbooks, you will need to delete the `Cheffile.lock` file, which locks in the versions of the cookbooks that are used.
