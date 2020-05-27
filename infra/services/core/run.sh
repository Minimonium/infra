#!/bin/bash

echo "infra: Starting..."

export INFRA_DIR=/opt/infra/${INFRA_WORKDIR}

docker network create -d overlay --attachable infra_network

source ${INFRA_DIR}/scripts/run.sh

echo "infra: Success!"
