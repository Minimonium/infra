#!/bin/bash

echo "infra: Starting..."

export INFRA_DIR=/opt/infra/services/ci

source ${INFRA_DIR}/scripts/run.sh

echo "infra: Success!"
