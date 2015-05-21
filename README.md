posty Cookbook
===========================================================
Chef cookbook for a full posty mail server installation with
[Postfix](http://www.postfix.org/),
[Dovecot](http://www.dovecot.org/),
[Roundcube](http://www.roundcube.net/),
[z-push, d-push](http://www.z-push.org),
[Postgrey](http://postgrey.schweikert.ch/),
[Spamhaus](http://www.spamhaus.org/drop/),
[automx](http://www.automx.org/),
[Amavis](http://www.ijs.si/software/amavisd/),
[ClamAV](http://www.clamav.net/),
[SpamAssassin](http://spamassassin.apache.org/) and
[Posty](http://www.posty-soft.org/).


Requirements
------------

### Cookbooks
The following external cookbooks are used:

* [apt](https://github.com/opscode-cookbooks/apt)
* [locale](https://github.com/hw-cookbooks/locale)
* [timezone_lwrp](https://github.com/dragonsmith/timezone_lwrp)
* [openssl](https://github.com/opscode-cookbooks/openssl)
* [mysqld](https://github.com/chr4-cookbooks/mysqld)
* [ruby_build](https://github.com/fnichol/chef-ruby_build)
* [clamav](https://github.com/RoboticCheese/clamav-chef)

All dependencies are automatically resolved when using Berkshelf

### Platform
The following platforms are currently supported and tested:

* Ubuntu 14.04

Usage
-----
This recipe can be used in multiple ways. The Vagrant method is recommended for
inexperienced Chef users.

**Warning**: This recipe installs a complete mail server with many individual
programms, thus changes a lot of system files. Using it on an unconfigured
system is recommended.

#### Chef Server
Just include `posty` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[posty]"
  ]
}
```
Then change the Attributes to your needs.
The important attributes are:
```
default["posty"]["company_name"]            = "Posty" # set it to your company name it is used in roundcube
default["tz"]                               = "Europe/Berlin" # set it to your timezone
default["posty"]["certificate_name"]        = "ssl-cert-snakeoil" # change cert name and place certificate to /etc/ssl/certs/certificate_name.pem and key to /etc/ssl/private/certificate_name.key
default['mysqld']['root_password']          = "" # set a password for your mysql root user
default["posty"]["mail"]["domain"]          = "example.com" # This domain is used to generate the postmaster address for emails from the local root user and other important notifications if the domain is example.com we use postmaster@example.com for postmaster notifications and .forward file
default["posty"]["db"]["dbpass"]            = "" # this password is for the database for posty
default["posty"]["roundcube"]["dbpass"]     = "" # this password is for the roundcube database
```

#### Chef Zero
The IMPORTANT attributes:
Please change it before the first chef zero run
```
default["posty"]["company_name"]            = "Posty" # set it to your company name it is used in roundcube
default["tz"]                               = "Europe/Berlin" # set it to your timezone
default["posty"]["certificate_name"]        = "ssl-cert-snakeoil" # change cert name and place certificate to /etc/ssl/certs/certificate_name.pem and key to /etc/ssl/private/certificate_name.key
default['mysqld']['root_password']          = "" # set a password for your mysql root user
default["posty"]["mail"]["domain"]          = "example.com" # This domain is used to generate the postmaster address for emails from the local root user and other important notifications if the domain is example.com we use postmaster@example.com for postmaster notifications and .forward file
default["posty"]["db"]["dbpass"]            = "" # this password is for the database for posty
default["posty"]["roundcube"]["dbpass"]     = "" # this password is for the roundcube database
```

First create a chef repo for the box you will create eg. mail.example.com
* `chef generate repo mail.example.com` This creates a new chef repo
* `cd mail.example.com` Go to the new created folder
* `touch metadata.rb` create the missing metadata.rb
* `berks init` creates the Berksfile
* Now edit the Berksfile and add `cookbook "posty", path: 'path_to_the_downloaded_posty_cookbook'` instead of the metadata line
* `berks vendor ./cookbooks` installs all cookbooks in the ./cookbook folder
* Create a Role File for your needs and add the posty recipe to your run_list and set the important attributes above
* `knife zero bootstrap mail.example.com -r 'role[rolename]'` this bootstraps your server and runs chef-client with the role "rolename"

#### Vagrant
For the development of this cookbook and to allow easy testing of the posty
system, an automated process to set up a virtual test/development machine is
provided.

##### Requirements
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com) 1.6+
* [Vagrant Omnibus](https://github.com/schisamo/vagrant-omnibus)
* [Vagrant Chef Zero](https://github.com/schubergphilis/vagrant-chef-zero)
* [Vagrant Berkshelf](https://github.com/berkshelf/vagrant-berkshelf) 2.0.1+

##### Vagrant installation with Ubuntu as host
* Download the latest Vagrant version from the [project page](http://www.vagrantup.com/downloads.html)
* `dpkg -i vagrant*.deb; apt-get install -f` or install the deb via Ubuntu Software Center
* `vagrant plugin install vagrant-omnibus` to install Omnibus
* `vagrant plugin install vagrant-chef-zero` to install Chef Zero
* `vagrant plugin install vagrant-berkshelf --plugin-version '>= 2.0.1'` to install Berkshelf

##### Bootstrapping the Virtual Development Machine

```
git clone https://github.com/posty/posty_chef
cd posty_chef
vagrant up
```

This sets up a virtual machine host __posty-chef__ based on Ubuntu 14.04
providing all services mentioned above.

The IP address assigned to the host is 192.168.254.10 which can be changed
by adapting the parameter "config.vm.network" in the Vagrantfile accordingly.

The setup takes a couple of minutes. After the installation has finished
you can login to the machine by running: `vagrant ssh`
The posty_webui, automx and the roundcube webmailer are reachable via HTTP and HTTPS
under the configured [IP](http://192.168.254.10). The mail services are
reachable under the same IP.


License and Authors
-------------------
See LICENSE file.
