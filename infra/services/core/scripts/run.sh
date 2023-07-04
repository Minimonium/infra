#!/bin/bash

echo "infra: Running..."

source ${INFRA_DIR}/config/taiga.env
docker stack deploy \
--compose-file ${INFRA_DIR}/docker/base.yml \
--compose-file ${INFRA_DIR}/docker/visualizer.yml \
--compose-file ${INFRA_DIR}/docker/traefik.yml \
--compose-file ${INFRA_DIR}/docker/registry.yml \
--compose-file ${INFRA_DIR}/docker/portainer.yml \
--compose-file ${INFRA_DIR}/docker/artifactory.yml \
--compose-file ${INFRA_DIR}/docker/monitoring.yml \
--compose-file ${INFRA_DIR}/docker/gitlab.yml \
--compose-file ${INFRA_DIR}/docker/pypi.yml \
--compose-file ${INFRA_DIR}/docker/taiga.yml \
infra
