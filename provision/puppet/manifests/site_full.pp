# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

# silence puppet and vagrant annoyance about the puppet group
group { 'puppet':
    ensure => 'present'
}


include apt::apt
include bootstrap::bootstrap
include tools::tools

#include php::php
#include php::pear
#include php::pecl
#include composer::composer


#Define MYsql package and user accssible from external host 
class { '::mysql::server':
  #old_root_password => 'd3v0p5',
  root_password    => 'd3v0p5',
  override_options => { 'mysqld' => { 'bind-address' => '0.0.0.0' } },
  users => { 
    'root@%' => {
      ensure        => present,
      password_hash => mysql_password('d3v0p5'),
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

#Install mysql libraries for php
#class { '::mysql::bindings':
#	php_enable => true
#}
 



#class {'::mysql::client':}





### Apache Configuration ###
class {'apache':
		 mpm_module => 'prefork',
		 default_vhost => false
}
include apache::mod::rewrite
include apache::mod::ssl
include apache::mod::php


#Import project specific needs
import '/vagrant/provision/sites_enabled/*.pp'


