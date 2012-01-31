
class sysconfig::sudoers {

  file { "/etc/sudoers":
    content => template("sysconfig/etc/sudoers.erb"),
    ensure => present,
    mode => 0440
  }

}


class {
  'sysconfig::sudoers': stage => sysconfig; 
}
