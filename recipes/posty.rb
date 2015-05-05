#
# Cookbook Name:: posty
# Recipe:: posty
#
# Copyright 2014, posty-soft.org
#
# Licensed under the LGPL v3
# https://www.gnu.org/licenses/lgpl.html
#

Chef::Log.info("[Install ruby]")
include_recipe "ruby_build"

ruby_version = node["posty"]["ruby"]["version"]

ruby_build_ruby(ruby_version) { prefix_path "/usr/local" }

execute "update-rubygems" do
  command "/usr/local/bin/gem update --system"
  not_if "/usr/local/bin/gem list | grep -q rubygems-update"
end
execute "install-bundler" do
  command "/usr/local/bin/gem install bundler"
  not_if "/usr/local/bin/gem list | grep -q bundler"
end


Chef::Log.info("[Install apache]")
package "apache2 apache2-utils"
service 'apache2' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
execute "enable-apache2-ssl" do
  command "a2enmod ssl"
  notifies :restart, "service[apache2]"
end


Chef::Log.info("[Install passenger]")
gem_package "passenger"
%w{ libcurl4-openssl-dev apache2-threaded-dev libapr1-dev libaprutil1-dev}.each do |pkg|
  package pkg
end
execute "disable-apache2-sites" do
  command "ls /etc/apache2/sites-enabled | xargs -r a2dissite"
  not_if "test -e `passenger-install-apache2-module --snippet | head -n1 | cut -d' ' -f3`"
  notifies :restart, "service[apache2]"
end
execute "passenger-module-compile" do
  command "passenger-install-apache2-module --auto --languages ruby"
  not_if "test -e `passenger-install-apache2-module --snippet | head -n1 | cut -d' ' -f3`"
end
execute "passenger-module-apache-load" do
  command "passenger-install-apache2-module --snippet | head -n1 > /etc/apache2/mods-available/passenger.load"
  creates "/etc/apache2/mods-available/passenger.load"
end
execute "passenger-module-apache-conf" do
  command "passenger-install-apache2-module --snippet | tail -n+2 > /etc/apache2/mods-available/passenger.conf"
  creates "/etc/apache2/mods-available/passenger.conf"
end
execute "passenger-module-apache-enable" do
  command "a2enmod passenger"
  notifies :restart, "service[apache2]"
end


Chef::Log.info("[Configure apache]")
template "/etc/apache2/sites-available/default-ssl.conf" do
  source "apache/default-ssl.conf"
  owner "root"
  group "root"
  mode "0644"
  variables(:server => node["posty"]["mail"]["hostname"])
end
execute "enable-apache2-sites" do
  command "a2ensite default-ssl.conf"
  notifies :restart, "service[apache2]"
end
template "/etc/apache2/ports.conf" do
  source "apache/ports.conf"
  owner "root"
  group "root"
  mode "0644"
end

Chef::Log.info("[Install posty_api]")
package "libmysqlclient-dev"

git node["posty"]["api"]["location"] do
  repository node["posty"]["api"]["github"]
  revision node["posty"]["api"]["revision"]
  user node["posty"]["api"]["user"]
  group node["posty"]["api"]["group"]
  action :sync
end
template "#{node["posty"]["api"]["location"]}/config/database.yml" do
  source "posty/database.yml.erb"
  owner node["posty"]["api"]["user"]
  group node["posty"]["api"]["group"]
  mode "0644"
end

execute "bundle install" do
  cwd node["posty"]["api"]["location"]
  not_if 'bundle check', :cwd => node["posty"]["api"]["location"]
end
execute "rake db:migrate" do
  cwd node["posty"]["api"]["location"]
  environment ({'RACK_ENV' => node["posty"]["api"]["rack_env"]})
end
execute "rake api_key:generate" do
  cwd node["posty"]["api"]["location"]
  environment ({'RACK_ENV' => node["posty"]["api"]["rack_env"]})
  not_if "echo ApiKey.first.access_token | RACK_ENV=production bundle exec racksh | egrep -q -o [0-9a-z]{32}",
    :cwd => node["posty"]["api"]["location"]
end


if node["posty"]["webui"]["install"]
  Chef::Log.info("[Install posty_webui]")
  git node["posty"]["webui"]["location"] do
    repository node["posty"]["webui"]["github"]
    revision node["posty"]["webui"]["revision"]
    user node["posty"]["webui"]["user"]
    group node["posty"]["webui"]["group"]
    action :sync
  end
  link "/var/www/posty_webui" do
    to "/srv/posty_webui/dist"
    owner "www-data"
    group "www-data"
  end
  template "#{node["posty"]["webui"]["location"]}/dist/settings.json" do
    source "posty/settings.json.erb"
    variables lazy {{ :apikey => `cd #{node["posty"]["api"]["location"]} &&
                      echo ApiKey.first.access_token | RACK_ENV=production bundle exec racksh | egrep -o [0-9a-z]{32} | tr -d '\n'` }}
    owner node["posty"]["webui"]["user"]
    group node["posty"]["webui"]["group"]
    mode "0644"
  end
  template "/var/www/posty_webui/.htaccess" do
    source "posty/posty_webui_htaccess"
  end
  execute "Create htpasswd" do
    command "htpasswd -dbc /var/www/posty_webui/.htpasswd #{node["posty"]["webui"]["htaccess_user"]} #{node["posty"]["webui"]["htaccess_pass"]}"
    not_if { File.exists?("/var/www/posty_webui/.htpasswd") }
  end
end


if node["posty"]["client"]["install"]
  Chef::Log.info("[Install posty_client]")
  execute "install-posty_client" do
    command "/usr/local/bin/gem install posty_client"
    not_if "/usr/local/bin/gem list | grep -q posty_client"
  end
  template node["posty"]["client"]["configpath"] do
    source "posty/posty_client.yml.erb"
    variables lazy {{ :apikey => `cd #{node["posty"]["api"]["location"]} &&
                      echo ApiKey.first.access_token | RACK_ENV=production bundle exec racksh | egrep -o [0-9a-z]{32} | tr -d '\n'` }}
    owner node["posty"]["client"]["user"]
    group node["posty"]["client"]["group"]
    mode "0644"
  end
end


if node["posty"]["webindex"]["install"]
  Chef::Log.info("[Add webindex]")
  template "/var/www/index.html" do
    source "posty/index.html"
    owner "www-data"
    group "www-data"
    mode "0644"
  end
  directory "/var/www/img" do
    owner "www-data"
    group "www-data"
    mode "0755"
  end
  
  %w( roundcube.png posty.png automx.png ).each do |file|
    cookbook_file "/var/www/img/#{file}" do
      source "img/#{file}"
      owner "www-data"
      group "www-data"
      mode "0644"
    end
  end
end
