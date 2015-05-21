name             'posty'
maintainer       'posty-soft.org'
maintainer_email 'contact@posty-soft.org'
license          'LGPL v3'
description      'Installs/Configures a full mailserver stack administrated by posty'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

recipe "posty::default", "The default recipe installs a full mail server stack by including the individual recipes"
recipe "posty::postfix", "Installs postfix from the package sources"
recipe "posty::dovecot", "Installs dovecot from the package sources"
recipe "posty::amavis", "Installs amavis from the package sources"
recipe "posty::automx", "Installs automx from github"
recipe "posty::d-push", "Installs d-push from the package sources"
recipe "posty::dkim", "Installs opendkim from the package sources"
recipe "posty::postgrey", "Installs postgrey from the package sources"
recipe "posty::posty", "Installs the posty framework with api and webui"
recipe "posty::roundcube", "Installs the roundcube webmailer from the package sources"
recipe "posty::spamassassin", "Installs the spamassassin spam filter from the package sources"
recipe "posty::spamhaus", "Adds the Spamhaus Drop List to iptables"
recipe "posty::unattended_upgrades", "Activates unattended security upgrades"

supports "ubuntu", ">= 14.04"

depends "apt"
depends "locale"
depends 'timezone_lwrp'
depends "clamav"
depends "openssl"
depends "mysqld"
depends "ruby_build"