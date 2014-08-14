if $xdebug_values == undef { $xdebug_values = hiera('xdebug', false) }
if $php_values == undef { $php_values = hiera('php', false) }
if $apache_values == undef { $apache_values = hiera('apache', false) }

$php_config_file_ubuntu_xdebug = '/etc/php5/apache2/php.ini'

if hash_key_equals($apache_values, 'install', 1) {
  $php_webserver_service_xdebug = 'apache2'
} else {
  $php_webserver_service_xdebug = []
}

if hash_key_equals($xdebug_values, 'install', 1)
  and hash_key_equals($php_values, 'install', 1)
{
  //TODO # php 5.6 requires xdebug be compiled, for now
  $xdebug_compile = $php_values['version'] ? {
    '5.6'   => true,
    '56'    => true,
    default => false,
  }


  
  if ! defined(Package['php5-xdebug']) {
    package { 'xdebug':
      name    => 'php5-xdebug',
      ensure  => installed,
      require => Package['php'],
      notify  => Service[$php_webserver_service_xdebug],
    }
	
	# shortcut for xdebug CLI debugging
    if defined(File['/usr/bin/xdebug']) == false {
    file { '/usr/bin/xdebug':
      ensure  => present,
      mode    => '+X',
      source  => 'puppet:///modules/puphpet/xdebug_cli_alias.erb',
      require => Package['php']
      }
    }
  
    if is_hash($xdebug_values['settings']) and count($xdebug_values['settings']) > 0 {
      each( $xdebug_values['settings'] ) |$key, $value| {
        set_ini_xdebug { $key:
          entry       => "XDEBUG/${key}",
          value       => $value,
        }
      }
    }
  }
}

define set_ini_xdebug (  
  $entry,
  $value  = '',
  $target = $php_config_file_ubuntu_xdebug
  ){
  php::augeas{ "${entry}-${value}-${target}" :
    entry   => $entry,
    value   => $value,    
	target  => $target,
    notify  => Service[$php_webserver_service_xdebug],	
	require =>  Class['Php']	
  }
}



