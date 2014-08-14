$appname2 = 'virtua-laravel-framework'

apache::vhost { "${appname2}.local":
  port    => '80',
  docroot => "/vagrant/approot/${appname2}/public/",
  directories  => [ 
	{ path           => "/vagrant/approot/${appname2}/public/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html ']
	}, 
  ], 
}

apache::vhost { "${appname2}-ssl.local":
  port    => '443',
  ssl     => true,
  docroot => "/vagrant/approot/${appname2}/public/",
  directories  => [ 
	{ path           => "/vagrant/approot/${v}/public/", 
	  allow_override => ['All'], 
	  #WARNING: Space needed at the end of each directory indexes
	  directoryindex => ['index.php ','index.html ']
	}, 
  ], 
}
	
# make sure app directory is created
file {"/vagrant/approot/${appname2}":
  ensure => directory,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
}

# make sure workbench directory is created
file {"/vagrant/approot/${appname2}/workbench/":
  ensure => directory,
  recurse => true,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
  require => File ["/vagrant/approot/${appname2}"]
}

# make sure workbench directory is created
file {"/vagrant/approot/${appname2}/workbench/virtua":
  ensure => directory,
  recurse => true,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
  require => File ["/vagrant/approot/${appname2}/workbench"]
}

# make sure app directory is created
file {"/vagrant/approot/${appname2}/workbench/virtua/framework":
  ensure => directory,
  recurse => true,
  force => true,
  owner => 'www-data',
  group => 'vagrant',
  require => File ["/vagrant/approot/${appname2}/workbench/virtua"]
}

mysql_database { $appname2:
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_unicode_ci',
  require =>  Class['mysql::server']
}

#vcsrepo { "/vagrant/approot/${appname2}/workbench/virtua/framework":
#        ensure   => present,
#        provider => svn,
#        source   => "https://usvn.atomik.virtua.ch/svn/virtua-package-framework/branches/refactoring",
#		require  => File["/vagrant/approot/${appname2}/workbench/virtua/framework"],
#}


