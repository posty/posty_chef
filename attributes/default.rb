#
# Cookbook Name:: posty
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

default["posty"]["company_name"]            = "Posty"
default["tz"]                               = "Europe/Berlin"
default["posty"]["certificate_name"]        = "ssl-cert-snakeoil" # change cert name and place certificate to /etc/ssl/certs/certificate_name.pem and key to /etc/ssl/private/certificate_name.key
default["posty"]["mail"]["master_user"]     = false # if you set this value to a string e.g. "posty" the master user functionality will be activated and the masterusername is set to "posty". A secure_random password will be generated and written to /etc/dovecot/master-users

default["posty"]["d-push"]["install"]             = true
default["posty"]["spamhaus_blacklist"]["install"] = true
default["posty"]["roundcube"]["install"]          = true

default["posty"]["webindex"]["install"]           = true
default["posty"]["webui"]["install"]              = true
default["posty"]["client"]["install"]             = true
default["clamav"]["clamd"]["enabled"]             = true
default["clamav"]["freshclam"]["enabled"]         = true

default['clamav']['clamd']['local_socket']            = "/var/run/clamav/clamd.ctl"
default["clamav"]["freshclam"]["database_mirrors"]    = ["clamav.netcologne.de", "database.clamav.net"]

default['mysqld']['root_password']   = ""

default["posty"]["tmp_dir"]          = "/tmp"
default["posty"]["var_dir"]          = "/var/lib/misc"
default["posty"]["ruby"]["version"]  = "2.0.0-p481"

default["posty"]["mail"]["hostname"] = node['fqdn']
default["posty"]["mail"]["domain"]   = "example.com" # This domain is used to generate the postmaster address for emails from the local root user and other important notifications if the domain is example.com we use postmaster@example.com for postmaster notifications and .forward file

default["posty"]["db"]["host"]   = "localhost"
default["posty"]["db"]["dbname"] = "vmail"
default["posty"]["db"]["dbuser"] = "vmail"
default["posty"]["db"]["dbpass"] = ""
default["posty"]["db"]["socket"] = "/var/run/mysqld/mysqld.sock"

default["posty"]["roundcube"]["dbname"]  = "roundcube"
default["posty"]["roundcube"]["dbuser"]  = "roundcube"
default["posty"]["roundcube"]["dbpass"]  = ""
default["posty"]["roundcube"]["name"]    = "roundcube"

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
default["posty"]["webui"]["htaccess_user"]    = ""
default["posty"]["webui"]["htaccess_pass"]    = ""

default["posty"]["client"]["apiurl"]     = "https://#{default["posty"]["api"]["host"]}/#{default["posty"]["api"]["webpath"]}/api/v1"
default["posty"]["client"]["user"]       = "root"
default["posty"]["client"]["group"]      = "root"
default["posty"]["client"]["configpath"] = "/root/.posty_client.yml"