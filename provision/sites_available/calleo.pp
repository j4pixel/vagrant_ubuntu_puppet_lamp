$appname = 'calleo'

# make sure app directory is created
file {"/var/www/${appname}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}

#vcsrepo { "/var/www/${appname}/":
#        ensure   => present,
#        provider => svn,
#        source   => "https://usvn.atomik.virtua.ch/svn/calleov3/trunk/",
#		require  => File["/var/www/${appname}"],
#}


apache::vhost { "${appname}.local":
  port    => '80',
  docroot => "/var/www/${appname}/www/",
  directories  => [ 
	{ path           => "/var/www/${appname}/www/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html '],
	}, 
  ], 
#  require  => Vcsrepo["/var/www/${appname}/"]
}

apache::vhost { "${appname}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/var/www/${appname}/www/",
  directories  => [ 
	{ path           => "/var/www/${appname}/www/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html '],
	}, 
  ], 
  require  => File["/var/www/${appname}/www"],
}

mysql_database { $appname:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
  require =>  Class['mysql::server']
}

