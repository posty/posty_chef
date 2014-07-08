Chef::Log.info("[Install ruby]")
include_recipe "ruby_build"

ruby_version = node["posty"]["ruby"]["version"]

ruby_build_ruby(ruby_version) { prefix_path "/usr/local" }

bash "update-rubygems" do
  code   "gem update --system"
  not_if "gem list | grep -q rubygems-update"
end
gem_package "bundler"


Chef::Log.info("[Install apache]")
package "apache2"
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
  notifies :restart, "service[apache2]"
end


Chef::Log.info("[Install posty_api]")
package "libmysqlclient-dev"

git node["posty"]["deploy"]["location"] do
  repository node["posty"]["deploy"]["github"]
  revision node["posty"]["deploy"]["revision"]
  user node["posty"]["deploy"]["user"]
  group node["posty"]["deploy"]["group"]
  action :sync
end
template "#{node["posty"]["deploy"]["location"]}/config/database.yml" do
  source "posty/database.yml.erb"
  owner node["posty"]["deploy"]["user"]
  group node["posty"]["deploy"]["group"]
  mode "0644"
end

execute "bundle install" do
  cwd node["posty"]["deploy"]["location"]
  not_if 'bundle check', :cwd => node["posty"]["deploy"]["location"]
end
execute "rake db:migrate" do
  cwd node["posty"]["deploy"]["location"]
  environment ({'RACK_ENV' => node["posty"]["deploy"]["rack_env"]})
end
execute "rake api_key:generate" do
  cwd node["posty"]["deploy"]["location"]
  environment ({'RACK_ENV' => node["posty"]["deploy"]["rack_env"]})
end


Chef::Log.info("[Install posty_webui]")
if node["posty"]["webui"]["install"] == true
  git node["posty"]["webui"]["location"] do
    repository node["posty"]["webui"]["github"]
    revision node["posty"]["webui"]["revision"]
    user node["posty"]["webui"]["user"]
    group node["posty"]["webui"]["group"]
    action :sync
  end
  link "/var/www/posty_webui" do
    to "/srv/posty_webui/dist"
  end
  template "#{node["posty"]["webui"]["location"]}/dist/settings.json" do
    source "posty/settings.json.erb"
    variables lazy {{ :apikey => `cd #{node["posty"]["deploy"]["location"]} &&
                      echo ApiKey.first.access_token | RACK_ENV=production racksh | egrep -o [0-9a-z]{32} | tr -d '\n'` }}
    owner node["posty"]["webui"]["user"]
    group node["posty"]["webui"]["group"]
    mode "0644"
  end
end
