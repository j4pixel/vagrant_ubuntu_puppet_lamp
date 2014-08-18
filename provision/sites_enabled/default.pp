$appname4 = 'default'

# make sure app directory is created
file {"/var/www/${appname4}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}


apache::vhost { "${appname4}.local":
  port    => '80',
  docroot => "/var/www/${appname4}/www/",
  directories  => [ 
	{ path           => "/var/www/${appname4}/www/", 
	  allow_override => ['All'], 
	}, 
  ], 
}

apache::vhost { "${appname4}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/var/www/${appname4}/www/",
  directories  => [ 
	{ path           => "/var/www/${appname4}/www/", 
	  allow_override => ['All'], 
	}, 
  ], 
  require  => File["/var/www/${appname4}/www"],
}

mysql_database { $appname4:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
  require =>  Class['mysql::server']
}

