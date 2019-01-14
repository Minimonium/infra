#!/bin/bash

# Set up Working Directory
mkdir -p ${INFRA_DIR}
cp -r ${INFRA_WORKDIR}/. ${INFRA_DIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

source ${INFRA_DIR}/scripts/preconfigure.sh
source ${INFRA_DIR}/scripts/build.sh