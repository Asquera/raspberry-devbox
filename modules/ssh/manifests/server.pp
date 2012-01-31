
class ssh::server {
    
  file { "/etc/ssh/sshd_config":
    content => template("ssh/server/sshd_config.erb"),
    ensure => present,
    notify => Service['ssh']
  }
	
  service { "ssh":
	  require => Package['openssh-server'],
    ensure => running,
    enable => true
  }

  package { "openssh-server":
    ensure => present
  }

}