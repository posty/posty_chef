name             'posty'
maintainer       'posty-soft'
maintainer_email 'support@posty-soft.org'
license          'All rights reserved'
description      'Installs/Configures a full mailserver stack administrated by posty'
long_description ''#IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "posty::default", "The default recipe installs a full mail server stack by including the individual recipes"
recipe "posty::posty", "The posty recipe installs the posty framework with api and webui"

supports "ubuntu"

depends "apt"
depends "clamav-chef"
depends "cron"
depends "logrotate"
depends "mysql"
depends "ruby_build"

depends "postfix-dovecot"
depends "roundcube"
depends "spamassassin"

depends "yum"
depends "yum-epel"
depends "yum-mysql-community"
