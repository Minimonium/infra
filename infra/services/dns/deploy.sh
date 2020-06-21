#!/bin/bash

echo "infra: DNS: Deploying..."

export INFRA_DIR=/opt/infra/services/dns

source ${INFRA_DIR}/scripts/docker-image.sh
source ${INFRA_DIR}/scripts/fix-systemd-resolved.sh
