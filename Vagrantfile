# -*- mode: ruby -*-

require 'yaml'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    infra = YAML.load(File.read("config.yml"))

    manager_ip = "10.10.10.10"
    config.vm.define "manager" do |manager|
        machine = infra["machines"]["linux"]

        manager.vm.hostname = "jade-emperor"

        manager.vm.box = "bento/ubuntu-18.04"

        # Insert the custom ssh key into the Vagrant box
        # See [Problems] in the `README` on the problem of id_ed25519 in the Vagrant version 2.2.2
        manager.ssh.insert_key = false
        manager.ssh.private_key_path = [".ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
        manager.vm.provision "file", source: ".ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
        manager.vm.provision "shell", inline: <<-EOC
            sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
            sudo service ssh restart
        EOC

        manager.vm.provider "virtualbox" do |vb|
            vb.name = "jade-emperor"
            vb.gui = false
            vb.cpus = machine["cpus"]
            vb.memory = machine["memory"]
        end

        manager.vm.network :private_network,
            ip: "#{manager_ip}"

        # Frontend
        manager.vm.network :forwarded_port,
            guest: 80, host: 80,
            id: "http"
        manager.vm.network :forwarded_port,
            guest: 443, host: 443,
            id: "https"

        # Gitlab SSH port
        manager.vm.network :forwarded_port,
            guest: 8022, host: 8022,
            id: "gitlab-ssh"

        manager.vm.provision "shell" do |s|
            s.path = "infra/base/deploy.sh"
            s.env = {
                "INFRA_WORKDIR" => "/vagrant/infra/base",

                "INFRA_MANAGER_IP" => "#{manager_ip}"
            }
            s.privileged = true
        end

        if infra["optional"]["fs"]
            manager.vm.provision "fs", type: "shell" do |s|
                s.path = "infra/fs/deploy.sh"
                s.privileged = true
            end
        end

        core_env = {
            "INFRA_WORKDIR" => "/vagrant/infra/services/core",

            "INFRA_IP" => "#{infra["ip"]}",
            "INFRA_DOMAIN" => "#{infra["domain"]}",

            "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
            "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
        }
        manager.vm.provision "core", type: "shell" do |s|
            s.path = "infra/services/core/deploy.sh"
            s.env = core_env
            s.privileged = true
        end
        manager.vm.provision "core-restore", type: "shell", run: "never" do |s|
            s.path = "infra/services/core/restore.sh"
            s.env = core_env
            s.privileged = true
        end
        manager.vm.provision "core-backup", type: "shell", run: "never" do |s|
            s.path = "infra/services/core/backup.sh"
            s.env = core_env
            s.privileged = true
        end

        manager.vm.provision "ci", type: "shell", run: "never" do |s|
            s.path = "infra/services/ci/deploy.sh"
            s.env = {
                "INFRA_WORKDIR" => "/vagrant/infra/services/ci",

                "INFRA_IP" => "#{infra["ip"]}",
                "INFRA_DOMAIN" => "#{infra["domain"]}",

                "INFRA_GITLAB_RUNNER_TOKEN" => "#{infra["services"]["gitlab-runner"]["token"]}",

                "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
                "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
            }
            s.privileged = true
        end

        if infra["optional"]["dns"]
            manager.vm.network :forwarded_port,
                guest: 53, host: 53, protocol: "udp"

            manager.vm.provision "dns", type: "shell" do |s|
                s.path = "infra/services/dns/deploy.sh"
                s.env = {
                    "INFRA_WORKDIR" => "/vagrant/infra/services/dns",

                    "INFRA_IP" => "#{infra["ip"]}",
                    "INFRA_DOMAIN" => "#{infra["domain"]}",

                    "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
                    "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
                }
                s.privileged = true
            end
        end
    end

    if infra["machines"]["windows"]
        worker_ip = "10.10.10.11"
        config.vm.define "worker" do |worker|
            machine = infra["machines"]["windows"]

            worker.vm.hostname = "divine-mother"

            worker.vm.box = "StefanScherer/windows_2019_docker"
            worker.vm.communicator = "winrm"

            worker.vm.provider "virtualbox" do |vb|
                vb.name = "divine-mother"
                vb.gui = false

                vb.cpus = machine["cpus"]
                vb.memory = machine["memory"]
            end

            worker.vm.network :private_network,
                ip: "#{worker_ip}"

            worker.vm.provision "shell" do |s|
                s.path = "infra/base/deploy.ps1"
                s.env = {
                    "INFRA_MANAGER_IP" => "#{manager_ip}",
                    "INFRA_WORKER_IP" => "#{worker_ip}",

                    "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
                    "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
                }
                s.privileged = true
            end
            
            worker.trigger.after :up do |trigger|
                trigger.warn = "Resuming the Docker Engine"
                trigger.run_remote = {
                    path: "infra/base/up.ps1"
                }
                trigger.on_error = :continue
            end
            # hangs for some reason
            # worker.trigger.before :destroy do |trigger|
            #     trigger.warn = "Leaving the Docker Swarm"
            #     trigger.run_remote = {
            #         path: "infra/base/destroy.ps1",
            #         privileged: true
            #     }
            #     trigger.on_error = :continue
            # end
        end
    end
end