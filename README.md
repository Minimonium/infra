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
* Put ssh keys to the `infra/secrets` subfolder, probably you would want to separate FS keys with Vagrant keys.
* Configure `example.htpasswd` into `.htpasswd` for admin services auth.
* Configure `example.gitlab.rb` into `gitlab.rb`.

## Problems

* Kubernetes [Pretty complex, need to look into it later]
* DNS in the Swarm [Swarm doesn't support CAP feature]
* Vagrant SSH for the ed25519 [Doesn't work with `The private key you're attempting to use with this Vagrant box uses an unsupported encryption type` despite the version being 2.2.2]
* Https [Because of the private network target]
* SSHFS [Had a problem making it work without `:nocopy`, can't work with Docker Compose for some reason and don't work on Windows because plugins]
* [Gitlab Windows Docker Executors](https://gitlab.com/gitlab-org/gitlab-runner/merge_requests/706) [Not ready]