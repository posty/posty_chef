#
# Cookbook Name:: posty
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

default["posty"]["administrator_email_address"] = "info@example.com"
default["posty"]["company_name"]            = "Posty"
default["posty"]["certificate_name"]        = "ssl-cert-snakeoil" # change cert name and place certificate to /etc/ssl/certs/certificate_name.pem and key to /etc/ssl/private/certificate_name.key
default["posty"]["mail"]["master_user"]     = false # if you set this value to a string e.g. "posty" the master user functionality will be activated and the masterusername is set to "posty". A secure_random password will be generated and written to /etc/dovecot/master-users

default["posty"]["d-push"]["install"]       = true
default["posty"]["clamav"]["install"]       = false
default["posty"]["spamassassin"]["install"] = false
default["posty"]["roundcube"]["install"]    = true

default["posty"]["webindex"]["install"]     = true
default["posty"]["webui"]["install"]        = true
default["posty"]["client"]["install"]       = true

default["mysql"]["server_root_password"]    = "test123"
default["clamav"]["clamd"]["enabled"]       = default["posty"]["clamav"]["install"]
default["freshclam"]["enabled"]             = default["posty"]["clamav"]["install"]
default["freshclam"]["database_mirrors"]    = ["clamav.netcologne.de", "database.clamav.net"]

default["posty"]["tmp_dir"]         = "/tmp"
default["posty"]["var_dir"]         = "/var/lib/misc"
default["posty"]["ruby"]["version"] = "2.0.0-p481"

default["posty"]["mail"]["hostname"] = node['fqdn']
default["posty"]["mail"]["domain"]   = "webflow.de"

default["posty"]["db"]["host"]   = "localhost"
default["posty"]["db"]["dbname"] = "vmail"
default["posty"]["db"]["dbuser"] = "vmail"
default["posty"]["db"]["dbpass"] = "vmail"
default["posty"]["db"]["socket"] = "/var/run/mysqld/mysqld.sock"

default["posty"]["roundcube"]["dbname"]  = "roundcube"
default["posty"]["roundcube"]["dbuser"]  = "roundcube"
default["posty"]["roundcube"]["dbpass"]  = "roundcube"

default["posty"]["api"]["github"]   = "https://github.com/posty/posty_api"
default["posty"]["api"]["revision"] = "master"
default["posty"]["api"]["location"] = "/srv/posty_api"
default["posty"]["api"]["user"]     = "root"
default["posty"]["api"]["group"]    = "www-data"
default["posty"]["api"]["rack_env"] = "production"

default["posty"]["api"]["host"]     = node['fqdn']
default["posty"]["api"]["webpath"]  = "posty_api"
default["posty"]["webui"]["apiurl"] = "https://#{default["posty"]["api"]["host"]}/#{default["posty"]["api"]["webpath"]}/api/v1"

default["posty"]["webui"]["github"]   = "https://github.com/posty/posty_webui"
default["posty"]["webui"]["revision"] = "master"
default["posty"]["webui"]["location"] = "/srv/posty_webui"
default["posty"]["webui"]["user"]     = "root"
default["posty"]["webui"]["group"]    = "www-data"
default["posty"]["webui"]["htaccess_user"]    = "posty"
default["posty"]["webui"]["htaccess_pass"]    = "posty"

default["posty"]["client"]["apiurl"]     = "https://#{default["posty"]["api"]["host"]}/#{default["posty"]["api"]["webpath"]}/api/v1"
default["posty"]["client"]["user"]       = "root"
default["posty"]["client"]["group"]      = "root"
default["posty"]["client"]["configpath"] = "/root/.posty_client.yml"
