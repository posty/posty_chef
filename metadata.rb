name             'posty'
maintainer       'posty-soft.org'
maintainer_email 'contact@posty-soft.org'
license          'LGPL v3'
description      'Installs/Configures a full mailserver stack administrated by posty'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.5'

recipe "posty::default", "The default recipe installs a full mail server stack by including the individual recipes"
recipe "posty::postfix-dovecot", "Installs postfix and dovecot from the package sources and configures them"
recipe "posty::posty", "Installs the posty framework with api and webui"
recipe "posty::roundcube", "Installs the roundcube webmailer from the package sources"
recipe "posty::spamassassin", "Installs the spamassassin spam filter from the package sources"

supports "ubuntu", ">= 12.04"
supports "debian", ">= 7.0"

depends "apt"
depends "clamav"
depends "mysql"
depends "ruby_build"
