#!/bin/bash

echo "infra: DNS: Starting..."

export INFRA_DIR=/opt/infra/services/dns

source ${INFRA_DIR}/scripts/run.sh
