# Setup for development and test environment


## Vagrant

This project will set up the test and demonstration environment for Stucco using Vagrant. 

It is expected that you will have a directory structure where all of the repositories are in a common folder, so it looks like this:

    - `stucco`
      - `dev-setup`
      - `collectors`
      - `rt`
      - other required repos...

Note: to use the provided setup, **you must have a 64-bit machine that supports Intel VT-x or AMD-V**.

1. [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) and install. This was tested with version 4.2.x.
2. [Download a Vagrant installer](http://downloads.vagrantup.com/) for Mac OS, Windows, and Linux and install it. This was tested with version 1.2.x.
3. Install [Vagrant plugins](http://docs.vagrantup.com/v2/plugins/index.html) by running `init.sh`. 
4. Get this repo from [github](https://github.com/stucco/dev-setup) and run `vagrant up` to build the VM. If you have multiple networks interfaces, you may be asked what interface should the network bridge to - pick whichever one you normally use on your host OS:

    mkdir stucco && cd stucco
    git clone https://github.com/stucco/dev-setup.git
    cd dev-setup
    vagrant up

5. Run `vagrant ssh` to log into the VM. The stucco project will be in `/usr/local/stucco`.

To stop/start the VM, the fastest approach is to use `vagrant suspend` and `vagrant resume`. You can also use `vagrant halt` and `vagrant up`, but this will completely rebuild the VM each time.

To access the VM from the host, use the  host-only IP address defined at the top of the `Vagrantfile`:

    options = {
      :ip => "10.10.10.100"
    }

For example, to connect to riak, do:

    curl -XGET http://10.10.10.100:8098/

Networking is set up as *host-only*, so you will not be able to connect to the VM from another machine. A public network is also set up, but no ports are forwarded on that interface.

### Configured Ports

Services generally use defaults and exposed interfaces bind to the host-only IP.

* RabbitMQ: 5672
* Riak: 8087 (Protobufs), 8098 (HTTP)
* Neo4J: 1337, 7474 (webadmin)
* Logstash: 9200/9300 (elasticsearch), 8088 (kibana web ui), 9562 (log4j input), 9563 (tcp input)


## Testing

Log into the vagrant box and run the unit tests. For example, to test the storm [rt](https://github.com/stucco/rt) project:

    vagrant ssh
    cd /stucco/rt
    sbt test


## Demonstration

To run the demonstration or test, you should start up vagrant, start up the rt project, and then send data into the RabbitMQ queue.

    vagrant ssh
    cd /usr/local/stucco/rt
    sbt run
    # send data to queue to process


## Deploy to Storm Cluster

To run a project locally within the VM, you can just use SBT: `sbt run`.

To package a project into a jar file for deployment to a cluster, you can run `sbt assembly` and submit the jar file using `storm jar /path/to/archive.jar class.of.Topology [args...]`.

More information about submitting to a storm cluster can be found in the [storm command line client documentation](https://github.com/nathanmarz/storm/wiki/Command-line-client).


## Development Environment

### Set up Eclipse/Git

1. Install Eclipse: Download [Eclipse IDE for Java EE Developers](eclipse.org/downloads/). Then open Eclipse and set up the default workspace somewhere on your drive.
2. Install e-git plugin: Help menu -> Eclipse Marketplace -> search for 'git' -> Install `EGit - Git Team Provider`

### Set up SBT (Simple Build Tool)

To be able to compile the project, run unit tests, and deploy jar files, you will need to download [SBT](http://www.scala-sbt.org/release/docs/Getting-Started/Setup.html). Be sure to get version >= 0.12.3.

### Get the project

The stucco-rt project is available here: [stucco-rt](https://github.com/stucco/rt)

Use `git clone` and `git pull` to get the most up-to-date versions of the projects.

Note that the project is a mixed source project. Any portion may be written in Java or Scala. Scala code can call Java code, and vice versa. Unit tests may be written in ScalaTest (which is preferred) or JUnit.

### Test the project

SBT makes it easy to compile, run, and deploy. Example usage is provided below. More information is available at the [SBT getting started guide](http://www.scala-sbt.org/release/docs/Getting-Started/Welcome.html).

    sbt compile     # compiles the project
    sbt test        # runs unit tests
    sbt assembly    # packages project into .jar file (for Storm CLI client)

### SBT Plugins (Optional)

There are some SBT plugins that are quite useful. You can find more online, but here are some that we recommend you install:

* [Scalastyle](http://www.scalastyle.org/sbt.html)
* [Scalariform](https://github.com/sbt/sbt-scalariform)

### SBT Configuration

You can configure global SBT settings and plugins in your `~/.sbt` directory. The `~/.sbt/build.sbt` is included in all projects, and the `~/.sbt/plugins/plugins.sbt` are loaded for all projects. See the following examples for more details:

* [build.sbt](https://gist.github.com/anishathalye/6140974)
* [plugins.sbt](https://gist.github.com/anishathalye/6140962)

### Set up Storm

To be able to push code out to a storm cluster from your host OS, you will need to download the storm project:

    cd /usr/local
    sudo curl -LO https://dl.dropbox.com/u/133901206/storm-0.8.2.zip
    sudo unzip -o storm-0.8.2.zip
    sudo ln -s ../storm-0.8.2/bin/storm bin/storm
    sudo rm -f storm-0.8.2.zip


## Notes

### VPN

The Cisco VPN, and maybe others, may screw up the ability to access the guest from the host OS. Turn off the VPN and maybe restart.

### Berkshelf

Vagrant uses [Berkshelf](http://berkshelf.com/) to manage the Chef cookbooks, which define how applications are installed on the VM. To get new versions of cookbooks, you will need to delete the `Berksfile.lock` file, which locks in the versions of the cookbooks that are used.

### sbt on a Mac

If `sbt` throws an error like `Error during sbt execution: java.lang.OutOfMemoryError: PermGen space`, you can create a `~/.sbtconfig` file with the following contents:

    SBT_OPTS="-XX:MaxPermSize=512M"%                                              

This is only tested on the `brew` version of sbt on Mac OS.