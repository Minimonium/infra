#!/bin/bash

echo "infra: Restoring..."

export INFRA_DIR=/opt/infra/services/core

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
    cp /media/backup/gitlab-secrets.json /etc/gitlab/ && \
    gitlab-rake gitlab:backup:restore BACKUP=$(find /media/backup/*_gitlab_backup.tar | sed -e "s/_gitlab_backup.tar//" | tail -n 1) force=yes && \
    gitlab-ctl start'
else
    echo "infra: Gitlab CONTAINER IS NOT RUNNING"
fi

docker-compose \
-p tmp \
-f ${INFRA_DIR}/docker/compose/gitlab.compose.yml \
down

docker service scale infra_gitlab=1
