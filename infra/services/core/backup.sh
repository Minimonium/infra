#!/bin/bash

echo "infra: Backuping..."

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
    echo "infra: Gitlab: Creating the Backup..."
    docker exec gitlab_compose bash -c 'gitlab-ctl reconfigure && gitlab-rake gitlab:backup:create'
else
    echo "infra: Gitlab: CONTAINER IS NOT RUNNING"
fi

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
down

docker service scale infra_gitlab=1