#!/bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1
sh get-docker.sh > /dev/null 2>&1

usermod -aG docker vagrant
