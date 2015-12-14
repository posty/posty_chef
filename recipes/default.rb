#
# Cookbook Name:: posty
# Recipe:: default
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

# Check if all required attributes are set
if node['mysqld']['root_password'].to_s.empty?
  Chef::Application.fatal!("Please set a root password for the mysql database.")
end

package 'bind9' do
  action :purge
end

package 'xinetd' do
  action :purge
end

package 'portmap' do
  action :purge
end

package 'logtail'

include_recipe "apt"
include_recipe "timezone_lwrp"
include_recipe "locale"
include_recipe "mysqld"

execute "generate-dhe-group" do
  command "openssl dhparam -out /etc/ssl/private/dhparams.pem 2048"
  not_if { File.exists?("/etc/ssl/private/dhparams.pem") }
end

include_recipe "posty::unattended-upgrades"
include_recipe "posty::dovecot"
include_recipe "posty::postfix"
#include_recipe "posty::dkim"
include_recipe "posty::posty"
include_recipe "posty::automx"
include_recipe "posty::amavis"
include_recipe "posty::spamassassin"
include_recipe "clamav"
include_recipe "posty::postgrey"

include_recipe "posty::spamhaus" if node["posty"]["spamhaus_blacklist"]["install"]

include_recipe "posty::d-push" if node["posty"]["d-push"]["install"]
include_recipe "posty::roundcube" if node["posty"]["roundcube"]["install"]