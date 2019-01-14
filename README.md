# Infrastructure

Project to try out different local infrastructure options

Consists of:

* Dnsmasq [DNS][Optional]
* NFS [FS][Optional]
* Services:
  * Traefik [Frontend]
  * Artifactory [Binary Storage]
  * Gitlab [Source Storage]
  * Grafana, Prometheus [Naive Monitoring]
  * Visualizer, Portainer [Admin Tools]

## Usage

* Configurate the project via `config.yml`, check the `example.config.yml` for reference.
* Put ssh keys to the `.ssh` subfolder for secure Vagrant ssh keys
* Configure `example.htpasswd` into `.htpasswd` for admin services auth.
* Configure `example.gitlab.rb` into `gitlab.rb`.

For the basic infratructure deployment use:

```bash
vagrant up
# Wait for core services to be up, get required tokens and put them into the config [like gitlab runner token]
vagrant provision --provision-with=ci
```

To fix any problems try to reprovision as:

```bash
vagrant provision --provision-with=core-deploy,core
vagrant provision --provision-with=dns
```

List of provisioners:

* base-deploy
* fs-stub-deploy [optional]
* core:
  * core-deploy
  * core
  * core-backup
  * core-restore
* ci:
  * ci-deploy
  * ci
* dns [optional]:
  * dns-deploy
  * dns

## Problems

* Windows Server 2019 as a node in the Docker Swarm [is not production ready](https://github.com/moby/moby/issues/38498)
* Kubernetes [Pretty complex, need to look into it later]
* DNS in the Swarm [Swarm doesn't support CAP feature]
* Vagrant SSH for the ed25519 [Doesn't work with `The private key you're attempting to use with this Vagrant box uses an unsupported encryption type` despite the version being 2.2.2]
* Https [Because of the private network target]
* SSHFS [Had a problem making it work without `:nocopy`, can't work with Docker Compose for some reason and don't work on Windows because plugins]
* Docker NFS on Windows [Can't use `driver_opts` on Windows]
* NFS on Windows with Docker symlinked into it [Don't work, tell me if you know how to make it work, please]
* Named pipes volumes to windows containers [Swarm treats them as non-absolute pathes, [workaround](https://github.com/dockersamples/docker-swarm-visualizer#running-on-windows)]
* [Gitlab Windows Docker Executors](https://gitlab.com/gitlab-org/gitlab-runner/merge_requests/706) [Not ready]