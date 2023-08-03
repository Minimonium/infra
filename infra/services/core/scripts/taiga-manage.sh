#!/bin/bash

set -x
exec docker compose -p tmp -f ${INFRA_DIR}/docker/compose/taiga.compose.yml run --rm taiga-manage $@
