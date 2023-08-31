#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

echo "infra: Backup..."
source ${INFRA_DIR}/gitlab-backup.sh
source ${INFRA_DIR}/taiga-backup.sh
