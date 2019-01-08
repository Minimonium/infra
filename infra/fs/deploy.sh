#!/bin/bash

apt-get install -y nfs-kernel-server
systemctl enable --now nfs-server

mkdir -p /srv/infra-swarm && \
mkdir -p /srv/infra-swarm/dns/logs && \
mkdir -p /srv/infra-swarm/traefik/logs && \
mkdir -p /srv/infra-swarm/portainer/data && \
mkdir -p /srv/infra-swarm/artifactory/data && \
mkdir -p /srv/infra-swarm/gitlab/{common_data,data,logs,config} && \
mkdir -p /srv/infra-swarm/gitlab/data/{backup,disk0} && \
cp -r /vagrant/backup/*gitlab_backup.tar /srv/infra-swarm/gitlab/data/backup && \
mkdir -p /srv/infra-swarm/postgres && \
mkdir -p /srv/infra-swarm/redis && \
mkdir -p /srv/infra-swarm/prometheus && \
mkdir -p /srv/infra-swarm/grafana/{data,logs,config} && \
chmod -R 777 /srv/infra-swarm

mkdir -p /exports/infra-swarm
mount --bind /srv/infra-swarm /exports/infra-swarm
echo "/srv/infra-swarm/       /exports/infra-swarm/  none    bind" >> /etc/fstab

echo "/exports/               *(rw,sync,fsid=0,crossmnt,no_subtree_check)" >> /etc/exports
echo "/exports/infra-swarm    *(rw,sync,no_root_squash,no_subtree_check)"  >> /etc/exports

exportfs -ra