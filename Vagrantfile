# -*- mode: ruby -*-
# vi: set ft=ruby :

options = {
  :ip => "10.10.10.100",
  :hostname => "stucco",
  # By default the VM will be allocated 10gb of memory
  :memory => "10240",
  # By default the VM will be allocated 4 cores
  :cores => "4"
}

Vagrant.configure("2") do |config|

  # Allow command line override of the IP address using the env VM_IP
  # example usage: VM_IP="172.17.18.12" vagrant up
  if ENV["VM_IP"]
    options[:ip] = ENV["VM_IP"]
  end

  # Allow command line override of the hostname VM_HOSTNAME
  # example usage: VM_HOSTNAME="stucco-1" vagrant up
  if ENV["VM_HOSTNAME"]
    options[:hostname] = ENV["VM_HOSTNAME"]
  end

  config.vm.hostname = options[:hostname]

  # If you are on a Host without Virtualization in the BIOS, try changing to "hashicorp/precise32"
  config.vm.box = "hashicorp/precise64"
  config.vm.box_version = "1.1.0"
  config.vm.box_check_update = false
  
  # Config for vagrant-cachier - caches apt packages (and similar on other systems)
  # See http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on the "Usage" link above
    config.cache.scope = :box

    #using generic cache bucket for maven
    config.cache.enable :generic, {
      "maven-user" => { cache_dir: "/home/vagrant/.m2/repository"},
      "maven-root" => { cache_dir: "/root/.m2/repository"},
      "wget" => { cache_dir: "/var/cache/wget"},
    }
  end

  config.vm.network :private_network, ip: "#{options[:ip]}"

  # Mount the parent directory under /stucco-shared in the VM
  # All project repos should be in the parent dir
  config.vm.synced_folder "../", "/stucco-shared"

  # Customization for VirtualBox
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "#{options[:memory]}"]
    vb.customize ["modifyvm", :id, "--cpus", "#{options[:cores]}"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
  end

  # Customization for VMWare Fusion
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "#{options[:memory]}"
    v.vmx["numvcpus"] = "#{options[:cores]}"
  end

  # Create ansible inventory file
  File.open('provisioning/inventory' ,'w') do |f|
    f.write "[default]\n"
    f.write "stucco ansible_ssh_host=#{options[:ip]}\n"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.inventory_path = "provisioning/inventory"
    ansible.playbook = "provisioning/site.yml"
    ansible.extra_vars = { ansible_ssh_user: "vagrant", host_ip: "#{options[:ip]}" }
  end

end
