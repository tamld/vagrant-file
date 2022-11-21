HOST_NAME = "ubuntu-gui"
V_NAME = "ubuntu-gui"
IMAGE_NAME = "bento/ubuntu-20.04"
USER_NAME = "vagrant"
USER_PASSWORD = "vagrant"
RAM_SIZE = "8192"
NUMBER_OF_CPU = 8
DISK_SIZE = "20GB"

Vagrant.configure("2") do |config|
  config.disksize.size = DISK_SIZE                                      #Set disk size
  config.vm.hostname = HOST_NAME                                        #Set Computername
  config.ssh.username = USER_NAME
	config.ssh.password = USER_PASSWORD
  # if Vagrant.has_plugin?("vagrant-vbguest") then
  #   config.vbguest.auto_update = false
  # end
  config.vm.provider "virtualbox" do |v|
    v.name = V_NAME                                                     #Set Displayname in Virtualbox GUI
    v.memory = RAM_SIZE                                                 #Set RAM
    v.cpus = NUMBER_OF_CPU                                              #Set CPU
    v.customize ["modifyvm", :id, "--hwvirtex", "on"]                   #Enable hwvirtex
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]        #Enbale natdnshostresolve
    v.customize ['modifyvm', :id, '--clipboard-mode', 'bidirectional']  #Enable clipboard mode copy
    v.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']     #Enable draganddrop option
  end
  config.vm.define HOST_NAME do |h|
		h.vm.hostname = HOST_NAME                                           #Set Displayname in vagrant cmlet   
    h.vm.box = IMAGE_NAME                                               #Set box for VM
  end
  # to make synced folder works.
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Update repositories & upgrade 
  config.vm.provision :shell, inline: "sudo apt update -y && sudo apt -y full-upgrade"

  # Install zsh, p10k themes, plugins
  config.vm.provision :shell, inline: " wget -qO - https://gist.githubusercontent.com/tamld/7be6595bbffe5f9812ee448569c2b09c/raw/install-zsh.sh | bash"

  # Install unattended  Ubuntu / Debian-based Apps
  # config.vm.provision :shell, inline: " wget -qO - https://gist.githubusercontent.com/tamld/9c1f11fcf8932bd8b298ee562118da90/raw/install-Linux-APP.sh | bash"
  
  # Add desktop environment
  config.vm.provision :shell, inline: "sudo apt install -y --no-install-recommends ubuntu-desktop"
  config.vm.provision :shell, inline: "sudo apt install -y --no-install-recommends virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11"

  # Add `vagrant` to Administrator / sudo Group
  config.vm.provision :shell, inline: "sudo usermod -a -G sudo vagrant"

  # Restart
  config.vm.provision :shell, inline: "sudo shutdown -r now"
end