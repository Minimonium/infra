#!/bin/bash

export INFRA_DIR=/opt/infra/${INFRA_WORKDIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

echo "infra: Installing Qemu..."
source ${INFRA_DIR}/scripts/install-qemu.sh

echo "infra: Installing Docker..."
source ${INFRA_DIR}/scripts/install-docker.sh

echo "infra: Installing Docker Compose..."
source ${INFRA_DIR}/scripts/install-docker-compose.sh

echo "infra: Initializating the Swarm..."
source ${INFRA_DIR}/scripts/docker-swarm-init.sh

echo "infra: Installing the Common File System Components..."
source ${INFRA_DIR}/scripts/install-fs-commons.sh

