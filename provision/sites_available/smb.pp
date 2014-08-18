$appname6 = 'smb'

# make sure app directory is created
file {"/var/www/${appname6}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}


apache::vhost { "${appname6}.local":
  port    => '80',
  docroot => "/var/www/${appname6}/www/",
  docroot_owner => 'www-data',
  docroot_group => 'vagrant',
  directories  => [ 
	{ path           => "/var/www/${appname6}/www/", 
	  allow_override => ['All'], 
	}
  ], 
# require  => File["/var/www/${appname6}/www"],
}

apache::vhost { "${appname6}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/var/www/${appname6}/www/",
  docroot_owner => 'www-data',
  docroot_group => 'vagrant',
  directories  => [ 
	{ path           => "/var/www/${appname6}/www/", 
	  allow_override => ['All'], 
	}
  ], 
  require  => File["/var/www/${appname6}/www"],
}

mysql_database { $appname6:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
  require =>  Class['mysql::server']
}

