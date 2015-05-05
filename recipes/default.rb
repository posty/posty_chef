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
if node["mysql"]["server_root_password"].to_s.empty?
  Chef::Application.fatal!("Please set a root password for the mysql database.")
end

include_recipe "apt"
include_recipe "mysql::server"

include_recipe "posty::postfix-dovecot"
include_recipe "posty::posty"
include_recipe "posty::automx"

include_recipe "posty::d-push" if node["posty"]["d-push"]["install"]
include_recipe "clamav" if node["posty"]["clamav"]["install"]
include_recipe "posty::spamassassin" if node["posty"]["spamassassin"]["install"]
include_recipe "posty::roundcube" if node["posty"]["roundcube"]["install"]
