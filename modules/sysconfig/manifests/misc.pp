class sysconfig::misc {
  package { "vim":
    ensure => present,
  }
	
  package { "htop":
    ensure => present,
  }
}