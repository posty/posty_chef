#
# Cookbook Name:: posty
# Recipe:: roundcube
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

# Check if all required attributes are set
if node["posty"]["roundcube"]["dbpass"].to_s.empty?
  Chef::Application.fatal!("You must set a password for the roundcube database user.")
end


Chef::Log.info("[Install roundcube]")
%w{ roundcube roundcube-mysql roundcube-plugins aspell-de }.each do |pkg|
    package pkg
end


Chef::Log.info("[Configure roundcube]")
execute "reconfigure-roundcube" do
  command "dpkg-reconfigure -fnoninteractive roundcube-core"
  action :nothing
end
template "/etc/dbconfig-common/roundcube.conf" do
  source "roundcube/roundcube.conf.erb"
  mode "0600"
  owner "root"
  group "root"
  notifies :run, "execute[reconfigure-roundcube]", :immediately
end
template "/etc/roundcube/main.inc.php" do
  source "roundcube/main.inc.php.erb"
  mode "0640"
  owner "root"
  group "www-data"
  variables(:company_name => node["posty"]["company_name"])
end


Chef::Log.info("[Create the mysql user and tables for roundcube]")
execute "mysql-create-roundcube" do
  command "/usr/bin/mysql -u root -p\"#{node["mysql"]["server_root_password"]}\" < #{node["posty"]["tmp_dir"]}/create-roundcube.sql"
  action :nothing
end
template "#{node["posty"]["tmp_dir"]}/create-roundcube.sql" do
  source "sql/create-roundcube.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, "execute[mysql-create-roundcube]", :immediately
end
execute "import-sql-schema" do
  command "/usr/bin/mysql -u root -p\"#{node["mysql"]["server_root_password"]}\" roundcube < /usr/share/dbconfig-common/data/roundcube/install/mysql && touch #{node["posty"]["var_dir"]}/chef-roundcube-mysql-imported"
  action :run
  creates "#{node["posty"]["var_dir"]}/chef-roundcube-mysql-imported"
end

Chef::Log.info("[Install sieverules plugin]")
git "/usr/share/roundcube/plugins/sieverules" do
  repository "https://github.com/JohnDoh/Roundcube-Plugin-SieveRules-Managesieve.git"
  revision "rc-0.9"
  user "root"
  group "root"
  action :checkout
end
link "/var/lib/roundcube/plugins/sieverules" do
  to "/usr/share/roundcube/plugins/sieverules"
  owner "root"
  group "root"
end
directory "/etc/roundcube/plugins/sieverules" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
template "/etc/roundcube/plugins/sieverules/config.inc.php" do
  source "roundcube/sieverules.conf"
  mode "0644"
  owner "root"
  group "root"
end
link "/usr/share/roundcube/plugins/sieverules/config.inc.php" do
  to "/etc/roundcube/plugins/sieverules/config.inc.php"
  owner "root"
  group "root"
end
directory "/etc/dovecot/sieve" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
template "/etc/dovecot/sieve/example" do
  source "roundcube/example"
  mode "0644"
  owner "root"
  group "root"
end

Chef::Log.info("[Enable roundcube]")
execute "php5-enable-mcrypt" do
  command "php5enmod mcrypt"
  notifies :restart, "service[apache2]"
  only_if { node["platform"] == "ubuntu" and node["platform_version"].to_f >= 13.10 }
end
link "/var/www/roundcube" do
  to "/var/lib/roundcube"
  owner "www-data"
  group "www-data"
end
