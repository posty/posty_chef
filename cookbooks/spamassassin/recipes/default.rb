Chef::Log.info("[Installing spamassassin and spamc]")
package 'spamassassin spamc'

Chef::Log.info("[Configuring spamassassin cronjob]")
template "/etc/cron.daily/spamassassin" do
  source "cron.daily.erb"
  mode "0755"
  owner "root"
  group "root"
end


Chef::Log.info("[Configuring spamassassin]")
template "/etc/default/spamassassin" do
  source "default.erb"
  mode "0644"
  owner "root"
  group "root"
end
template "/etc/spamassassin/local.cf" do
  source "local.cf.erb"
  mode "0644"
  owner "root"
  group "root"
end

Chef::Log.info("[Creating user debian-spamd]")
user "debian-spamd" do
  home "/var/lib/spamassassin"
  shell "/bin/false"
end

Chef::Log.info("[Updating spamassassin rules]")
execute "update" do
  command "sa-update && sa-update --nogpg --channel spamassassin.heinlein-support.de"
  user "root"
  returns [0,1,2,3,4]
end

Chef::Log.info("[Enabling spamd]")
service "spamassassin" do
  action [:enable, :start]
end
