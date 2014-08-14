# = Define: php::augeas
#
# Manage php.ini through augeas
#
# Here's an example how to find the augeas path to a variable:
#
#     # augtool --noload
#     augtool> rm /augeas/load
#     rm : /augeas/load 781
#     augtool> set /augeas/load/myfile/lens @PHP
#     augtool> set /augeas/load/myfile/incl /usr/local/etc/php5/cgi/php.ini
#     augtool> load
#     augtool> print
#     ...
#     /files/usr/local/etc/php5/cgi/php.ini/soap/soap.wsdl_cache_limit = "5"
#     /files/usr/local/etc/php5/cgi/php.ini/ldap/ldap.max_links = "-1"
#     ...
#     augtool> exit
#     #
#
# The part after 'php.ini/' is what you need to use as 'entry'.
#
# == Parameters
#
# [*entry*]
#   Augeas path to entry to be modified.
#
# [*value*]
#   Value to set
#
# [*ensure*]
#   Standard puppet ensure variable
#
# [*target*]
#   Which target to apply changes to can be either 'cli', 'apache' or 'both'. Default is 'both' 
#
# [*target_cli*]
#   Which php.ini to manipulate for cli target. Default is /etc/php5/cli/php.ini
#
# [*target_apache*]
#   Which php.ini to manipulate for apache target. Default is /etc/php5/apache2/php.ini
#
# == Examples
#
# php::augeas {
#   'php-memorylimit':
#     entry  => 'PHP/memory_limit',
#     value  => '128M',
#	  target => 'apache';
#   'php-error_log':
#     entry  => 'PHP/error_log',
#     ensure => absent;
#   'php-sendmail_path':
#     entry  => 'mail function/sendmail_path',
#     value  => '/usr/sbin/sendmail -t -i -f info@example.com';
#   'php-date_timezone':
#     entry  => 'Date/date.timezone',
#     value  => 'Europe/Amsterdam';
# }
#
define php::augeas (
  $entry,
  $value  = '',
  $ensure = present,
  $target = 'both', 
  $target_cli = '/etc/php5/cli/php.ini',
  $target_apache = '/etc/php5/apache2/php.ini',
  ) {

  $changes = $ensure ? {
    present => [ "set '${entry}' '${value}'" ],
    absent  => [ "rm '${entry}'" ],
  }
  
  case $target {
    'cli': {
	  augeas_cli{"php_ini_cli-${name}": changes => $changes, target_file => $target_cli}
    }
	'apache': {
	  augeas_apache{"php_ini_apache-${name}": changes => $changes, target_file => $target_apache} 
    }
    default: {
	  augeas_cli{"php_ini_cli-${name}": changes => $changes, target_file => $target_cli}
	  augeas_apache{"php_ini_apache-${name}": changes => $changes, target_file => $target_apache} 
    }
  } # End Case
}

define php::augeas_cli($changes, $target_file){     
  augeas { $title:
    incl    => $target_file,
    lens    => 'Php.lns',
    changes => $changes,
    require => [ 
      Package['php5-cli'],
      Exec['fix augeas']
    ],
  }  		
}

define php::augeas_apache($changes, $target_file){     
  augeas { $title:
    incl    => $target_file,
    lens    => 'Php.lns',
    changes => $changes,
	notify  => Service['apache2'],
	require => [ 
	  Package['php5'],
	  Exec['fix augeas']
	],
  }  		
}