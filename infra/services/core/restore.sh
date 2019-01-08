#!/bin/bash

echo "infra: Restoring..."

export INFRA_DIR=/opt/infra-core
mkdir -p ${INFRA_DIR}
cp -r ${INFRA_WORKDIR}/. ${INFRA_DIR}

# Fix line endings in case of the Windows host
find ${INFRA_DIR} -type f | xargs sed -i 's/\r$//'

source ${INFRA_DIR}/scripts/preconfigure.sh

docker service scale infra_gitlab=0

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
up -d

sleep 2
if docker inspect -f {{.State.Running}} gitlab_compose ; then
    echo "infra: RESTORING Gitlab"
    docker exec gitlab_compose bash -c 'gitlab-ctl reconfigure && \
    gitlab-ctl stop unicorn && \
    gitlab-ctl stop sidekiq && \
    gitlab-rake gitlab:backup:restore BACKUP=1537268638_2018_09_18_11.1.1 force=yes && \
    gitlab-ctl start'
else
    echo "infra: Gitlab CONTAINER IS NOT RUNNING"
fi

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
down

docker service scale infra_gitlab=1
