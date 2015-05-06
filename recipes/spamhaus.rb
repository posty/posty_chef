#
# Cookbook Name:: posty
# Recipe:: automx
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

template "/etc/cron.daily/spamhaus" do
  source "spamhaus/spamhaus.sh"
  owner "root"
  group "root"
  mode "0755"
end