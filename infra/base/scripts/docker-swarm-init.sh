#!/bin/bash

ip=${INFRA_MANAGER_IP}

docker swarm init --listen-addr "$ip:2377" --advertise-addr "$ip:2377"

#echo "Warning: Do not insecure Docker port 2375 in production!"
systemctl stop docker
sed -i 's,dockerd,dockerd -H tcp://0.0.0.0:2375,' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl start docker
