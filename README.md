posty-chef - Chef cookbook to install a complete mailserver
===========================================================
Chef cookbook to install and configure a mail server with [Postfix](http://www.postfix.org/), [Dovecot](http://www.dovecot.org/), [Roundcube](http://roundcube.net/), [SpamAssassin](http://spamassassin.apache.org/), and [Posty](http://www.posty-soft.org/).

Requirements
------------

### Cookbooks
The following external cookbooks are used:

* [apt](https://github.com/opscode-cookbooks/apt)
* [mysql](https://github.com/opscode-cookbooks/mysql)
* [ruby_build](https://github.com/fnichol/chef-ruby_build)

Additionally the following cookbooks must be present due to dependencies, but aren't executed:

* [yum](https://github.com/opscode-cookbooks/yum)
* [yum-mysql-community](https://github.com/opscode-cookbooks/yum-mysql-community)


### Platform
The following platforms are currently supported and tested:

* Ubuntu 12.04
* Ubuntu 14.04


Virtual Test and Development Environment
----------------------------------------
For the development of this cookbook and for easy testing we provide an
automated process to set up a virtual test/development machine with VirtualBox
and Vagrant.

### Requirements
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com) 1.6+
* [Vagrant Omnibus](https://github.com/schisamo/vagrant-omnibus)

### Vagrant installation with Ubuntu as host
* Download the latest Vagrant version from the [project page](http://www.vagrantup.com/downloads.html)
* `dpkg -i vagrant*.deb; apt-get install -f` or install the deb via Ubuntu Software Center
* `vagrant plugin install vagrant-omnibus` to install Omnibus

### Bootstrapping the Virtual Development Machine

```
git clone https://github.com/posty/posty_chef
cd posty_chef

git clone https://github.com/opscode-cookbooks/apt cookbooks/apt
git clone https://github.com/opscode-cookbooks/mysql cookbooks/mysql
git clone https://github.com/fnichol/chef-ruby_build cookbooks/ruby_build
git clone https://github.com/opscode-cookbooks/yum cookbooks/yum
git clone https://github.com/opscode-cookbooks/yum-mysql-community cookbooks/yum-mysql-community

vagrant up
```

This sets up a virtual development machine host __posty-chef__ based on
Ubuntu 14.04. providing all services mentioned above.

The IP address assigned to the host is 192.168.246.10 which can be changed
by adapting the parameter "config.vm.network" in the Vagrantfile accordingly.
The setup takes a couple of minutes. After the installation has finished
you can login to the machine by running: `vagrant ssh`

### Configuration
Before starting the installation of the posty system some configuration values should be adjusted.
Most importantly the passwords have to be set. Currently these settings are located in the Vagrantfile.
