if $php_values == undef { $php_values = hiera('php', false) }
if $apache_values == undef { $apache_values = hiera('apache', false) }
if $apt_values == undef { $apt_values = hiera('packages', false) }
if $mailcatcher_values == undef { $mailcatcher_values = hiera('mailcatcher', false) }


$xdebug_package = 'php5-xdebug'
$xhprof_package = false #or php5-xhprof ?
$apache_webroot_location = '/var/www'

$ssl_cert_location = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
$ssl_key_location = '/etc/ssl/private/ssl-cert-snakeoil.key'

$php_config_file_ubuntu = '/etc/php5/apache2/php.ini'
$php_config_file_cli_ubuntu = '/etc/php5/cli/php.ini'

if hash_key_equals($php_values, 'install', 1) {
  include php::params
  include apache::params

Class["Apt::Ppa[${apt_values['php_ppa']['name']}]"]
  -> Class['Php']
  -> Class['Php::Devel']
  -> Php::Module <| |>
  -> Php::Pear::Module <| |>
  -> Php::Pecl::Module <| |>

  if hash_key_equals($apache_values, 'install', 1)
  {
    $php_package                  = $php::params::package
    $php_webserver_service        = 'apache2'
    $php_webserver_service_ini    = $php_webserver_service
    $php_webserver_service_ensure = 'running'
    $php_webserver_restart        = true
    
  
 
    class { 'php':
      package             => $php_package,
      service             => $php_webserver_service,
      service_autorestart => false,
      config_file         => $php_config_file_ubuntu,
    }

    if ! defined(Service[$php_webserver_service]) {
      service { $php_webserver_service:
        ensure     => $php_webserver_service_ensure,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package[$php_webserver_service]
      }
    }

    class { 'php::devel': }

    if count($php_values['modules']['php']) > 0 {
      php_mod { $php_values['modules']['php']:; }
    }
    if count($php_values['modules']['pear']) > 0 {
      php_pear_mod { $php_values['modules']['pear']:; }
    }
    if count($php_values['modules']['pecl']) > 0 {
      #php_pecl_mod { $php_values['modules']['pecl']:; }
    }

    if count($php_values['ini']) > 0 {

      each( $php_values['ini'] ) |$key, $value| {
        if is_array($value) {
          each( $php_values['ini'][$key] ) |$innerkey, $innervalue| {
            set_ini { "${key}_${innerkey}":
              entry       => "${innerkey}/${key}",
              value       => $innervalue,              
            }
			set_ini { "${key}_${innerkey}_CLI":
              entry       => "${innerkey}/${key}",
              value       => $innervalue,
			  target		=> $php_config_file_cli_ubuntu,			  
            }
          }
        } else {
          set_ini { $key:
            entry       => "${key}",
            value       => $value,
          }
		  set_ini { "${key}_CLI":
            entry       => "${key}",
            value       => $value,
			target		=> $php_config_file_cli_ubuntu,
          }
        }
      }
    }

    #if hash_key_equals($php_values, 'composer', 1)
    #  and ! defined(Class['puphpet::php::composer'])
    #{
    #  class { 'puphpet::php::composer':
    #    php_package   => "${php::params::module_prefix}cli",
    #    composer_home => $php_values['composer_home'],
    #  }
    #}

    # Usually this would go within the library that needs in (Mailcatcher)
    # but the values required are sufficiently complex that it's easier to
    # add here
    #if hash_key_equals($mailcatcher_values, 'install', 1)
    #  and ! defined(Puphpet::Php::Ini['sendmail_path'])
    #{
    #  puphpet::php::ini { 'sendmail_path':
    #    entry       => 'CUSTOM/sendmail_path',
    #    value       => "${mailcatcher_values['settings']['mailcatcher_path']}/catchmail -f",
    #    php_version => $php_values['version'],
    #    webserver   => $php_webserver_service_ini
    #  }
    #}
  }
}

define php_mod {
  if $name and ! defined(::Php::Module[$name]) {
    $module_prefix = $name ? {
		apc 	=> 'php-',
		default => 'php5-',
	}
	::php::module { $name:
		service_autorestart => false,
		module_prefix => $module_prefix
	}
  }
}

define php_pear_mod {
  if $name and ! defined(::Php::Pear::Module[$name]) {
    $name_array = split($name, '/')
    ::php::pear::module { $name_array[1]:
      use_package         => false,     
      service_autorestart => false,
	  repository => $name_array[0]
    }
  }
}
define php_pecl_mod {
  if ! defined(Puphpet::Php::Extra_repos[$name]) {
    puphpet::php::extra_repos { $name:
      before => Puphpet::Php::Pecl[$name],
    }
  }

  if ! defined(Puphpet::Php::Pecl[$name]) {
    puphpet::php::pecl { $name:
      service_autorestart => $php_webserver_restart,
    }
  }
}
define set_ini (  
  $entry,
  $value  = '',
  $target = $php_config_file_ubuntu
  ){
  php::augeas{ "${entry}-${value}-${target}" :
    entry   => $entry,
    value   => $value,    
	target  => $target,
    notify  => Service[$php_webserver_service],	
  }
}

