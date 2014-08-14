# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  
  #Define localhostname
  config.vm.hostname = "localdev"
  
  config.vm.provider "virtualbox" do |v|
    #Define Memory to attribute to VM
    v.memory = 512
	#Define CPU nbr to attribute to VM  
    v.cpus = 1
	# fix for network issues in some OS
	#v.natdnshostresolver1 = "on"
  end
  
  
  # Forward http, https and mysql from host to guest 
  #config.vm.usable_port_range = (10200..10500)
  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network :forwarded_port, guest: 443, host: 443
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  
  #Configure sync folders
  config.vm.synced_folder "./", "/vagrant", disabled: true
  config.vm.synced_folder "provision", "/vagrant/provision/"
  config.vm.synced_folder "d:/vagrant/localdev/approot/calleo/", "/var/www/calleo/"
    #group: 'www-data', owner: 'www-data', mount_options: ["dmode=775", "fmode=764"]
 
 #config.vm.synced_folder "d:/vagrant/localdev/approot/sync/", "/var/www/sync/", 
 #   type: "rsync",
 #   rsync__auto: "true"
    #owner: "www-data",  
    #group: "vagrant", 
    #rsync__exclude: ".svn/"

# config.vm.synced_folder "d:/vagrant/localdev/approot/smb", "/var/www/smb/", 
#    type: "smb"
    #owner: "www-data",  
    #group: "vagrant"
	#:mount_options => ["file_mode=0664,dir_mode=0775"]



  #config.sshfs.paths = { "approot/" => "/vagrant/approot/" }
  
  
  #Provision default needed elements:
  config.vm.provision "shell" do |s|
    s.path = "provision/shell/initial-setup.sh"
    s.args = "/vagrant/provision"
  end 
  
  config.vm.provision :shell, :path => "provision/shell/install-ruby.sh"
  config.vm.provision :shell, :path => "provision/shell/install-puppet.sh"
 
  # Enable the Puppet provisioner
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "provision/puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "provision/puppet/modules"
	puppet.options = [
        '--verbose',
	    '--hiera_config /vagrant/provision/puppet/hiera.yaml',
		'--parser future',			
        #'--debug'
	]
  end
  
  #display a notice at end of provision	
  config.vm.provision :shell, :path => "provision/shell/important-notices.sh"
  
end