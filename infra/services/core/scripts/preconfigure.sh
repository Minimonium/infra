#!/bin/bash

echo "infra: Preconfiguration..."

find ${INFRA_DIR}/config -type f | xargs sed -i "s,\${infra.domain},${INFRA_DOMAIN},"