# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

# silence puppet and vagrant annoyance about the puppet group
group { 'puppet':
    ensure => 'present'
}

#include apt::apt
#include tools::tools

#include php::php


