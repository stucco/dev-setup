# -*- mode: ruby -*-
# vi: set ft=ruby :

options = {
  :ip => "10.10.10.100"
}

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

  # Forward the default Riak ports to enable access from host OS
  #config.vm.network :forwarded_port, guest: 8087, host: 8087  # Protocol Buffers
  config.vm.network :forwarded_port, guest: 8098, host: 8098  # HTTP

  # Forward the default Neo4j ports to enable access from host OS
  config.vm.network :forwarded_port, guest: 1337, host: 1337
  config.vm.network :forwarded_port, guest: 7474, host: 7474

  # Forward the default Logstash ports to enable access from host OS
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 9292, host: 9292
  config.vm.network :forwarded_port, guest: 9300, host: 9300

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "#{options[:ip]}"

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

  # Recommended for riak
  config.vm.provision :shell, :inline => "ulimit -n 8192"

  # Turn on NTP
  config.vm.provision :shell, :inline => "echo \"echo 'America/New_York' > /etc/timezone; ntpdate us.pool.ntp.org ; apt-get install ntp -y && echo 'server us.pool.ntp.org' > /etc/ntp.conf \" | sudo sh"

  # Install required packages
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      # use Oracle Java JDK instead of default OpenJDK
      "java" => {
        "install_flavor" => 'oracle',
        "jdk_version" => 7,
        "oracle" => {
          "accept_oracle_download_terms" => true
        }
      },
      # set up riak to use the configured IP address
      "riak" => {
        "args" => {
          "-name" => "riak@#{options[:ip]}"
        },
        "config" => {
          "riak_core" => {
            "http" => {
              "__string_#{options[:ip]}" => 8098
            }
          },
          "riak_api" => {
            "pb_ip" => "__string_#{options[:ip]}"
          }
        }
      }
    }

    chef.add_recipe "git"
    chef.add_recipe "python"
    chef.add_recipe "java"
    chef.add_recipe "zookeeper"
    chef.add_recipe "rabbitmq"
    chef.add_recipe "riak"
  end

  # Install [SBT](www.scala-sbt.org) 0.12.3
  config.vm.provision :shell, :inline => "sudo apt-get -f -q -y install default-jdk && cd /usr/local/bin && sudo curl --silent -LO http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch//0.12.3/sbt-launch.jar && echo 'java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M -jar `dirname $0`/sbt-launch.jar \"$@\"' | sudo tee sbt > /dev/null && sudo chmod +x sbt"

  # Install [Logstash](http://logstash.net)
  config.vm.provision :shell, :inline => <<-eos
  if [ ! -d /opt/logstash ]; then sudo adduser --system --home /opt/logstash --ingroup adm --disabled-password logstash; fi
  cd /opt/logstash
  sudo curl --silent -LO https://logstash.objects.dreamhost.com/release/logstash-1.1.13-flatjar.jar
  cd /etc/init
  sudo curl --silent -LO https://github.com/stucco/dev-setup/raw/master/logstash-indexer.conf
  cd /etc/
  sudo curl --silent -LO https://github.com/stucco/rt/raw/master/logstash.conf
  sudo initctl reload-configuration
  sudo initctl start logstash-indexer
  eos


  # Install [Storm](http://storm-project.net/) 0.8.2
  config.vm.provision :shell, :inline => "if [ ! -f /usr/local/bin/storm ]; then cd /usr/local && curl --silent -LO https://dl.dropbox.com/u/133901206/storm-0.8.2.zip && unzip -o storm-0.8.2.zip && sudo ln -s ../storm-0.8.2/bin/storm bin/storm && sudo rm -f storm-0.8.2.zip && echo 'Storm has been installed.'; fi"

  # Install [Neo4j](http://www.neo4j.org/download/linux) using debian package
  config.vm.provision :shell, :inline => "echo \"wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && apt-get update -y && apt-get install neo4j -y\" | sudo sh"

end
