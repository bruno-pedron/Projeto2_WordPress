#!/bin/bash

apt-get update -y
apt-get install -y docker.io nfs-common

systemctl start docker
systemctl enable docker

mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_dns_name}:/ /mnt/efs

docker run -d \
--name wordpress \
--restart always \
-p 80:80 \
-e WORDPRESS_DB_HOST=${rds_endpoint}:3306 \
-e WORDPRESS_DB_USER=${rds_user} \
-e WORDPRESS_DB_PASSWORD=${rds_password} \
-e WORDPRESS_DB_NAME=${rds_db_name} \
-v /mnt/efs:/var/www/html \
wordpress:latest