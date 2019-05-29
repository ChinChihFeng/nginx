Vagrant.configure(2) do |config|

  config.vm.box = "geerlingguy/centos7"
  config.ssh.insert_key = false
  #config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
  #config.vm.provision "shell", inline: <<-EOC
  #  sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
  #  sudo systemctl restart sshd
  #EOC

  config.vm.provider :virtualbox do |vitual|
     vitual.gui = false
     vitual.memory = 512
     vitual.cpus = 2
  end

  #config.vm.provision "ansible" do |ansible|
  #   ansible.verbose = "v"
  #   ansible.inventory_path = "test/inventory"    
  #   ansible.playbook = "test/test.yml"
  #   ansible.galaxy_roles_path = "../"
  #   ansible.sudo = true
     #ansible.tags = "config"
  #end  
end
