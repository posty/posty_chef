# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use a minimal ubuntu 14.04 image as base system
  config.vm.box = "chef/ubuntu-14.04"
  config.vm.hostname = "posty-chef"

  # Use vagrant-omnibus to install chef on the VM
  config.omnibus.chef_version = :latest

  # Use vagrant-berkshelf for cookbook management
  config.berkshelf.enabled = true

  # All services will be available under this local IP
  config.vm.network :private_network, ip: "192.168.254.10"

  # Improve performance of the VM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "768"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision "chef_solo", run: "always" do |chef|
    json = "config/posty.json"
    if File.exists?(json)
      config = JSON.parse(File.read(json))
      config.delete("run_list")
      chef.json.merge!(config)
    end

    chef.add_recipe "posty"
  end
end
