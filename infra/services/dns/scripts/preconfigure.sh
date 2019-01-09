#!/bin/bash

echo "infra: DNS: Preconfiguration..."

docker pull andyshinn/dnsmasq

find ${INFRA_DIR}/config -type f | xargs sed -i "s,\${infra.domain},${INFRA_DOMAIN},"
find ${INFRA_DIR}/config -type f | xargs sed -i "s,\${infra.ip},${INFRA_IP},"
