# Instructions for setting up Stucco development environment

## Set up Eclipse

1. Install Eclipse: Download [Eclipse IDE for Java EE Developers](eclipse.org/downloads/). Then open Eclipse and set up the default workspace somewhere on your drive.
2. Install e-git plugin: Help menu -> Eclipse Marketplace -> search for 'git' -> Install `EGit - Git Team Provider`

## Set up SBT (Simple Build Tool)

To be able to compile the project, run unit tests, and deploy jar files, you will need to download [SBT](http://www.scala-sbt.org/release/docs/Getting-Started/Setup.html). Be sure to get version 0.12.3.

## Get the project

The base project is available here: [storm-base](https://github.com/anishathalye/storm-base). An up-to-date project may be available in the stucco repository - if so, clone that instead.

Note that the project is a mixed source project. Any portion may be written in Java or Scala. Scala code can call Java code, and vice versa. Unit tests may be written in ScalaTest (which is preferred) or JUnit.

## Test the project

SBT makes it easy to compile, run, and deploy. Example usage is provided below. More information is available at the [SBT getting started guide](http://www.scala-sbt.org/release/docs/Getting-Started/Welcome.html).

    sbt compile     # compiles the project
    sbt test        # runs unit tests
    sbt assembly    # packages project into .jar file (for Storm CLI client)

## Set up Git Repo

If you used `git clone` to get the most up-to-date version of the project, no additional set up should be necessary.

## Set up Storm

To be able to push code out to a storm cluster, you will need to download the storm project:

    cd /usr/local
    sudo curl -LO https://dl.dropbox.com/u/133901206/storm-0.8.2.zip
    sudo unzip -o storm-0.8.2.zip
    sudo ln -s ../storm-0.8.2/bin/storm bin/storm
    sudo rm -f storm-0.8.2.zip

## Set up Vagrant

This project will set up the test and demonstration environment for Stucco using Vagrant. Your directory structure should look something like this:

    - stucco
      |-- dev-setup
      |-- other-stucco-project-1
      |-- other-stucco-project-2

First, [download VirtualBox](https://www.virtualbox.org/wiki/Downloads) and install. This was tested with version 4.2.12, but any 4.2.x version should work.

[Download a Vagrant installer](http://downloads.vagrantup.com/) for Mac OS, Windows, and Linux and install it. This was tested with version 1.2.2, but any 1.x version should work.

To build the VM, run `init.sh`. This script installs the [Vagrant Plugins](http://docs.vagrantup.com/v2/plugins/index.html) and runs `vagrant up` to build the VM.

To log into the VM, run `vagrant ssh`. The parent directory from this project (where you ran the `init.sh` script) will be mounted under /stucco within the VM.

## Deploy to Storm

**needs to be documented**
