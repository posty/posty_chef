#
# Cookbook Name:: posty
# Recipe:: default
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

include_recipe "apt"
include_recipe "mysql::server"

include_recipe "clamav-chef"

include_recipe "posty::postfix-dovecot"
include_recipe "posty::posty"
include_recipe "posty::roundcube"
include_recipe "posty::spamassassin"
