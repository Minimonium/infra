#!/bin/bash

# TODO: Extract Node configuration files to an outer folder

mkdir -p /etc/docker/certs.d/registry.${INFRA_DOMAIN}
cp /vagrant/infra/services/core/config/certs/infra.crt /etc/docker/certs.d/registry.${INFRA_DOMAIN}/ca.crt
