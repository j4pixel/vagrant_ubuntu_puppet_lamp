
# Set localtime to Europe Zuerich 
file {'/etc/localtime':
  ensure => link,
  target => '/usr/share/zoneinfo/Europe/Zurich',
  mode   => 0640,
  owner  => 'root',
  group  => 'root'
}

#Masks an shel error when provisioning inside vagrant with rvmsudo  
file_line { 'modify-bashrc':
   path => '/home/vagrant/.bashrc',
   line => 'export rvmsudo_secure_path=1',
}


import 'nodes/apt.pp'
import 'nodes/mysql.pp'
import 'nodes/apache.pp'
import 'nodes/php.pp'
import 'nodes/sites-enabled.pp'
import 'nodes/xdebug.pp'

class {'composer':
		 require => Package['php'],		 
}

