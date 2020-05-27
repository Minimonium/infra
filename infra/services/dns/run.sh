#!/bin/bash

echo "infra: DNS: Starting..."

export INFRA_DIR=/opt/infra/${INFRA_WORKDIR}

source ${INFRA_DIR}/scripts/run.sh
