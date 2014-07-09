#
# Cookbook Name:: posty
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

default["mysql"]["server_root_password"]     = ""
default["clamav"]["clamd"]["enabled"]        = "true"
default["freshclam"]["enabled"]              = "true"
default["freshclam"]["database_mirrors"]     = ["clamav.netcologne.de", "database.clamav.net"]


default["posty"]["conf_dir"]        = "/var/tmp"
default["posty"]["ruby"]["version"] = "2.0.0-p481"

default["posty"]["mail"]["hostname"] = node["hostname"]
default["posty"]["mail"]["domain"]   = "example.org"

default["posty"]["db"]["host"]     = "localhost"
default["posty"]["db"]["dbname"]   = "vmail"
default["posty"]["db"]["dbuser"] = "vmail"
default["posty"]["db"]["dbpass"] = ""
default["posty"]["db"]["socket"]   = "/var/run/mysqld/mysqld.sock"

default["posty"]["roundcube"]["dbname"] = "roundcube"
default["posty"]["roundcube"]["dbuser"] = "roundcube"
default["posty"]["roundcube"]["dbpass"] = ""

default["posty"]["deploy"]["user"]     = "root"
default["posty"]["deploy"]["group"]    = "www-data"
default["posty"]["deploy"]["rack_env"] = "production"
default["posty"]["deploy"]["location"] = "/srv/posty_api"
default["posty"]["deploy"]["github"]   = "https://github.com/posty/posty_api"
default["posty"]["deploy"]["revision"] = "master"

default["posty"]["deploy"]["host"]     = "192.168.254.10"
default["posty"]["deploy"]["webpath"]  = "posty_api"
default["posty"]["webui"]["apiurl"]    = "http://#{default["posty"]["deploy"]["host"]}/#{default["posty"]["deploy"]["webpath"]}/api/v1"

default["posty"]["webui"]["user"]      = "root"
default["posty"]["webui"]["group"]     = "www-data"
default["posty"]["webui"]["location"]  = "/srv/posty_webui"
default["posty"]["webui"]["github"]    = "https://github.com/posty/posty_webui"
default["posty"]["webui"]["revision"]  = "master"

default["posty"]["webui"]["install"]   = true
default["posty"]["webindex"]["install"]= true
default["posty"]["client"]["install"]  = true
