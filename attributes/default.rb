#
# Cookbook Name:: posty
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

default["posty"]["clamav"]["install"]       = true
default["posty"]["spamassassin"]["install"] = true
default["posty"]["roundcube"]["install"]    = true

default["posty"]["webindex"]["install"]     = true
default["posty"]["webui"]["install"]        = true
default["posty"]["client"]["install"]       = true

default["mysql"]["server_root_password"]    = ""
default["clamav"]["clamd"]["enabled"]       = default["posty"]["clamav"]["install"]
default["freshclam"]["enabled"]             = default["posty"]["clamav"]["install"]
default["freshclam"]["database_mirrors"]    = ["clamav.netcologne.de", "database.clamav.net"]

default["posty"]["tmp_dir"]         = "/tmp"
default["posty"]["var_dir"]         = "/var/lib/misc"
default["posty"]["ruby"]["version"] = "2.0.0-p481"

default["posty"]["mail"]["hostname"] = node["hostname"]
default["posty"]["mail"]["domain"]   = "example.org"

default["posty"]["db"]["host"]   = "localhost"
default["posty"]["db"]["dbname"] = "vmail"
default["posty"]["db"]["dbuser"] = "vmail"
default["posty"]["db"]["dbpass"] = ""
default["posty"]["db"]["socket"] = "/var/run/mysqld/mysqld.sock"

default["posty"]["roundcube"]["dbname"] = "roundcube"
default["posty"]["roundcube"]["dbuser"] = "roundcube"
default["posty"]["roundcube"]["dbpass"] = ""

default["posty"]["api"]["github"]   = "https://github.com/posty/posty_api"
default["posty"]["api"]["revision"] = "master"
default["posty"]["api"]["location"] = "/srv/posty_api"
default["posty"]["api"]["user"]     = "root"
default["posty"]["api"]["group"]    = "www-data"
default["posty"]["api"]["rack_env"] = "production"

default["posty"]["api"]["host"]     = "192.168.254.10"
default["posty"]["api"]["webpath"]  = "posty_api"
default["posty"]["webui"]["apiurl"]    = "http://#{default["posty"]["api"]["host"]}/#{default["posty"]["api"]["webpath"]}/api/v1"

default["posty"]["webui"]["github"]    = "https://github.com/posty/posty_webui"
default["posty"]["webui"]["revision"]  = "master"
default["posty"]["webui"]["location"]  = "/srv/posty_webui"
default["posty"]["webui"]["user"]      = "root"
default["posty"]["webui"]["group"]     = "www-data"
