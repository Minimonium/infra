#!/bin/bash

echo "infra: Starting..."

docker network create -d overlay --attachable infra_network

source ${INFRA_DIR}/scripts/run.sh

echo "infra: Success!"