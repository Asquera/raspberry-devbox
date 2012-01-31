# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.


  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  config.vm.boot_mode = :gui

  config.vm.define :nox do |box|
    box.vm.box = "ubuntu-10.04.3-server-amd64-asq"
    #gbox.vm.box_url = "http://example.org/path/to/box"
    # uncomment the following line if you want the box to start in gui mode
    box.vm.boot_mode = :gui
    box.vm.network :hostonly, "33.33.33.151"

    box.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppetmanifests"
      puppet.manifest_file = "raspberry-nox.pp"
      puppet.module_path = "modules"
      puppet.options = "--verbose --debug"
    end
  end


end
