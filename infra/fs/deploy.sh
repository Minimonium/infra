#!/bin/bash

apt-get install -y nfs-kernel-server
systemctl enable --now nfs-server

mkdir -p /srv/infra && \
mkdir -p /srv/infra/windows && \
mkdir -p /srv/infra/dns/logs && \
mkdir -p /srv/infra/traefik/logs && \
mkdir -p /srv/infra/registry/data && \
mkdir -p /srv/infra/portainer/data && \
mkdir -p /srv/infra/artifactory/{storage,data} && \
mkdir -p /srv/infra/artifactory/storage/{backup,disk0} && \
mkdir -p /srv/infra/artifactory/data/etc && \
mkdir -p /srv/infra/gitlab-runner/{lin,win} && \
mkdir -p /srv/infra/gitlab-runner/lin/{config,cache} && \
mkdir -p /srv/infra/gitlab/{storage,data,logs,config} && \
mkdir -p /srv/infra/gitlab/storage/{backup,disk0} && \
(cp -r /vagrant/backup/*gitlab_backup.tar /srv/infra/gitlab/storage/backup | true) && \
mkdir -p /srv/infra/postgres && \
mkdir -p /srv/infra/redis && \
mkdir -p /srv/infra/prometheus && \
mkdir -p /srv/infra/grafana/{data,logs,config} && \
chmod -R 777 /srv/infra

mkdir -p /exports/infra
mount --bind /srv/infra /exports/infra
echo "/srv/infra/       /exports/infra/  none    bind" >> /etc/fstab

echo "/exports/               *(rw,sync,fsid=0,crossmnt,no_subtree_check)" >> /etc/exports
echo "/exports/infra          *(rw,sync,no_root_squash,no_subtree_check)"  >> /etc/exports

exportfs -ra
