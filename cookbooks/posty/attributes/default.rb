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
