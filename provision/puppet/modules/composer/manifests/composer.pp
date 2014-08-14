class composer::composer {
    exec { "get-composer":
        cwd => "/usr/local/bin",
        unless => [ "test -f /usr/local/bin/composer.phar || test -f /usr/local/bin/composer"],
        command => "sudo curl -sS https://getcomposer.org/installer | sudo php",
        path => ["/bin", "/usr/bin"],
        require => Package["curl", "php5-cli"]
    }

    exec { "make-composer-executable":
        unless => [ "test -f /usr/local/bin/composer"],
        command => "sudo mv /usr/local/bin/composer.phar /usr/local/bin/composer; sudo chmod +x /usr/local/bin/composer;",
        path => ["/bin", "/usr/bin"],
        require => Exec["get-composer"],
    }
}
