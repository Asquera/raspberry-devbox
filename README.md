# Raspberry Pi Devbox

A virtual machine built for raspberry pi development, based on http://russelldavis.org/2012/01/27/setting-up-a-vm-for-raspberry-pi-development-using-virtualbox-scratchbox2-qemu-part-1/

## Words of Caution

Vagrant uses a default user with a default password and a well known keypair for authentication. The default user has superuser access. Running a vagrant box in a configuration that makes it accessible from the outside is a major security risk. The default configuration prevents outside access by using NAT and host-only networking exclusively. Do not tamper with that configuration unless you know what you're doing. If you need to run a vagrant box in a network-accessible configuration at least change the passwords and keypairs.

## Virtualbox

The basic virtualization-layer is [[Virtualbox | https://www.virtualbox.org/]]. Any current version should do, however the guest additions are pinned to version of the GA release at the time the base box was built (4.1.8). A mismatch between the guest-additions and the virtualbox version may result in strange behavior, mostly affecting shared folders and networking. To update the guest additions follow the instructions in the virtualbox manual.

## Vagrant

[[Vagrant | http://vagrantup.com/]] is the scripting toolkit used to control all interaction with the devbox. Any recent version of vagrant (>= 0.9) should work.

A full guide on vagrant can be found on the [[Vagrant site |  http://vagrantup.com/docs ]]. As a short primer, the following commands should be sufficient:

* `vagrant up <boxname>` start the given box. If the box has not been initialized and created, this will download the basebox as required, bootstrap it and run the provisioner. Running `vagrant up` when the box is already running is a NOOP and has no effect.
* `vagrant halt <boxname>` stop the given box. Has no effect if the box is not running. May require an invocation using the `--force` flag (`vagrant halt --force <boxname>`) if the box crashed, locked up or cannot be accessed via `vagrant ssh`
* `vagrant reload <boxname>` stop and start the given box. Runs the provisioner.
* `vagrant provision <boxname>` Runs the provisioner.
* `vagrant destroy <boxname>` destroys the given box. This is useful if for some reason the box has been damaged or to free diskspace. Running `vagrant up` after running `vagrant destroy` bootstraps a new box.
* `vagrant ssh <boxname>` open an ssh connection to the given box.
	
By default all boxes are set to boot in headleass mode, that is without a graphical user interface. Gui mode can be enabled by uncommenting the `box.vm.boot_mode = :gui` line in the appropriate section of the vagrantfile.

## Hardware

At the moment, the devbox only works in 64bit processors with Vanderpool (hardware virtualization, VT-x for Intel, AMD-V for AMD processors) enabled. While the first can be fixed by compiling a 32bit devbox, the latter will lead to an excessive performance penalty. Be aware that even if a processor supports implements VT-x, some notebook vendors deactivate it. Known states:

* Dell Latitude: works out of the box
  - Some Dell models deactivate VT-x by default, but this can be changed in BIOS
* All Apple notebooks currently available work
* All Intel i3/5/7 processors support VT-x, if not disabled by the vendor.


## Puppet

Package and config-file management is handled by puppet and the vagrant puppet provisioner. The required puppet installation is in the base box, all manifests can be found in the toolbox repository. No puppet installation is needed on the host system.

## Installation / First Use

* Install Virtualbox and Vagrant. See [[Installing Vagrant | http://vagrantup.com/docs/getting-started/index.html]] for a guide. You may skip the last step.
* Clone the repository using a git client of your choice. Mac users that are not comfortable using the commandline may use [[Github for Mac | http://mac.github.com/]] to download the repository and any updates
* Open the shell of your choice and navigate to the repository
* Run `vagrant up <boxname>` to boot the box. See the list of available boxes for the name.
	
Vagrant will now download the basebox, bootstrap the environment and run the provisioner for the first time. Since the basebox must be downloaded and some source must be compiled, the first run may take some time depending on your machines speed and network connection. No supervision should be required, running the install over night should be just fine. Future runs will be faster since the software is only installed on the first run. Future runs should not require network connectivity, execpt when destroying and rebuilding a box.

## Pulling Updates

Pulling updates is done by updating the repository to get the latest puppet manifests and/or remove the src folder as well as the raspberry_pi_development folder inside the box to trigger a redownload of the src and a rebuild of the packages. After updating the repository the provisioner needs to be triggered by running `vagrant provision <boxname>` on the console. This will install any new packages and update config-files as required. The provisioner is also triggered on each fresh boot of the devbox. 

## Help, Something went wrong.

* Sometimes vagrant fails to mount the shared folders for the puppet provisioner. This usually results in puppet complaining about a missing file or folder. Reloading the box using `vagrant reload <boxname>` usually solves this problem.
* Sometimes dependencies between puppet packages are not modeled correctly. This usually results in puppet printing the message "Skipping because of failed dependencies" to the console. This problem usually can be solved by re-running the puppet provisioner using `vagrant provision <boxname>`. Sometimes multiple runs are required to solve the issue. Please report such issues so that we can fix the dependencies.
* Box does not boot properly and cannot be accessed via `vagrant ssh`: Enable gui mode by uncommenting the `box.vm.boot_mode = :gui` line in the config and reload the box using the `--force` flag. Observe the error messages.

## Boxes

### No X (nox)

Start using `vagrant up nox`. The box does not include an X environment. Instead it allows ssh access and exports the home directory via nfs. This way you can develop using your favorite IDE on your host system. A box that contains a full X11-environment will be provided.


## Tips & Tricks

### Connecting to the Box

Using `vagrant ssh` is not required to connect to the box. Vagrant uses a regular ssh connection with a special, known keypair. To connect to the box using regular ssh command follow this procedure:

* Download the default keypair from the [[git repository|https://github.com/mitchellh/vagrant/tree/master/keys/]] and place the private key in a convenient location. `~/.ssh/vagrant` is a suitable location on unix/linux/macos systems.
* Make sure that the key is user-readable only (0600 on unix-style systems)
* Add the following section to the ssh configfile 
* use `ssh app-vagrant` to connect to the appserver
* Enable agent-forwarding so you can check out and update the github repositories

````
Host app-vagrant # or any other alias
    Hostname 33.33.33.20 # ip of the box you want to connect to
	User vagrant
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/vagrant
	ForwardAgent yes
	StrictHostKeyChecking no
	UserKnownHostsFile /dev/null
````

This is especially useful in conjunction with the iterm2 stored profiles feature. 

### GIT_* Environment Variables

The ssh daemon in the box is configured to accept all environment variables starting with `GIT_*`. Setting the variables on the host server allows to send those variables to the environment in the devbox. The git command will use those variables to credit commits to the proper author. The following two bits of configuration are required:

Add the variables to the shell of your choice, for example in .bashrc:

````
export GIT_AUTHOR_EMAIL=<your email>
export GIT_AUTHOR_NAME='<your name>'
export GIT_COMMITTER_EMAIL=<your email>
export GIT_COMMITTER_NAME='<your name>'
export GIT_EDITOR=/usr/bin/vim
````

Configure ssh to send the env variables to the guest system:

````
Host app-vagrant
  SendEnv GIT_*
````

## Bugs, Fixes, Improvement

If you encounter a bug, please file a ticket. If you'd like to help, fork the repository, make your changes and send me a pull request. Please use feature-branches :).

## Todo

* all of this is still quite rough
* the path to qemu and scratchbox2 is currently not set up properly, add a 'export PATH="/home/vagrant/raspberry_pi_development/qemu/bin/:/home/vagrant/raspberry_pi_development/scratchbox2/bin:$PATH"' to the .bashrc
* improve on the readme
* add hostonly networking and nfs share
* add a second vm that has X
