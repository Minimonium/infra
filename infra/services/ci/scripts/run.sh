#!/bin/bash

echo "infra: Running..."

docker stack deploy \
--compose-file ${INFRA_DIR}/docker/base.yml \
--compose-file ${INFRA_DIR}/docker/gitlab-runner-registrator.yml \
--compose-file ${INFRA_DIR}/docker/gitlab-runner.yml \
infra