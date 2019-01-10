#!/bin/bash

# Set up Working Directory
export INFRA_DIR=/opt/infra/dns
mkdir -p ${INFRA_DIR}
cp -r ${INFRA_WORKDIR}/. ${INFRA_DIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

echo "infra: DNS: Starting..."

source ${INFRA_DIR}/scripts/preconfigure.sh
source ${INFRA_DIR}/scripts/fix-systemd-resolved.sh
source ${INFRA_DIR}/scripts/run.sh

echo "infra: DNS: Success!"