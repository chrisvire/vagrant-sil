# -*- mode: ruby -*-
# vi: set ft=ruby :

$hostname_prefix = ENV['VAGRANT_HOSTNAME_PREFIX']
pref_interface = ENV.fetch('VAGRANT_PREF_INTERFACE', "eth0,eth1,eth2,wlan0,en0,en1,en2").split(/,/)
bridgedifs_text = %x( VBoxManage list bridgedifs ).split(/^$/)
bridgedifs_text.pop #last item is always a blank entry
bridgedifs = {}
bridgedifs_text.each do |bif_text|
  bif = {}
  bif_text.lines.each do |l|
    values = l.chomp.split(/:\s+/,2)
    bif[values[0]] = values[1] unless values[0].nil?
  end
  unless bif["IPAddress"] == "0.0.0.0" || bif["IPV6Address"].nil?
      bridgedifs[bif['Name']] = bif
    # On Mac, the name is "en0: Ethernet"
    # This will allow it to work with "en0" or "en0: Ethernet"
    name = bif['Name'].split(/:/)[0]
    bridgedifs[name] = bif
  end
end


# http://stackoverflow.com/a/17729961/35577
pref_interface = pref_interface.map {|n| bridgedifs[n]['Name'] if bridgedifs.has_key?(n)}.compact
$network_interface=pref_interface[0]

# On Windows, vagrant-cachier is not handling the apt_lists caching correctly.
# So do not make it required for now.
required_plugins = ["vagrant-vbguest"]
unless (missing_plugins = required_plugins.select { |p| !Vagrant.has_plugin?(p) }).empty?
  raise "\nBefore you can 'vagrant up' this box, please install these plugins\n  " +
        missing_plugins.join("\n  ") +
        "\nTypically this is done by running\n" +
        "  'vagrant plugin install <plugin>'\nfor each plugin"
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Vagrant didn't recogize Wasta (based on Linux Mint) so bridge network didn't work.
# https://github.com/mitchellh/vagrant/issues/3648 (found in 1.5.4, fixed in 1.6.1)
Vagrant.require_version ">=1.6.1"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  def bootstrap(config, name, options = {})
    options = {:gui => true, :bridge => true}.merge(options)

    { "#{Dir.home}" => '/home/vagrant/host',
      "#{Dir.home}/pbuilder" => '/home/vagrant/pbuilder',
	  "./scripts" => '/home/vagrant/.scripts'
    }
    .select { |host_dir,_| File.directory?(host_dir) }
    .each { |host_dir, vm_dir| config.vm.synced_folder host_dir, vm_dir }

    config.vm.hostname = "#{$hostname_prefix}-#{name}" unless $hostname_prefix.nil?
    config.vm.provider :virtualbox do |vb|
      vb.gui=options[:gui]
      vb.name="vagrant-sil-#{name}"
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    end

    # add public network adapter
    config.vm.network :public_network, :bridge=> $network_interface if options[:bridge]

    if Vagrant.has_plugin?("vagrant-cachier")
      # vagrant-cachier setting
      config.cache.scope = :box
    end
  end

  [
# Google Drive is not accessible anymore.
# I will be migrating the files to a permanent home.
#    'precise64',
#    'precise32',
    'trusty64',
    'trusty32',
    'xenial64',
    'xenial32',
#    'wasta64-14',
#    'wasta32-14',
#    'wasta64-12',
#    'wasta32-12'
  ]
  .each do |name, box_name|
    config.vm.define name do |b|
      # The boxes are configured/versioned at https://vagrantcloud.com/chrisvire
      # See chris_hubbard@sil.org for more information/help
      b.vm.box="chrisvire/#{box_name || name}"
      bootstrap b, name
    end
  end

end
