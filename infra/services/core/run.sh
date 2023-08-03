#!/bin/bash

echo "infra: Starting..."

export INFRA_DIR=/opt/infra/services/core

source ${INFRA_DIR}/scripts/create-network.sh
source ${INFRA_DIR}/scripts/regenerate-taiga-env.sh
source ${INFRA_DIR}/scripts/deploy.sh

echo "infra: Success!"
