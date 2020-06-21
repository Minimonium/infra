#!/bin/bash

export INFRA_TMPDIR=/tmp/infra/
export INFRA_DIR=/opt/infra/

rm -rf ${INFRA_DIR}
cp -r ${INFRA_TMPDIR} ${INFRA_DIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

# TODO: Move configs to a top level directory
find ${INFRA_DIR}/services/ci/config -type f | xargs sed -i "s,\${infra.domain},${INFRA_DOMAIN},"
find ${INFRA_DIR}/services/ci/config -type f | xargs sed -i "s,\${infra.ip},${INFRA_IP},"

find ${INFRA_DIR}/services/core/config -type f | xargs sed -i "s,\${infra.domain},${INFRA_DOMAIN},"
find ${INFRA_DIR}/services/core/config -type f | xargs sed -i "s,\${infra.ip},${INFRA_IP},"

find ${INFRA_DIR}/services/dns/config -type f | xargs sed -i "s,\${infra.domain},${INFRA_DOMAIN},"
find ${INFRA_DIR}/services/dns/config -type f | xargs sed -i "s,\${infra.ip},${INFRA_IP},"
