
#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

echo "infra: Backuping Taiga..."

docker service scale infra_taiga-async=0 > /dev/null
docker service scale infra_taiga-async-rabbitmq=0 > /dev/null
docker service scale infra_taiga-events=0 > /dev/null
docker service scale infra_taiga-events-rabbitmq=0 > /dev/null
docker service scale infra_taiga-protected=0 > /dev/null
docker service scale infra_taiga-gateway=0 > /dev/null

export TIMESTAMP=$(date +%H%M%S_%Y_%m_%d)

export TAIGA_DB_CONTAINER=$(docker container ps | grep infra_taiga-db | awk '{print $1}')
docker exec ${TAIGA_DB_CONTAINER} bash -c "pg_dump -Fc -U taiga taiga > /media/backup/${TIMESTAMP}_taiga-db-backup.sql"

export TAIGA_BACK_CONTAINER=$(docker container ps | grep infra_taiga-back | awk '{print $1}')
docker exec ${TAIGA_BACK_CONTAINER} bash -c "tar czf /media/backup/${TIMESTAMP}_taiga-media-backup.tar.gz media"

docker service scale infra_taiga-async=1 > /dev/null
docker service scale infra_taiga-async-rabbitmq=1 > /dev/null
docker service scale infra_taiga-events=1 > /dev/null
docker service scale infra_taiga-events-rabbitmq=1 > /dev/null
docker service scale infra_taiga-protected=1 > /dev/null
docker service scale infra_taiga-gateway=1 > /dev/null
