#
# Cookbook Name:: posty
# Recipe:: spamhaus
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

template "/etc/cron.daily/spamhaus" do
  source "spamhaus/spamhaus.sh"
  owner "root"
  group "root"
  mode "0755"
  notifies :run, "execute[spamhaus]", :immediately
end

execute "spamhaus" do
  command "/etc/cron.daily/spamhaus"
  action :nothing
end