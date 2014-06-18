default["posty"]["ruby"]["version"] = "1.9.3-p547"

default["posty"]["db"]["host"]      = "localhost"
default["posty"]["db"]["name"]      = node['postfix-dovecot']['db']['dbname']
default["posty"]["db"]["username"]  = node['postfix-dovecot']['db']['username']
default["posty"]["db"]["password"]  = node['postfix-dovecot']['db']['password']
default["posty"]["db"]["socket"]    = "/var/run/mysqld/mysqld.sock"
default["posty"]["db"]["rails_env"] = "production"

default["posty"]["deploy"]["username"] = "vagrant"
default["posty"]["deploy"]["group"]    = "vagrant"
default["posty"]["deploy"]["app_name"] = "posty_api"
default["posty"]["deploy"]["location"] = "/home/#{node["posty"]["deploy"]["username"]}/#{node["posty"]["deploy"]["app_name"]}"
default["posty"]["deploy"]["github"]   = "https://github.com/posty/posty_api"
