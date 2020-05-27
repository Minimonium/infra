#!/bin/bash

echo "infra: Installing Certificates..."

mkdir -p /etc/docker/certs.d/registry.${INFRA_DOMAIN}
cp ${INFRA_DIR}/config/certs/infra.crt /etc/docker/certs.d/registry.${INFRA_DOMAIN}/ca.crt
