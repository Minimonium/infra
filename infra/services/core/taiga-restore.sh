#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

echo "infra: Restoring Taiga..."

docker service scale infra_taiga-async=0
docker service scale infra_taiga-async-rabbitmq=0
docker service scale infra_taiga-events=0
docker service scale infra_taiga-events-rabbitmq=0
docker service scale infra_taiga-protected=0
docker service scale infra_taiga-gateaway=0

docker service scale taiga-back=0
docker exec infra_taiga-db bash -c "BACKUP_FILE=$(find /media/backup/*_taiga_backup.sql) && \
    psql -U taiga taiga < ${BACKUP_FILE}"

docker service scale taiga-back=1
docker exec infra_taiga-back bash -c "BACKUP_FILE=$(find /media/backup/*_taiga_backup.tar.gz) && \
    tar -xzvf ${BACKUP_FILE} -C /taiga-back/media --strip 1 && \
    chown -R taiga:taiga /taiga-back/media"

docker service scale infra_taiga-async=1
docker service scale infra_taiga-async-rabbitmq=1
docker service scale infra_taiga-events=1
docker service scale infra_taiga-events-rabbitmq=1
docker service scale infra_taiga-protected=1
docker service scale infra_taiga-gateaway=1
