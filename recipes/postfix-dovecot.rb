#
# Cookbook Name:: posty
# Recipe:: postfix-dovecot
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

# Check if all required attributes are set
if node["posty"]["db"]["dbpass"].to_s.empty?
  Chef::Application.fatal!("You must set a password for the vmail database user.")
end


Chef::Log.info("[Create the vmail database user]")
execute "mysql-create-vmail" do
  command "/usr/bin/mysql -u root -p\"#{node["mysql"]["server_root_password"]}\" < #{node["posty"]["tmp_dir"]}/create-vmail.sql"
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
  home "/var/vmail"
  shell "/bin/false"
end
directory "/var/vmail" do
  owner "vmail"
  group "vmail"
  mode "770"
end


Chef::Log.info("[Install dovecot]")
%w{ dovecot-core dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-lmtpd }.each do |pkg|
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
for template in [ "10-auth.conf",
                  "10-mail.conf",
                  "10-master.conf",
                  "10-ssl.conf",
                  "15-lda.conf",
                  "auth-sql.conf.ext" ] do
  template "/etc/dovecot/conf.d/#{template}" do
    source "dovecot/conf.d/#{template}"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[dovecot]"
    notifies :restart, "service[postfix]"
  end
end


Chef::Log.info("[Install postfix]")
%w{ postfix postfix-mysql }.each do |pkg|
  package pkg
end


Chef::Log.info("[Configure postfix]")
for template in [ "master.cf", "main.cf" ] do
  template "/etc/postfix/#{template}" do
    source "postfix/#{template}"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[dovecot]"
    notifies :restart, "service[postfix]"
  end
end
directory "/etc/postfix/virtual" do
  owner "root"
  group "root"
  mode "0664"
  action :create
end
for template in [ "mysql-virtual-domain-aliases.cf",
                  "mysql-virtual-mailbox-domains.cf",
                  "mysql-virtual-mailbox-maps.cf",
                  "mysql-virtual-transports.cf",
                  "mysql-virtual-user-aliases.cf" ] do
  template "/etc/postfix/virtual/#{template}" do
    source "postfix/virtual/#{template}"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[postfix]"
  end
end

template "/usr/bin/mail-scanner.sh" do
  source "postfix/mail-scanner.sh"
  owner "root"
  group "root"
  mode "0755"
  only_if { node["posty"]["clamav"]["install"] || node["posty"]["spamassassin"]["install"] }
  notifies :restart, "service[postfix]"
end


Chef::Log.info("[Start postfix and dovecot]")
service 'postfix' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
service 'dovecot' do
  supports :restart => true, :reload => true, :status => true
  if node["platform"] == "ubuntu" and node["platform_version"].to_f >= 13.10
    provider Chef::Provider::Service::Upstart
  end
  action [:enable, :start]
end
