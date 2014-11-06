# vagrant-sil

vagrant-sil contains [Vagrant](www.vagrantup.com) configuration for accessing pre-configured virtual machines for testing graphical software on different Linux distributions.  Most uses of Vagrant are normally for server-based applications and are run headless and have minimal number of packages installed.  However, for testing Linux desktop software, you want to have a typical desktop user setup.  So these images are quite a bit larger that standard pre-configured Vagrant images.

## Configuration

Each of the machines have been setup using the documentation for a [base box](https://docs.vagrantup.com/v2/boxes/base.html) which means:
* username=vagrant, password=vagrant
* password-less sudo

Each of the machines have been setup to make it easy to work with the [SIL package repositories](http://packages.sil.org) which mean:
* pgp keys have been imported
* apt is pre-configured to include main and experimental PSO repositories
* additional packages have been installed: curl, aptitude, synaptic, git, vim, wget, git-gui, gitk, kdiff3-qt, terminator, ssh, gdebi, ttf-mscorefonts-installer

Minor changes have been made to simplify testing:
* Turn screen off when inactive: Never
* Lock: Off
* Uninstall deja-dup
* Change default Profile Colors for terminal (makes it easier to distinguish from host terminal windows)
* Unique background image per machine (to easily distinguish the version)
* .bashrc change to include [git bash prompt](http://www.thehubbards.org/blog/2014/05/22/git-changing-bash-prompt/)
* Disable Online Searches form Dash for Saucy+ (https://fixubuntu.com/fixubuntu.sh)

