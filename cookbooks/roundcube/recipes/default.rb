#
# Cookbook Name:: Roundcube
# Recipe:: default
#
# Copyright 2014, postysoft
#
# All rights reserved - Do Not Redistribute
#

# Check if all required attributes are set
if node['roundcube']['db']['password'].empty?
  Chef::Application.fatal!("You must set a password for the roundcube database user.")
end


Chef::Log.info("[Install roundcube]")
%w{ roundcube roundcube-mysql }.each do |pkg|
    package pkg
end


Chef::Log.info("[Configure roundcube]")
execute "reconfigure-roundcube" do
  command "dpkg-reconfigure -fnoninteractive roundcube-core"
  action :nothing
end
template "/etc/dbconfig-common/roundcube.conf" do
  source "roundcube.conf.erb"
  mode "0600"
  owner "root"
  group "root"
  notifies :run, "execute[reconfigure-roundcube]", :immediately
end
template "/etc/roundcube/main.inc.php" do
  source "main.inc.php"
  mode "0640"
  owner "root"
  group "www-data"
end


Chef::Log.info("[Create the mysql user and tables for roundcube]")
execute "mysql-create-roundcube" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['roundcube']['conf_dir']}/create-roundcube.sql"
  action :nothing
end
template "#{node['roundcube']['conf_dir']}/create-roundcube.sql" do
  source "sql/create-roundcube.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, "execute[mysql-create-roundcube]", :immediately
end

execute "import-sql-schema" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" roundcube < /usr/share/dbconfig-common/data/roundcube/install/mysql && touch /etc/xchef-roundcube-mysql-imported"
  action :run
  not_if {File.exists?("/etc/xchef-roundcube-mysql-imported")}
end

link "/var/www/roundcube" do
    to "/var/lib/roundcube"
end


Chef::Log.info("[Configure apache]")
for template in [ "000-default.conf",
                  "default-ssl.conf" ] do
  template "/etc/apache2/sites-available/#{template}" do
    source "apache/#{template}"
    owner "root"
    group "root"
    mode "0644"
  end
end
execute "enable-apache2-sites" do
  command "a2ensite 000-default.conf && a2ensite default-ssl.conf"
  action :run
  notifies :restart, "service[apache2]"
end
execute "enable-apache2-ssl" do
  command "a2enmod ssl"
  action :run
  notifies :restart, "service[apache2]"
end
service 'apache2' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
