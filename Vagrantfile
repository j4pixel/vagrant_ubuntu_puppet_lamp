# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = " http://files.vagrantup.com/precise32.box"
  
  config.vm.hostname = "localdev"
  config.vm.memory = "512"
  config.vm.cpus = "1"
  config.vm.natdnshostresolver1 = "on"
  
  # Enable the Puppet provisioner, with will look in manifests
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "provision/puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "provision/puppet/modules"
  end
  
  # Forward guest port 80 to host port 8888 and name mapping
  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network :forwarded_port, guest: 443, host: 443
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  
  config.vm.synced_folder "./", "/vagrant", disabled: true
  config.vm.synced_folder "provision", "/vagrant/provision/"
  #config.vm.synced_folder "approot/", "/vagrant/approot/", group: 'www-data', owner: 'www-data', mount_options: ["dmode=775", "fmode=764"]
  #config.vm.synced_folder "d:/vagrant/localdev/approot/", "/vagrant/approot/", type: "rsync", rsync__exclude: ".svn/"
  #config.sshfs.paths = { "approot/" => "/vagrant/approot/" }
  
end
