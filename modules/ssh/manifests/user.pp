define ssh::user($user = "${name}", $home = "/home/${name}") {
  
  
  User[$user] -> File[$home] -> file { "$home/.ssh/":
    ensure => directory,
  } -> file { "$home/.ssh/known_hosts":
    ensure => present,
    content => template("ssh/user/known_hosts.erb"),
    owner => $user,
    mode => "0420"
  }
  
}