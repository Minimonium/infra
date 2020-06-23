# Infrastructure

Project to try out different local infrastructure options

> Based on _Vagrant_ + _Docker Swarm_

## Prerequisites

### Plugins

```bash
vagrant plugin install vagrant-disksize
```

### Configuration

- Configure `config.yml`
- Put ssh keys into the `.ssh` folder under the `id_rsa` name, e.g. `ssh-keygen -t rsa -b 4096 -f ./.ssh/id_rsa`
- Configurate `infra/services/core/config/.htpasswd` for global admin password
- Configurate `infra/services/core/config/gitlab.rb` for Gitlab
- Add certs for Traefik into `core/config/certs/infra.{crt,key}`
- To Configure Docker Registry:
  - Add auth for Docker Registry into `core/config/registry/auth/.htpasswd` ([see](/docs/registry/generating-htpasswd.md))
  - View [DOCS](/docs/registry) for additional setup

## Usage

`Hyper-V` doesn't support network customization, so you need to fill `ip` in the `config.yml` manually:

```bash
vagrant up --no-provision
# Edit config.yml with IPs from the output
vagrant provision
# Wait for core services to be up, get required tokens and put them into the config [like gitlab runner token]
vagrant provision --provision-with=ci-deploy,ci
```

For `VirtualBox`:

```bash
vagrant up
# Wait for core services to be up, get required tokens and put them into the config [like gitlab runner token]
vagrant provision --provision-with=ci-deploy,ci
```

To fix any problems try to reprovision as:

```bash
vagrant provision --provision-with=core-deploy,core
vagrant provision --provision-with=dns
```

## Services

| Services       | Group    | Purpose           |
|----------------|----------|-------------------|
| Traefik        | Infra    | Frontend          |
| Portainer      | Infra    | Manager           |
| Visualizer     | Infra    | Cluster Dashboard |
| Prometheus     | Infra    | Metrics           |
| Grafana        | Infra    | Metrics Dashboard |
| Artifactory    | Storage  | Binaries          |
| Gitlab         | Storage  | Sources           |
| Registry       | Storage  | Containers        |
| Gitlab Runners | CI       | CI                |
| DNSMasq        | Optional | DNS               |
| NFS            | Optional | File System       |

## Provisioners

- base-deploy
- fs-stub-deploy [optional]
- core:
  - core-deploy
  - core
  - core-backup
  - core-restore
- ci:
  - ci-deploy
  - ci
- dns [optional]:
  - dns-deploy
  - dns

## Problems

- Kubernetes [Pretty complex, need to look into it later]
- DNS in the Swarm [Swarm doesn't support CAP feature]
- Vagrant SSH for the ed25519 [Doesn't work with `The private key you're attempting to use with this Vagrant box uses an unsupported encryption type` despite the version being 2.2.2]
- SSHFS [Had a problem making it work without `:nocopy`, can't work with Docker Compose for some reason and don't work on Windows because plugins]
- Docker NFS on Windows [Can't use `driver_opts` on Windows]
- NFS on Windows with Docker symlinked into it [Don't work, tell me if you know how to make it work, please]
