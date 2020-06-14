#!/bin/bash

echo "infra: Backuping..."

docker service scale infra_gitlab=0

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
up -d

sleep 2
if docker inspect -f {{.State.Running}} gitlab_compose ; then
    echo "infra: Gitlab: Creating the Backup..."
    docker exec gitlab_compose bash -c 'gitlab-ctl reconfigure && \
    gitlab-backup create SKIP=artifacts && \
    cp /etc/gitlab/gitlab-secrets.json /media/backup'
else
    echo "infra: Gitlab: CONTAINER IS NOT RUNNING"
fi

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
down

docker service scale infra_gitlab=1
