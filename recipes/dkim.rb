#
# Cookbook Name:: posty
# Recipe:: dkim
#
# Copyright 2015, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

Chef::Log.info("[Install D-Push]")
package "opendkim opendkim-tools"

directory "/etc/opendkim" do
  owner 'opendkim'
  group 'opendkim'
  mode '0700'
  action :create
end

group "opendkim" do
  action :modify
  members "postfix"
  append true
end

template "/etc/opendkim/TrustedHosts" do
  source "dkim/TrustedHosts"
  owner "opendkim"
  group "opendkim"
  mode "0644"
  notifies :restart, "service[opendkim]"
end

unless File.exists?("/etc/opendkim/dkim.key")
  hostname_with_time = node["hostname"] + "-" + Time.now.to_i.to_s
  fqdn_domain_part = node["fqdn"].gsub(node["hostname"] + '.', '')
  selector = hostname_with_time + "._domainkey." + fqdn_domain_part

  template "/etc/opendkim/dkim-keytable" do
    source "dkim/dkim-keytable"
    owner "opendkim"
    group "opendkim"
    mode "0644"
    variables(:hostname_with_time => hostname_with_time, :fqdn_domain_part => fqdn_domain_part, :selector => selector)
    notifies :restart, "service[opendkim]"
  end
  
  template "/etc/opendkim/dkim-signingtable" do
    source "dkim/dkim-signingtable"
    owner "opendkim"
    group "opendkim"
    mode "0644"
    variables(:selector => selector)
    notifies :restart, "service[opendkim]"
  end
  
  template "/etc/opendkim.conf" do
    source "dkim/opendkim.conf"
    owner "root"
    group "root"
    mode "0644"
    variables(:selector => selector)
    notifies :restart, "service[opendkim]"
  end
  
  execute "Generate Key" do
    command "openssl genrsa -out /etc/opendkim/dkim.key 2048;openssl rsa -in /etc/opendkim/dkim.key -out /etc/opendkim/dkim.public -pubout -outform PEM;chown opendkim:opendkim /etc/opendkim/dkim.*;chmod 0600 /etc/opendkim/dkim.*"
  end
end

service 'opendkim' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end