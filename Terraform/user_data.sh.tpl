#!/bin/bash

apt-get update -y
apt-get install -y docker.io docker-compose-v2 nfs-common

systemctl start docker
systemctl enable docker

mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_dns_name}:/ /mnt/efs

cd /home/ubuntu

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: ${rds_endpoint}:3306
      WORDPRESS_DB_USER: ${rds_user}
      WORDPRESS_DB_PASSWORD: ${rds_password}
      WORDPRESS_DB_NAME: ${rds_db_name}
    volumes:
      - /mnt/efs:/var/www/html
EOF

docker compose up -d
