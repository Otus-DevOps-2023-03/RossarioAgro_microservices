#!/bin/bash

docker-machine create \
--driver generic \
--generic-ip-address=158.160.106.180 \
--generic-ssh-user yc-user \
--generic-ssh-key ~/.ssh/id_ed25519 \
docker-host
