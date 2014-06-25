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


Chef::Log.info("[Create the vmail database user]")
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
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" roundcube < /usr/share/dbconfig-common/data/roundcube/install/mysql"
  action :run
end



link "/var/www/roundcube" do
    to "/var/lib/roundcube"
end



