#!/bin/bash

echo "infra: Restoring..."

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
    gitlab-rake gitlab:backup:restore BACKUP=1547550260_2018_01_15_11.1.1 force=yes && \
    gitlab-ctl start'
else
    echo "infra: Gitlab CONTAINER IS NOT RUNNING"
fi

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
down

docker service scale infra_gitlab=1
