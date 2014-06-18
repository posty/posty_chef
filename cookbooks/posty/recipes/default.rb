#Chef::Log.info("[Creating the posty user]")
#user "posty" do
#  supports :manage_home => true
#end

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
