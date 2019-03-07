#!/bin/bash

export INFRA_DIR=/opt/infra-base
mkdir -p ${INFRA_DIR}
cp -r ${INFRA_WORKDIR}/. ${INFRA_DIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

echo "infra: Installing Prerequisites..."
source ${INFRA_DIR}/scripts/prerequisites.sh

echo "infra: Installing Docker..."
source ${INFRA_DIR}/scripts/docker-install.sh

echo "infra: Installing Docker Compose..."
source ${INFRA_DIR}/scripts/docker-compose-install.sh

echo "infra: Initializating the Swarm..."
source ${INFRA_DIR}/scripts/docker-swarm-init.sh

echo "infra: Installing the Common File System Components..."
source ${INFRA_DIR}/scripts/fs-commons-install.sh
