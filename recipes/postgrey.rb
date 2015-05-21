#
# Cookbook Name:: posty
# Recipe:: amavis
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

Chef::Log.info("[Install Postgrey]")
package "postgrey"

template "/etc/default/postgrey" do
  source "postgrey/default"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[postgrey]"
end

service 'postgrey' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end