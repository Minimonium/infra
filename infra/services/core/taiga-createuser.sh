#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

source ${INFRA_DIR}/scripts/taiga-manage.sh createsuperuser --username=infra --email=${INFRA_EMAIL} --noinput
