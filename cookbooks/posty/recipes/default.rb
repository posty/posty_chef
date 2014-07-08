#
# Cookbook Name:: posty
# Recipe:: default
#
# Copyright 2014, posty-soft
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"
include_recipe "mysql::server"
include_recipe "clamav-chef"
include_recipe "posty::postfix-dovecot"
include_recipe "posty::posty"
include_recipe "posty::spamassassin"
include_recipe "posty::roundcube"
