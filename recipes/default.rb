#
# Cookbook Name:: posty
# Recipe:: default
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

# Check if all required attributes are set
if !node["mysql"]["server_root_password"] or node["mysql"]["server_root_password"].empty?
  Chef::Application.fatal!("Please set a root password for the mysql database.")
end

include_recipe "apt"
include_recipe "mysql::server"
include_recipe "clamav"

include_recipe "posty::postfix-dovecot"
include_recipe "posty::posty"
include_recipe "posty::roundcube"
include_recipe "posty::spamassassin"
