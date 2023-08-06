#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

source ${INFRA_DIR}/scripts/taiga-manage.sh createsuperuser --username=taiga --password=taiga --email=taiga@example.com
