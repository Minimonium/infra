#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

source ${INFRA_DIR}/scripts/taiga-manage.sh createsuperuser --username=taiga --email=${INFRA_EMAIL} --noinput
