#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

source ${INFRA_DIR}/scripts/taiga-manager.sh createsuperuser
