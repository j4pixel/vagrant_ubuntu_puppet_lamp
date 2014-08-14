class php::php {

  # Include PPA repo for PHP 5.4 
  exec { 'ondrej-php54-repository':
    unless => 'apt-key list | grep -i ond',
    command => 'sudo apt-add-repository ppa:ondrej/php5-oldstable -y',
    require => Package['python-software-properties'],
    notify => Exec['apt-get update'],
  }

  # package install list
  $packages = [
    'php5',
    'php5-cli',
    'php5-mysql',
    'php-pear',
    'php5-dev',
    'php5-gd',
	'php5-curl',
    'php5-mcrypt',
    'libapache2-mod-php5',
	'php5-sqlite',
	'php5-xdebug',
	'php5-imagick'
  ]

  # install packages defined in package list
  package { $packages:
    ensure => present,
    require => Exec['ondrej-php54-repository'],
    notify => Service['apache2']
  } 
  
  #set php apache and cli configuration 
  php::augeas {
    'php-memorylimit':
      entry => 'PHP/memory_limit',
      value => '512M';
   'php-date_timezone':
      entry => 'Date/date.timezone',
      value => 'Europe/Zurich';
	'post_max_size':
	  entry => 'PHP/post_max_size', 
	  value => '10M';
	'upload_max_filesize':
	  entry => 'PHP/upload_max_filesize',
	  value => '10M';
	'error_reporting':
	  entry => 'PHP/error_reporting', 
	  value => 'E_ALL & ~E_DEPRECATED';
	'display_errors':
	  entry => 'PHP/display_errors', 
	  value => 'On';
	'short_open_tag':
	  entry => 'PHP/short_open_tag', 
	  value => 'On';	
 }

  
  #xdebug config for apache 
  file { 'apache xdebug-conf.ini':
    path => '/etc/php5/apache2/conf.d/40-xdebug.ini',
    ensure => file,
    content => template('php/xdebug-conf.ini'),
    require => Package['php5-cli'],
    notify => Service['apache2'],
  }

 #xdebug config for php cli 
 file { 'phpcli xdebug-conf.ini':
    path => '/etc/php5/cli/conf.d/40-xdebug.ini',
    ensure => file,
    content => template('php/xdebug-conf.ini'),
    require => Package['php5-cli'],
    notify => Service['apache2'],
 }
 

}
