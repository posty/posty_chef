#
# Cookbook Name:: posty
# Recipe:: amavis
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

Chef::Log.info("[Install Amavis]")
package "amavisd-new clamav-daemon clamav-freshclam spamassassin libnet-dns-perl libmail-spf-perl pyzor razor arj bzip2 cabextract cpio file gzip lhasa nomarch pax unrar unzip zip zoo"

group "clamav" do
  action :modify
  members "amavis"
  append true
end

group "amavis" do
  action :modify
  members "clamav"
  append true
end

directory "/var/lib/amavis/.razor" do
  owner 'amavis'
  group 'amavis'
  mode '0700'
  action :create
end

execute "razor/pyzor" do
  command "pyzor discover;razor-admin -home=/var/lib/amavis/.razor -register;razor-admin -home=/var/lib/amavis/.razor -create;razor-admin -home=/var/lib/amavis/.razor -discover"
  not_if { File.exists?("/var/lib/amavis/.razor/razor-agent.conf") }
end

template "/etc/amavis/conf.d/50-user" do
  source "amavis/50-user"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[amavis]"
end

service 'amavis' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end