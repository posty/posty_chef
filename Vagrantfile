# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use a minimal ubuntu 14.04 image as base system
  config.vm.box = "chef/ubuntu-14.04"
  config.vm.hostname = "posty-chef"

  # Use vagrant-omnibus to install chef on the VM
  config.omnibus.chef_version = :latest

  # All services will be available under this local IP
  config.vm.network :private_network, ip: "192.168.246.10"

  # Improve performance of the VM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision "chef_solo", run: "always" do |chef|
    # External recipes required
    chef.add_recipe "apt"
    chef.add_recipe "mysql::server"
    chef.add_recipe "ruby_build"
    chef.add_recipe "clamav-chef"

    # Own recipes
    chef.add_recipe "postfix-dovecot"
    chef.add_recipe "posty"
    chef.add_recipe "spamassassin"

    # Minimal required configuration
    chef.json = {
      "mysql" => {
        "server_root_password" => "SETYOURPASSWORDHERE"
      },
      "postfix-dovecot" => {
        "db" => {
          "password" => "SETYOURPASSWORDHERE"
        },
        "demo" => {
          "password" => "SETYOURPASSWORDHERE"
        }
      }
    }
  end
end
