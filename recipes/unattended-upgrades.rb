#
# Cookbook Name:: posty
# Recipe:: unattended-upgrades
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

Chef::Log.info("[Install unattended-upgrades]")
package "mailutils"

package "unattended-upgrades"

execute "ensure /etc/cron.daily/apt exists" do
  command "mv /etc/cron.daily/apt.disabled /etc/cron.daily/apt"
  only_if { File.exists?("/etc/cron.daily/apt.disabled") }
  not_if { File.exists?("/etc/cron.daily/apt") }
end

template "/etc/apt/apt.conf.d/50unattended-upgrades" do
  source "unattended-upgrades/50unattended-upgrades"
  owner "root"
  group "root"
  mode "644"
end