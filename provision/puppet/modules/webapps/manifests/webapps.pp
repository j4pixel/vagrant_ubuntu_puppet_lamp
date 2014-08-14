class webapps::webapps {

  $appnames = [
    'calleo', 
	'virtua_laravel_framework'
	]
  
  
  # create apache config from main vagrant manifests
  file { '/etc/apache2/sites-available/vagrant_webroot.conf':
    ensure => link,
    source => '/vagrant/provision/puppet/manifests/vagrant_webroot.conf',
    require => Package['apache2'],
	notify => Service['apache2']
  }

  # symlink apache site to the site-enabled directory
  file { '/etc/apache2/sites-enabled/vagrant_webroot.conf':
    ensure => link,
    target => '/etc/apache2/sites-available/vagrant_webroot.conf',
    require => File['/etc/apache2/sites-available/vagrant_webroot.conf'],
    notify => Service['apache2'],
  }


  
}
