
#!/bin/bash

export INFRA_DIR=/opt/infra/services/core

echo "infra: Backuping Taiga..."

docker service scale taiga-async=0
docker service scale taiga-async-rabbitmq=0
docker service scale taiga-events=0
docker service scale taiga-events-rabbitmq=0
docker service scale taiga-protected=0
docker service scale taiga-gateaway=0

export TIMESTAMP=$(date +%H%M%S_%Y_%m_%d)
docker exec infra_taiga-db bash -c "pg_dump -U taiga taiga > /media/backup/${TIMESTAMP}_taiga-db-backup.sql"
docker exec infra_taiga-back bash -c "tar czf /media/backup/${TIMESTAMP}_taiga-media-backup.tar.gz media"

docker service scale taiga-async=1
docker service scale taiga-async-rabbitmq=1
docker service scale taiga-events=1
docker service scale taiga-events-rabbitmq=1
docker service scale taiga-protected=1
docker service scale taiga-gateaway=1
