#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

echo "infra: Restoring Taiga..."

docker service scale infra_taiga-async=0 > /dev/null
docker service scale infra_taiga-async-rabbitmq=0 > /dev/null
docker service scale infra_taiga-events=0 > /dev/null
docker service scale infra_taiga-events-rabbitmq=0 > /dev/null
docker service scale infra_taiga-protected=0 > /dev/null
docker service scale infra_taiga-gateway=0 > /dev/null

docker service scale infra_taiga-back=0
export TAIGA_DB_CONTAINER=$(docker container ps | grep infra_taiga-db | awk '{print $1}')
docker exec ${TAIGA_DB_CONTAINER} bash -c 'BACKUP_FILE=$(find /media/backup/*_taiga-db-backup.sql) && \
    chown taiga:taiga ${BACKUP_FILE} && \
    psql -U taiga taiga < ${BACKUP_FILE}'

docker service scale infra_taiga-back=1
export TAIGA_BACK_CONTAINER=$(docker container ps | grep infra_taiga-back | awk '{print $1}')
docker exec ${TAIGA_BACK_CONTAINER} bash -c 'BACKUP_FILE=$(find /media/backup/*_taiga-media-backup.tar.gz) && \
    chown taiga:taiga ${BACKUP_FILE} && \
    tar -xzvf ${BACKUP_FILE} -C /taiga-back/media --strip 1 && \
    chown -R taiga:taiga /taiga-back/media'

docker service scale infra_taiga-async=1 > /dev/null
docker service scale infra_taiga-async-rabbitmq=1 > /dev/null
docker service scale infra_taiga-events=1 > /dev/null
docker service scale infra_taiga-events-rabbitmq=1 > /dev/null
docker service scale infra_taiga-protected=1 > /dev/null
docker service scale infra_taiga-gateway=1 > /dev/null
