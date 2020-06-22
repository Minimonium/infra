#!/bin/bash

cp ${INFRA_DIR}/config/daemon.json /etc/docker/daemon.json

DOCKER_IP=$(ip address | grep docker0 | grep inet | sed 's:  ::g' | cut -d' ' -f2 | cut -d'/' -f1)
sed -i "s,\${docker.ip},${DOCKER_IP}," /etc/docker/daemon.json

service docker restart
