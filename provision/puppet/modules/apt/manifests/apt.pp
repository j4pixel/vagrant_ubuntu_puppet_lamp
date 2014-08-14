class apt::apt {
    exec { "apt-get update":
        unless => "test -f /home/vagrant/.apt-update",
        command => "apt-get update -y",
        path => ["/bin", "/usr/bin"],
        notify => File["/home/vagrant/.apt-update"],
    }

    file { "/home/vagrant/.apt-update":
        ensure => file,
        force => true
    }
}