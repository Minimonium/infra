#!/bin/bash

echo "infra: DNS: Preconfiguration..."

docker pull andyshinn/dnsmasq

find ${INFRA_DIR}/configs -type f | xargs sed -i "s,\${infra.domain},${INFRA_DOMAIN},"
find ${INFRA_DIR}/configs -type f | xargs sed -i "s,\${infra.ip},${INFRA_IP},"
