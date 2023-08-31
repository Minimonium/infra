# -*- mode: ruby -*-

require 'yaml'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    infra = YAML.load(File.read("config.yml"))

    manager_ip = infra["machines"]["linux"]["ip"]
    config.vm.define "manager" do |manager|
        machine = infra["machines"]["linux"]

        manager.vm.provider "hyperv" do |vb, override|
            override.vm.box = "generic/debian10"

            override.ssh.username = "vagrant"
            override.ssh.password = "vagrant"

            vb.maxmemory = machine["memory"]
            vb.cpus = machine["cpus"]
        end
        manager.vm.provider "virtualbox" do |vb, override|
            # NOTE: Generic boxes can't be used because we
            # need to setup private_network out of the box
            override.vm.box = "debian/buster64"
            override.disksize.size = '100GB'
            override.vm.provision "shell", privileged: true, inline: <<-EOC
                apt update
                apt install -y parted cloud-guest-utils
                echo '+83GB,' | /sbin/sfdisk --force --move-data /dev/sda -N 2
                growpart /dev/sda 1
            EOC
            override.vm.provision "shell", run: "always", privileged: true, inline: <<-EOC
                resize2fs /dev/sda1
            EOC

            override.ssh.insert_key = false
            override.ssh.private_key_path = [".ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
            override.vm.provision "file", source: ".ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
            override.vm.provision "shell", privileged: true, inline: <<-EOC
                sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
                service ssh restart
            EOC

            vb.name = "jade-emperor"
            vb.gui = false
            vb.memory = machine["memory"]
            vb.cpus = machine["cpus"]
        end

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

        # Insert the custom ssh key into the Vagrant box
        # See [Problems] in the `README` on the problem of id_ed25519 in the Vagrant version 2.2.2

        manager.vm.provision "shell", privileged: true, inline: <<-EOC
            mkdir -p /tmp/infra
            chown vagrant: /tmp/infra
            mkdir -p /opt/infra
            chown vagrant: /opt/infra
        EOC

        # TODO: Use `before:` attribute
        preconfigure_provision = {
            :type => "file",
            :source => "infra",
            :destination => "/tmp/infra"
        }
        manager.vm.provision("preconfigure", preconfigure_provision)

        configure_provision = {
            :type => "shell",
            :path => "infra/configure.sh",
            :env => {
                "INFRA_DOMAIN" => "#{infra["domain"]}",
                "INFRA_IP" => "#{infra["ip"]}",
            },
            :privileged => true
        }
        manager.vm.provision("configure", configure_provision)

        base_deploy_provision = {
            :type => "shell",
            :path => "infra/base/deploy.sh",
            :env => {
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
            "INFRA_DOMAIN" => "#{infra["domain"]}",
            "INFRA_IP" => "#{infra["ip"]}",
            "INFRA_EMAIL" => "#{infra["email"]}",

            "INFRA_FS_SERVER" => "#{infra["fs"]["server"]}",
            "INFRA_FS_ROOT" => "#{infra["fs"]["root"]}"
        }
        core_provision = {
            :type => "shell",
            :env => core_env,
            :privileged => true
        }
        manager.vm.provision "core-install", core_provision.merge({
            :path => "infra/services/core/install.sh"
        })
        manager.vm.provision "core", core_provision.merge({
            :path => "infra/services/core/run.sh"
        })
        manager.vm.provision "gitlab-backup", core_provision.merge({
            :path => "infra/services/core/gitlab-backup.sh",
            :run => "never"
        })
        manager.vm.provision "taiga-backup", core_provision.merge({
            :path => "infra/services/core/taiga-backup.sh",
            :run => "never"
        })
        manager.vm.provision "core-backup", core_provision.merge({
            :path => "infra/services/core/backup.sh",
            :run => "never"
        })
        manager.vm.provision "gitlab-restore", core_provision.merge({
            :path => "infra/services/core/gitlab-restore.sh",
            :run => "never"
        })
        manager.vm.provision "taiga-restore", core_provision.merge({
            :path => "infra/services/core/taiga-restore.sh",
            :run => "never"
        })

        ci_env = {
            "INFRA_DOMAIN" => "#{infra["domain"]}",
            "INFRA_IP" => "#{infra["ip"]}",

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
                    "INFRA_DOMAIN" => "#{infra["domain"]}",
                    "INFRA_IP" => "#{infra["ip"]}",

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
                    # vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0')
                end
            end

            worker.vm.provider "hyperv" do |vb|
                vb.maxmemory = machine["memory"]
            end
            worker.vm.provider "virtualbox" do |vb|
                vb.name = "celestial-queen"
                vb.gui = false
                vb.memory = machine["memory"]
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
