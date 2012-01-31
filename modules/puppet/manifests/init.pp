# creates the user/group puppet that the puppet provisioner will need later

class puppet {
	
  group { "puppet": 
    ensure => "present",
  }
  
	user { "puppet":
		ensure => "present",
    gid => "puppet",
    require => Group["puppet"]
	}
  
	
}