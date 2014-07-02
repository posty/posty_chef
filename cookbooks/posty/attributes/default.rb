default["posty"]["ruby"]["version"] = "2.0.0-p481"

default["posty"]["db"]["host"]     = "localhost"
default["posty"]["db"]["name"]     = node['postfix-dovecot']['db']['dbname']
default["posty"]["db"]["username"] = node['postfix-dovecot']['db']['username']
default["posty"]["db"]["password"] = node['postfix-dovecot']['db']['password']
default["posty"]["db"]["socket"]   = "/var/run/mysqld/mysqld.sock"

default["posty"]["deploy"]["user"]     = "root"
default["posty"]["deploy"]["group"]    = "www-data"
default["posty"]["deploy"]["rack_env"] = "production"
default["posty"]["deploy"]["location"] = "/srv/posty_api"
default["posty"]["deploy"]["github"]   = "https://github.com/posty/posty_api"
default["posty"]["deploy"]["revision"] = "master"

default["posty"]["deploy"]["host"]     = "192.168.246.10"
default["posty"]["deploy"]["webpath"]  = "posty_api"
default["posty"]["webui"]["apiurl"]    = "http://#{default["posty"]["deploy"]["host"]}/#{default["posty"]["deploy"]["webpath"]}/api/v1"

default["posty"]["webui"]["install"]   = true
default["posty"]["webui"]["user"]      = "root"
default["posty"]["webui"]["group"]     = "www-data"
default["posty"]["webui"]["location"]  = "/srv/posty_webui"
default["posty"]["webui"]["github"]    = "https://github.com/posty/posty_webui"
default["posty"]["webui"]["revision"]  = "master"

