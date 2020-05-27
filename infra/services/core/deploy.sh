#!/bin/bash

export INFRA_DIR=/opt/infra/${INFRA_WORKDIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

source ${INFRA_DIR}/scripts/install-certificates.sh
source ${INFRA_DIR}/scripts/configure.sh
source ${INFRA_DIR}/scripts/build.sh
