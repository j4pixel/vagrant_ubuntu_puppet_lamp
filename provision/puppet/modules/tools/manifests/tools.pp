class tools::tools {

  
  # install python (excluded from rest for php 5.4 to install correctly 
  package { 'python-software-properties':
    ensure => present,
	notify => Exec['apt-get update']
  }
  
  # package install list
  $packages = [
    'curl',
    'vim',
    'htop',
	'python',
	'g++',
	'make',
	'git',
	'subversion',
	'augeas-tools',
	'libaugeas-dev',
	'libaugeas-ruby',
	'puppet',
	'phpunit',
  ]
  
  # install packages
  package { $packages:
    ensure => present,
    require => Exec['apt-get update']
  }
  
  # Set localtime to Europe Zuerich 
  file {'/etc/localtime':
    ensure => link,
	target => '/usr/share/zoneinfo/Europe/Zurich',
    mode   => 0640,
	owner  => 'root',
	group  => 'root'
  }
  
  #Apply Augeas FIX 
  #-  confine :true => Puppet.features.augeas?
  # +  confine :feature => :augeas    
  exec { 'fix augeas': 
	command => "sudo sed -i 's/^;*[[:space:]]*confine :true[[:space:]]*=>.*$/  confine :feature => :augeas/g' /opt/vagrant_ruby/lib/ruby/gems/1.8/gems/puppet-2.7.19/lib/puppet/provider/augeas/augeas.rb",
	unless  => "grep -xqe '  confine :feature[[:space:]]*=>[[:space:]]*:augeas' -- /opt/vagrant_ruby/lib/ruby/gems/1.8/gems/puppet-2.7.19/lib/puppet/provider/augeas/augeas.rb",
    require => [
	  Package['libaugeas-dev'],
	  Package['augeas-tools'],
	  Package['puppet']
	]    
  }
  
}
