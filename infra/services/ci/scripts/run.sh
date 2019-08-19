#!/bin/bash

echo "infra: Running..."

docker stack deploy \
--compose-file ${INFRA_DIR}/docker/base.yml \
--compose-file ${INFRA_DIR}/docker/gitlab-runner.lin.yml \
--compose-file ${INFRA_DIR}/docker/gitlab-runner.win.yml \
--compose-file ${INFRA_DIR}/docker/gitlab-runner-dind.win.yml \
infra
