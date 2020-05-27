#!/bin/bash

echo "infra: DNS: Deploying..."

export INFRA_DIR=/opt/infra/${INFRA_WORKDIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

source ${INFRA_DIR}/scripts/preconfigure.sh
source ${INFRA_DIR}/scripts/fix-systemd-resolved.sh
