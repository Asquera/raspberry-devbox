class boxes::devbox {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/home/vagrant/.rvm/bin" ], timeout => 600 }
	
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
  
  package {"git-core":
  	ensure => present
  }
 
  # scratchbox build requirements 
  package {["libsdl1.2-dev", "libncurses5", "libncurses5-dev", "autoconf", "fakeroot", "realpath", "libc6-i386", "libc6-dev-i386"]:
    ensure => present
  }
 
  file {"/home/vagrant/src":
    ensure => directory,
    owner => "vagrant",
    group => "vagrant"
  }
  
  file {"/home/vagrant/raspberry_pi_development":
    ensure => directory,
    owner => "vagrant",
    group => "vagrant"
  }
  
  exec {"download-arm-toolchain":
    command => "curl https://sourcery.mentor.com/sgpp/lite/arm/portal/package8739/ppc/arm-none-gnueabi/arm-2011.03-41-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 > /home/vagrant/src/arm-2011.03-41-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2",
    creates => "/home/vagrant/src/arm-2011.03-41-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2",
    require => File["/home/vagrant/src"],
    user => vagrant,
    group => vagrant
  }
  
  exec {"unpack-arm-toolchain":
    command => "tar xjvf /home/vagrant/src/arm-2011.03-41-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 -C /home/vagrant/raspberry_pi_development",
    creates => "/home/vagrant/raspberry_pi_development/arm-2011.03/",
    subscribe => Exec["download-arm-toolchain"],
    refreshonly => true,
    require => File["/home/vagrant/raspberry_pi_development"],
    user => vagrant,
    group => vagrant
  }
  
  exec {"download-fedora-rootfs":
    command => "curl http://fedora.roving-it.com/rootfs-f14-minimal-RC1.tar.bz2 > /home/vagrant/src/rootfs-f14-minimal-RC1.tar.bz2",
    creates => "/home/vagrant/src/rootfs-f14-minimal-RC1.tar.bz2",
    require => File["/home/vagrant/src"],
    user => vagrant,
    group => vagrant
  }
  
  file {"/home/vagrant/raspberry_pi_development/rootfs_f14":
    ensure => "directory",
    require => File["/home/vagrant/raspberry_pi_development"],
    owner => vagrant,
    group => vagrant
  }
  
  exec {"unpack-fedora-rootfs":
    command => "tar xjvpf /home/vagrant/src/rootfs-f14-minimal-RC1.tar.bz2 -C /home/vagrant/raspberry_pi_development/rootfs_f14",
  #  creates => "/home/vagrant/raspberry_pi_development/rootfs_f14",
    subscribe => Exec["download-fedora-rootfs"],
    refreshonly => true,
    require => File["/home/vagrant/raspberry_pi_development/rootfs_f14"],
    # this must be run as root, we'll chown later
  }
  
  exec {"chown-fedora-rootfs":
    command => "chown -R vagrant:vagrant /home/vagrant/raspberry_pi_development/rootfs_f14",
    subscribe => Exec["unpack-fedora-rootfs"],
    refreshonly => true
  }
  
  exec {"download-scratchbox2":
    command => "git clone -q git://gitorious.org/scratchbox2/scratchbox2.git /home/vagrant/src/scratchbox2",
    creates => "/home/vagrant/src/scratchbox2",
    require => File["/home/vagrant/src"],
    user => vagrant,
    group => vagrant
  }
  
  exec {"download-qemu":
    command => "git clone -q git://git.qemu.org/qemu.git /home/vagrant/src/qemu",
    creates => "/home/vagrant/src/qemu",
    require => File["/home/vagrant/src"],
    user => vagrant,
    group => vagrant
  }
  
}