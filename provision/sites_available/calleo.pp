$appname = 'calleo'

# make sure app directory is created
file {"/vagrant/approot/${appname}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}

#vcsrepo { "/vagrant/approot/${appname}/":
#        ensure   => present,
#        provider => svn,
#        source   => "https://usvn.atomik.virtua.ch/svn/calleov3/trunk/",
#		require  => File["/vagrant/approot/${appname}"],
#}


apache::vhost { "${appname}.local":
  port    => '80',
  docroot => "/vagrant/approot/${appname}/www/",
  directories  => [ 
	{ path           => "/vagrant/approot/${appname}/www/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html '],
	}, 
  ], 
#  require  => Vcsrepo["/vagrant/approot/${appname}/"]
}

apache::vhost { "${appname}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/vagrant/approot/${appname}/www/",
  directories  => [ 
	{ path           => "/vagrant/approot/${appname}/www/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html '],
	}, 
  ], 
  require  => File["/vagrant/approot/${appname}/www"],
}

mysql_database { $appname:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
  require =>  Class['mysql::server']
}

