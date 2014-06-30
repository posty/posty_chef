Chef::Log.info("[Configure apache]")
for template in [ "000-default.conf",
                  "default-ssl.conf" ] do
  template "/etc/apache2/sites-available/#{template}" do
    source "apache/#{template}"
    owner "root"
    group "root"
    mode "0644"
  end
end
execute "enable-apache2-sites" do
  command "a2ensite 000-default.conf && a2ensite default-ssl.conf"
  action :run
  notifies :restart, "service[apache2]"
end
execute "enable-apache2-ssl" do
  command "a2enmod ssl"
  action :run
  notifies :restart, "service[apache2]"
end
service 'apache2' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end


Chef::Log.info("[Install ruby]")
include_recipe "ruby_build"

ruby_version = node["posty"]["ruby"]["version"]

ruby_build_ruby(ruby_version) { prefix_path "/usr/local" }

bash "update-rubygems" do
  code   "gem update --system"
  not_if "gem list | grep -q rubygems-update"
end
gem_package "bundler"


Chef::Log.info("[Install posty_api]")
package "libmysqlclient-dev"

git node["posty"]["deploy"]["location"] do
  repository node["posty"]["deploy"]["github"]
  revision "master"
  user node["posty"]["deploy"]["username"]
  group node["posty"]["deploy"]["group"]
  action :sync
end

template "#{node["posty"]["deploy"]["location"]}/config/database.yml" do
  source "database.yml.erb"
  owner node["posty"]["deploy"]["username"]
  group node["posty"]["deploy"]["group"]
  mode "0644"
end
