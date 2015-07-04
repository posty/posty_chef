#
# Cookbook Name:: posty
# Recipe:: postfix
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

# Check if all required attributes are set
if node["posty"]["db"]["dbpass"].to_s.empty?
  Chef::Application.fatal!("You must set a password for the vmail database user.")
end

Chef::Log.info("[Create .forward file for forwarding local root emails]")
template "/root/.forward" do
  source "forward"
  owner "root"
  group "root"
  mode "0600"
  variables(:administrator_email_address => "postmaster@" + node["posty"]["mail"]["domain"])
end

Chef::Log.info("[Install postfix]")
%w{ postfix postfix-mysql }.each do |pkg|
  package pkg
end


Chef::Log.info("[Configure postfix]")
%w( master.cf main.cf ).each do |template|
  template "/etc/postfix/#{template}" do
    source "postfix/#{template}"
    owner "root"
    group "root"
    mode "0644"
    variables(:certificate_name => node["posty"]["certificate_name"])
    notifies :restart, "service[dovecot]"
    notifies :restart, "service[postfix]"
  end
end
directory "/etc/postfix/virtual" do
  owner "root"
  group "postfix"
  mode "0750"
  action :create
end
%w{ mysql-virtual-domain-aliases.cf mysql-virtual-mailbox-domains.cf mysql-virtual-mailbox-maps.cf mysql-virtual-transports.cf mysql-virtual-user-aliases.cf }.each do |template|
  template "/etc/postfix/virtual/#{template}" do
    source "postfix/virtual/#{template}"
    owner "root"
    group "postfix"
    mode "0640"
    notifies :restart, "service[postfix]"
  end
end

Chef::Log.info("[Start postfix]")
service 'postfix' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end