include apache::apache

class apache::apache {

  # install apache paackage
  package { 'apache2':
    name => 'apache2',
	ensure => present,
   	before => [
	  File['/etc/apache2/mods-enabled/rewrite.load'],
	  File['/etc/apache2/sites-enabled/vagrant_webroot.conf'],
	  File['/etc/apache2/sites-enabled']
	],
	#	require => Exec['apt-get update']
  }
  
  # ensures that mode_rewrite is loaded and modifies the default configuration file
  file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure => link,
    target => '/etc/apache2/mods-available/rewrite.load',    
  }
    
  # starts the apache2 service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
  service { 'apache2':
    name => 'apache2',
	ensure => running,
	enable => true,
    subscribe =>  File['/etc/apache2/sites-enabled/vagrant_webroot.conf']
  }
}
