# -*- mode: ruby -*-

require 'yaml'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    infra = YAML.load(File.read("config.yml"))

    manager_ip = infra["machines"]["linux"]["ip"]
    config.vm.define "manager" do |manager|
        manager.vm.box = "bento/ubuntu-18.04"

        machine = infra["machines"]["linux"]

        manager.vm.hostname = "jade-emperor"
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

        ["hyperv", "virtualbox"].each do |provider|
            manager.vm.provider provider do |vb|
                vb.cpus = machine["cpus"]
                vb.memory = machine["memory"]

                vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0')
            end
        end

        manager.vm.provider "virtualbox" do |vb|
            vb.name = "jade-emperor"
            vb.gui = false
        end

        # Insert the custom ssh key into the Vagrant box
        # See [Problems] in the `README` on the problem of id_ed25519 in the Vagrant version 2.2.2
        manager.ssh.insert_key = false
        manager.ssh.private_key_path = [".ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
        manager.vm.provision "file", source: ".ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
        manager.vm.provision "shell", inline: <<-EOC
            sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
            sudo service ssh restart
        EOC

        base_deploy_provision = {
            :type => "shell",
            :path => "infra/base/deploy.sh",
            :env => {
                "INFRA_WORKDIR" => "/vagrant/infra/base",

                "INFRA_MANAGER_IP" => "#{manager_ip}",

                "INFRA_DOMAIN" => "#{infra["domain"]}"
            },
            :privileged => true
        }
        manager.vm.provision("base-deploy", base_deploy_provision)

        if infra["optional"]["fs"]
            fs_stub_deploy_provision = {
                :type => "shell",
                :path => "infra/fs/deploy.sh",
                :privileged => true
            }
            manager.vm.provision("fs-stub-deploy", fs_stub_deploy_provision)
        end

        core_env = {
            "INFRA_DIR" => "/opt/infra/core",
            "INFRA_WORKDIR" => "/vagrant/infra/services/core",

            "INFRA_IP" => "#{infra["ip"]}",
            "INFRA_DOMAIN" => "#{infra["domain"]}",

            "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
            "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
        }
        core_provision = {
            :type => "shell",
            :env => core_env,
            :privileged => true
        }
        manager.vm.provision "core-deploy", core_provision.merge({
            :path => "infra/services/core/deploy.sh"
        })
        manager.vm.provision "core-restore", core_provision.merge({
            :path => "infra/services/core/restore.sh",
            :run => "never"
        })
        manager.vm.provision "core", core_provision.merge({
            :path => "infra/services/core/run.sh"
        })
        manager.vm.provision "core-backup", core_provision.merge({
            :path => "infra/services/core/backup.sh",
            :run => "never"
        })

        ci_env = {
            "INFRA_DIR" => "/opt/infra/ci",
            "INFRA_WORKDIR" => "/vagrant/infra/services/ci",

            "INFRA_IP" => "#{infra["ip"]}",
            "INFRA_DOMAIN" => "#{infra["domain"]}",

            "INFRA_GITLAB_RUNNER_TOKEN" => "#{infra["services"]["gitlab-runner"]["token"]}",

            "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
            "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
        }
        ci_provision = {
            :type => "shell",
            :env => ci_env,
            :privileged => true
        }
        manager.vm.provision "ci-deploy", ci_provision.merge({
            :path => "infra/services/ci/deploy.sh"
        })
        manager.vm.provision "ci", ci_provision.merge({
            :path => "infra/services/ci/run.sh",
            :run => "never"
        })

        if infra["optional"]["dns"]
            manager.vm.network :forwarded_port,
                guest: 53, host: 53, protocol: "udp"

            dns_provision = {
                :type => "shell",
                :env => {
                    "INFRA_DIR" => "/opt/infra/dns",
                    "INFRA_WORKDIR" => "/vagrant/infra/services/dns",

                    "INFRA_IP" => "#{infra["ip"]}",
                    "INFRA_DOMAIN" => "#{infra["domain"]}",

                    "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
                    "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
                },
                :privileged => true
            }
            manager.vm.provision "dns-deploy", dns_provision.merge({
                :path => "infra/services/dns/deploy.sh"
            })
            manager.vm.provision "dns", dns_provision.merge({
                :path => "infra/services/dns/run.sh"
            })
        end
    end

    if infra["machines"]["windows"]
        worker_ip = infra["machines"]["windows"]["ip"]
        config.vm.define "worker" do |worker|
            worker.vm.box = "StefanScherer/windows_2019_docker"
            worker.vm.communicator = "winrm"

            worker.winrm.timeout = 30000

            machine = infra["machines"]["windows"]

            worker.vm.hostname = "celestial-queen"
            worker.vm.network :private_network,
                ip: "#{worker_ip}"

            ["hyperv", "virtualbox"].each do |provider|
                worker.vm.provider provider do |vb|
                    vb.cpus = machine["cpus"]
                    vb.memory = machine["memory"]

                    vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0')
                end
            end

            manager.vm.provider "virtualbox" do |vb|
                vb.name = "celestial-queen"
                vb.gui = false
            end

            base_deploy_provision = {
                :type => "shell",
                :path => "infra/base/deploy.ps1",
                :env => {
                    "INFRA_MANAGER_IP" => "#{manager_ip}",
                    "INFRA_WORKER_IP" => "#{worker_ip}",

                    "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
                    "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
                },
                :privileged => true
            }
            worker.vm.provision("base-deploy", base_deploy_provision)

            ci_deploy_provision = {
                :type => "shell",
                :path => "infra/services/ci/deploy.ps1",
                :env => {},
                :privileged => true,
                :run => "never"
            }
            worker.vm.provision("ci-deploy", ci_deploy_provision)

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
