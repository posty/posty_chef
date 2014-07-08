name             'posty'
maintainer       'posty-soft'
maintainer_email 'support@posty-soft.org'
license          'All rights reserved'
description      'Installs/Configures a full mailserver stack administrated by posty'
long_description ''#IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "posty::default", "The default recipe installs a full mail server stack by including the individual recipes"
recipe "posty::postfix-dovecot", "Installs postfix and dovecot from the package sources and configures them"
recipe "posty::posty", "Installs the posty framework with api and webui"
recipe "posty::roundcube", "Installs the roundcube webmailer from the package sources"
recipe "posty::spamassassin", "Installs the spamassassin spam filter from the package sources"

supports "ubuntu"

depends "apt"
depends "clamav-chef"
depends "cron"
depends "logrotate"
depends "mysql"
depends "ruby_build"

depends "yum"
depends "yum-epel"
depends "yum-mysql-community"
