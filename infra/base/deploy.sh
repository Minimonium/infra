#!/bin/bash

export INFRA_DIR=/opt/infra/base

echo "infra: Installing Qemu..."
source ${INFRA_DIR}/scripts/install-qemu.sh

echo "infra: Installing Docker..."
source ${INFRA_DIR}/scripts/install-docker.sh

echo "infra: Fix DNS inside Docker containers..."
source ${INFRA_DIR}/scripts/fix-dns.sh

echo "infra: Installing Docker Compose..."
source ${INFRA_DIR}/scripts/install-docker-compose.sh

echo "infra: Initializating the Swarm..."
source ${INFRA_DIR}/scripts/docker-swarm-init.sh

echo "infra: Installing the Common File System Components..."
source ${INFRA_DIR}/scripts/install-fs-commons.sh
