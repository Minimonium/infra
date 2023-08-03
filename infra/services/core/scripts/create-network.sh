#!/bin/sh

echo "infra: Create network..."

if ! $(docker network ls | grep -q infra_network); then
    docker network create -d overlay --attachable infra_network
fi
