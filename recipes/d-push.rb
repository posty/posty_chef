#
# Cookbook Name:: posty
# Recipe:: d-push
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

Chef::Log.info("[Install D-Push]")
package "d-push php5-imap"

execute "enable-php-imap" do
  command "php5enmod imap"
  notifies :restart, "service[apache2]"
end

template "/etc/apache2/conf-available/d-push.conf" do
  source "d-push/apache.conf"
  owner "root"
  group "root"
  mode "0644"
end
execute "enable-dpush-conf" do
  command "a2enconf d-push.conf"
  notifies :restart, "service[apache2]"
end

template "/etc/d-push/config.php" do
  source "d-push/config.php"
  owner "root"
  group "root"
  mode "0644"
end

%w( z-push-admin.php z-push-top.php ).each do |file|
  link "/root/#{file}" do
    to "/usr/share/d-push/#{file}"
    owner "root"
    group "root"
  end
end