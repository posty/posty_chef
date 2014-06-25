#
# Cookbook Name:: Roundcube
# Recipe:: default
#
# Copyright 2014, postysoft
#
# All rights reserved - Do Not Redistribute
#


package 'roundcube' do
    action :install
end

Chef::Log.info("[Customising: /etc/roundcube/main.inc.php]")
template "/etc/roundcube/main.inc.php" do
  source "main.inc.php"
  mode "0640"
  owner "root"
  group "www-data"
end

execute "create-roundcube-database" do
  command "/usr/bin/mysql -uroot -p'test123' -e 'create database roundcube;'"
  action :run
end

#execute "create-account" do
#  command "/usr/bin/mysql -uroot -p'test123' -e 'GRANT ALL PRIVILEGES ON roundcube . * TO 'roundcube'@'localhost' IDENTIFIED BY 'roundcube';'"
#  action :run
#end

execute "flush-privileges" do
  command "/usr/bin/mysql -uroot -p'test123' -e 'FLUSH PRIVILEGES;' "
  action :run
end

execute "import-sql-schema" do
  command "/usr/bin/mysql -uroot -p'test123' roundcube < /usr/share/dbconfig-common/data/roundcube/install/mysql"
  action :run
end

link "/var/www/roundcube" do
    to "/var/lib/roundcube"
end



