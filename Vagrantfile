# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use [berkshelf](http://berkshelf.com/)
  config.berkshelf.enabled = true

  # VM name
  config.vm.hostname = "stucco"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise-server-cloudimg-amd64-vagrant-disk1"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # Ubuntu cloud images, including virtual box images for vagrant, can
  # be found here: http://cloud-images.ubuntu.com/
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/20130523/precise-server-cloudimg-amd64-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.

  # Forward the default RabbitMQ port to enable access from host OS
  config.vm.network :forwarded_port, guest: 5672, host: 5672

  # Forward the default Redis port to enable access from host OS
  config.vm.network :forwarded_port, guest: 6379, host: 6379

  # Forward the default Riak ports to enable access from host OS
  config.vm.network :forwarded_port, guest: 8087, host: 8087  # Protocol Buffers
  config.vm.network :forwarded_port, guest: 8098, host: 8098  # HTTP

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

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  
  # Use VBoxManage to customize the VM. Change memory and limit VM's CPU.
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
  

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Update package list, but do not do upgrade. Upgrades should
  # be done manually, if required (`sudo apt-get upgrade`)
  config.vm.provision :shell, :inline => "sudo apt-get update"

  # Install latest [chef](http://www.opscode.com/chef/)
  config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | sudo bash"

  # Install required packages
  config.vm.provision :chef_solo do |chef|
    # use Oracle Java JDK instead of default OpenJDK
    chef.json = {
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

  # Install [Storm](http://storm-project.net/) 0.8.2
  config.vm.provision :shell, :inline => "cd /usr/local && curl -LO https://dl.dropbox.com/u/133901206/storm-0.8.2.zip && unzip -qo storm-0.8.2.zip && sudo ln -s ../storm-0.8.2/bin/storm bin/storm && sudo rm -f storm-0.8.2.zip"

end
