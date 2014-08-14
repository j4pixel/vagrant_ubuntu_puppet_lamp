$appname5 = 'sync'

# make sure app directory is created
file {"/var/www/${appname5}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}


apache::vhost { "${appname5}.local":
  port    => '80',
  docroot => "/var/www/${appname5}/www/",
  docroot_owner => 'www-data',
  docroot_group => 'vagrant',
  directories  => [ 
	{ path           => "/var/www/${appname5}/www/", 
	  allow_override => ['All'], 
	  options => ['Indexes', 'FollowSymLinks'],
	  #directoryindex => ['index.php','index.html'],
	}
  ], 
# require  => File["/var/www/${appname5}/www"],
}

apache::vhost { "${appname5}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/var/www/${appname5}/www/",
  docroot_owner => 'www-data',
  docroot_group => 'vagrant',
  directories  => [ 
	{ path           => "/var/www/${appname5}/www/", 
	  allow_override => ['All'], 
	  options => ['Indexes', 'FollowSymLinks'],
	  #directoryindex => ['index.php','index.html'],
	}
  ], 
  require  => File["/var/www/${appname5}/www"],
}

mysql_database { $appname5:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
}

