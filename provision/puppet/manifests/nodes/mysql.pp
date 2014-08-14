if $mysql_values == undef { $mysql_values = hiera('mysql', false) }
if $php_values == undef { $php_values = hiera('php', false) }

if hash_key_equals($mysql_values, 'install', 1) {
  include mysql::params

  $mysql_server_require             = []
  $mysql_server_server_package_name = $mysql::params::server_package_name
  $mysql_server_client_package_name = $mysql::params::client_package_name

  #Define Mysql package and user accssible from external host 
  class { 'mysql::server':
    package_name  => $mysql_server_server_package_name,
    root_password => $mysql_values['root_password'],
    require       => $mysql_server_require,
    override_options => { 'mysqld' => { 'bind-address' => '0.0.0.0' } },
    users => { 
	  'root@%' => {
	  ensure        => present,
	  password_hash => mysql_password($mysql_values['root_password']),
     }
    },
    grants => { 
      "root@'%'/*.*" => {
  	  ensure     => 'present',
	  options    => ['GRANT'],
	  privileges => ['ALL'],
	  table      => '*.*',
	  user       => "root@%",
	  }
    },
  }
	
  class { 'mysql::client':
	package_name => $mysql_server_client_package_name,
	require      => $mysql_server_require
  }

  if hash_key_equals($php_values, 'install', 1) {	  
	if ! defined(Php::Module['mysql']) {
	  php::module { 'mysql':
	  service_autorestart => true,
	  }
	}
  }

}

