#!/bin/bash

echo "infra: DNS: Running..."

# docker volume create -d vieux/sshfs \
# -o sshcmd=${INFRA_FS_USER}@${INFRA_FS_SERVER}:/${INFRA_FS_ROOT}/dns-logs \
# -o port=${INFRA_FS_PORT} \
# -o allow_other \
# dns-logs

# docker run -d \
# --cap-add=NET_ADMIN \
# -p 53:53/udp \
# -v ${INFRA_DIR}/configs/dnsmasq.conf:/etc/dnsmasq.conf:ro \
# -v dns-logs:/test \
# --network infra_network \
# --restart unless-stopped  \
# --name dns \
# andyshinn/dnsmasq

docker-compose -f ${INFRA_DIR}/docker/dnsmasq.yml up -d
