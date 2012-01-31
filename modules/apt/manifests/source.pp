# Here's how you generate a keyring file to put in your puppet fileserver and
# reference with a puppet:///path/to/foo.gpg:
#
#     gpg --no-default-keyring --keyserver keyserver.ubuntu.com --keyring /path/to/fileserver/foo.gpg --recv-keys DEADBEEF
define apt::source ($url, $suite = $::lsbdistcodename, $component = 'main', $type = 'deb', $keyring = '', $ensure = present) {

  if $keyring != '' {
    file { "/etc/apt/trusted.gpg.d/${name}.gpg":
      source => $keyring,
      ensure => $ensure
    }
  }

  file { "/etc/apt/sources.list.d/${name}.list":
    content => "# This file is managed by puppet\n\n${type} ${url} ${suite} ${component}\n",
    ensure => $ensure,
    notify => Exec["apt-get update"],
  }

}