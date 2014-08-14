$appname3 = 'calleovar'

# make sure app directory is created
file {"/var/www/${appname3}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}


apache::vhost { "${appname3}.local":
  port    => '80',
  docroot => "/var/www/${appname3}/www/",
  directories  => [ 
	{ path           => "/var/www/${appname3}/www/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html '],
	}, 
  ], 
}

apache::vhost { "${appname3}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/var/www/${appname3}/www/",
  directories  => [ 
	{ path           => "/var/www/${appname3}/www/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html '],
	}, 
  ], 
  require  => File["/var/www/${appname3}/www"],
}

mysql_database { $appname3:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
}

