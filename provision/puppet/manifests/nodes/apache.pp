if $apache_values == undef { $apache_values = hiera('apache', false) }
if $php_values == undef { $php_values = hiera('php', false) }

if hash_key_equals($apache_values, 'install', 1) {
  include apache::params  
  $disallowed_modules   = []
  
  #$sendfile = $apache_values['settings']['sendfile'] ? {
  #  1       => 'On',
  #  default => 'Off'
  #}

  $apache_settings = merge($apache_values['settings'], {
    'default_vhost'  => false,
    'mpm_module'     => 'prefork',
    'conf_template'  => $apache::params::conf_template,
    'sendfile'       => $sendfile,
    'apache_version' => $apache::version::default,
	'user'           => 'vagrant',
	'group'          => 'vagrant'
  })

  create_resources('class', { 'apache' => $apache_settings })

  if hash_key_equals($php_values, 'install', 1) and ! defined(Class['apache::mod::php']) {
    include apache::mod::php
  } 

  #$apache_vhosts = $apache_values['vhosts']
  
  
  if count($apache_values['modules']) > 0 {
    apache_mod { $apache_values['modules']: 
	  notify  => Service['apache2']
	 }
  }
  
}
  
define apache_mod {
  if ! defined(Class["apache::mod::${name}"]) and !($name in $disallowed_modules) {
    class { "apache::mod::${name}": }
  }
}