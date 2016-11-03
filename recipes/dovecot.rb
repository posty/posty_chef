#
# Cookbook Name:: posty
# Recipe:: dovecot
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

Chef::Log.info("[Create the vmail database user]")
execute "mysql-create-vmail" do
  command "/usr/bin/mysql -u root -p\"#{node["mysqld"]["root_password"]}\" < #{node["posty"]["tmp_dir"]}/create-vmail.sql"
  action :nothing
end
template "#{node["posty"]["tmp_dir"]}/create-vmail.sql" do
  source "sql/create-vmail.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, "execute[mysql-create-vmail]", :immediately
  notifies :restart, "service[dovecot]"
  notifies :restart, "service[postfix]"
end

Chef::Log.info("[Creating the vmail user]")
group "vmail" do
  gid 5000
end
user "vmail" do
  uid 5000
  gid 5000
  home "/srv/vmail"
  shell "/bin/false"
end
directory "/srv/vmail" do
  owner "vmail"
  group "vmail"
  mode "770"
end
link "/var/vmail" do
  to "/srv/vmail"
  owner "vmail"
  group "vmail"
end

Chef::Log.info("[Install dovecot]")
%w{ dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-managesieved dovecot-sieve dovecot-mysql  }.each do |pkg|
  package pkg
end


Chef::Log.info("[Configure dovecot]")
template "/etc/dovecot/dovecot.conf" do
  source "dovecot/dovecot.conf"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[dovecot]"
end
template "/etc/dovecot/dovecot-sql.conf.ext" do
  source "dovecot/dovecot-sql.conf.ext"
  owner "root"
  group "dovecot"
  mode "0640"
  notifies :restart, "service[dovecot]"
end
template "/etc/dovecot/quota-exceeded.txt" do
  source "dovecot/quota-exceeded.txt"
  owner "root"
  group "root"
  mode "0644"
end
template "/etc/dovecot/quota-warning.sh" do
  source "dovecot/quota-warning.sh"
  owner "root"
  group "root"
  mode "0655"
  variables(:domain => node["posty"]["mail"]["domain"])
end
%w{ 10-auth.conf 10-mail.conf 10-master.conf 10-ssl.conf 10-logging.conf 15-lda.conf 15-mailboxes.conf 20-imap.conf 20-lmtp.conf 20-managesieve.conf 90-plugin.conf 90-quota.conf 90-sieve.conf 90-acl.conf auth-sql.conf.ext }.each do |template|
  template "/etc/dovecot/conf.d/#{template}" do
    source "dovecot/conf.d/#{template}"
    owner "root"
    group "root"
    mode "0644"
    variables(:master_user => node["posty"]["mail"]["master_user"], :cpu_cores => node["cpu"]["total"], :certificate_name => node["posty"]["certificate_name"])
    notifies :restart, "service[dovecot]"
    notifies :restart, "service[postfix]"
  end
end

Chef::Log.info("[Create Shared Dictionary Folder]")
directory "/var/lib/dovecot/db" do
  owner 'vmail'
  group 'vmail'
  mode '0755'
  action :create
end

Chef::Log.info("[Increase inotify max_user_instances]")
execute "increse inotify max_user_instances" do
  command "echo 'fs.inotify.max_user_instances=8192' >> /etc/sysctl.conf"
  not_if "grep 'fs.inotify.max_user_instances' /etc/sysctl.conf"
end

if node["posty"]["mail"]["master_user"]
  user = node["posty"]["mail"]["master_user"]
  pass = secure_password(14)
  
  template "/etc/dovecot/master-users" do
    source "dovecot/master-users"
    owner "root"
    group "dovecot"
    mode "0640"
    variables(
        :user => user,
        :pass => pass
    )
    notifies :restart, "service[dovecot]"
    not_if { File.exists?("/etc/dovecot/master-users") }
  end
else
  file "/etc/dovecot/master-users" do
    action :delete
    only_if { File.exists?("/etc/dovecot/master-users") }
  end
end

Chef::Log.info("[Create weekly Dovecot-Purge cronjob]")
template "/etc/cron.weekly/dovecot-purge" do
  source "dovecot/dovecot-purge"
  owner "root"
  group "root"
  mode "0755"
end

Chef::Log.info("[Start dovecot]")
service 'dovecot' do
  supports :restart => true, :reload => true, :status => true
  if node["platform"] == "ubuntu" and node["platform_version"].to_f >= 13.10
    provider Chef::Provider::Service::Upstart
  end
  action [:enable, :start]
end