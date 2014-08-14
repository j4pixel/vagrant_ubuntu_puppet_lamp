# == Class: mysql
#
# Manage mysql database server configuration
#
# === Parameters
#
# [*rootpwd*]
# root mysql password to be set on server

class mysql::mysql($rootpwd = 'd3v0p5') {

  # install mysql server
  package { "mysql-server":
    ensure => present,
    require => Exec["apt-get update"]
  }

  #start mysql service
  service { "mysql":
    ensure => running,
    require => Package["mysql-server"],
  }

  # set mysql password
  exec { "set-mysql-password":
    unless => "mysqladmin -uroot -p$rootpwd status",
    command => "mysqladmin -uroot password $rootpwd",
    require => Service["mysql"],
  }
  
  exec { "grant-root-access-from-externalhost":
    unless  => "mysql -uroot -pd3v0p5 mysql -e \"select count(*) from user where host = '%' \"",
    command => "mysql -uroot -p$rootpwd -e \"GRANT ALL ON *.* to root@'%' identified by '$rootpwd'\"",
    require => Exec["set-mysql-password"],
  }
  
  
  
  exec { 'sudo sed -i "s/^.*bind-address.*$/bind-address = 0.0.0.0/" /etc/mysql/my.cnf':
    onlyif => '/bin/grep "bind-address.*\=.*127\.0\.0\.1" /etc/mysql/my.cnf',
    require => Package["mysql-server"],
    notify => Service["mysql"],
 }
}
