class boxes::devbox {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/home/vagrant/.rvm/bin" ] }
	
  include sysconfig
  include sysconfig::sudoers
  include apt
  include puppet
  include ssh::server
  
  user {"vagrant":
    ensure => present,
    home => "/home/vagrant"
  } -> file {"/home/vagrant":
    ensure => directory,
    owner => vagrant
  }
  
  user {"root":
    ensure => present,
    home => "/root"
  } -> file {"/root":
    ensure => directory,
    owner => root
  }
  
  ssh::user {"vagrant":
  }
  
  ssh::user { "root":
    home => "/root"
  }
 
}