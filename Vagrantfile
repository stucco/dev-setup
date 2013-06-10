# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use [berkshelf plugin](https://github.com/RiotGames/vagrant-berkshelf) 
  # to use [berkshelf](http://berkshelf.com/) to manage cookbooks
  # To install plugin: `vagrant plugin install vagrant-berkshelf`
  config.berkshelf.enabled = true

  # Use [omnibus plugin](https://github.com/schisamo/vagrant-omnibus) 
  # to use the omnibus installer to install [chef](http://www.opscode.com/chef/)
  # Install plugin: `vagrant plugin install vagrant-omnibus`
  config.omnibus.chef_version = "11.4.4"

  # VM name
  config.vm.hostname = "stucco"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise-server-cloudimg-amd64-vagrant-disk1"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # Ubuntu cloud images, including virtual box images for vagrant, can
  # be found here: http://cloud-images.ubuntu.com/
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.

  # Forward the default RabbitMQ port to enable access from host OS
  config.vm.network :forwarded_port, guest: 5672, host: 5672

  # Forward the default Redis port to enable access from host OS
  config.vm.network :forwarded_port, guest: 6379, host: 6379

  # Forward the default Riak ports to enable access from host OS
  config.vm.network :forwarded_port, guest: 8087, host: 8087  # Protocol Buffers
  config.vm.network :forwarded_port, guest: 8098, host: 8098  # HTTP

  # Forward the default Neo4j ports to enable access from host OS
  config.vm.network :forwarded_port, guest: 1337, host: 1337
  config.vm.network :forwarded_port, guest: 7474, host: 7474

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Mount the parent directory under /stucco in the VM
  config.vm.synced_folder "../", "/stucco"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  
  # Use VBoxManage to customize the VM. Change memory and limit VM's CPU.
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
  

  # Update package list, but do not do upgrade. Upgrades should
  # be done manually, if required (`sudo apt-get upgrade`)
  config.vm.provision :shell, :inline => "sudo apt-get update"

  # Install required packages
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      # use Oracle Java JDK instead of default OpenJDK
      "java" => {
        "install_flavor" => 'oracle',
        "jdk_version" => 6,
        "oracle" => {
          "accept_oracle_download_terms" => true
        }
      }
    }

    chef.add_recipe "git"
    chef.add_recipe "python"
    chef.add_recipe "java"
    chef.add_recipe "zookeeper"
    chef.add_recipe "riak"
    chef.add_recipe "redisio"
    chef.add_recipe "rabbitmq"
  end

  # Install [SBT](www.scala-sbt.org) 0.12.3
  config.vm.provision :shell, :inline => "curl --silent -LO http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.3/sbt.deb && dpkg -i sbt.deb; apt-get -f -q -y install && rm -f sbt.deb && echo 'SBT has been installed.'"

  # Install Maven manually since chef recipe is not working
  # config.vm.provision :shell, :inline => "sudo apt-get install maven -y && echo 'Maven has been installed.'"

  # Install [Storm](http://storm-project.net/) 0.8.2
  config.vm.provision :shell, :inline => "cd /usr/local && curl --silent -LO https://dl.dropbox.com/u/133901206/storm-0.8.2.zip && unzip -o storm-0.8.2.zip && sudo ln -s ../storm-0.8.2/bin/storm bin/storm && sudo rm -f storm-0.8.2.zip && echo 'Storm has been installed.'"

  # Install [Neo4j](http://www.neo4j.org/download/linux) using debian package
  config.vm.provision :shell, :inline => "echo \"wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && apt-get update -y && apt-get install neo4j -y\" | sudo sh"

  # Turn on NTP
  config.vm.provision :shell, :inline => "echo \"ntpdate time.ornl.gov ; apt-get install ntp -y && echo 'server time.ornl.gov' > /etc/ntp.conf \" | sudo sh"

end
