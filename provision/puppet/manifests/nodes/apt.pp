if $apt_values == undef { $apt_values = hiera('packages', false) }

class { 'apt': }

::apt::key { '4F4EA0AAE5267A6C': 
   key_server => 'hkp://keyserver.ubuntu.com:80' 
 }

::apt::ppa { $apt_values['php_ppa']['name']:
    options => '-y',
    require => ::Apt::Key['4F4EA0AAE5267A6C'],
}

if count($apt_values['modules']) > 0 {
    package_list { $apt_values['modules']:; }
}
  
define package_list {
  if ! defined(Package[$name]) {
    package { $name:
	ensure => present,
    require => ::Apt::Ppa[$apt_values['php_ppa']['name']],
    }
  }
}

