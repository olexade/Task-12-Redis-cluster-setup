#!/bin/bash
#
# Setup for Node servers

set -euxo pipefail

config_path="/vagrant/configs"

#sudo /usr/bin/redis-server /root/redis-cluster/7001/redis.conf &
#sudo /usr/bin/redis-server /root/redis-cluster/7002/redis.conf &
#sudo /usr/bin/redis-server /root/redis-cluster/7003/redis.conf &

sudo systemctl enable redis-7001.service
sudo systemctl enable redis-7002.service
sudo systemctl enable redis-7003.service

sudo systemctl start redis-7001.service
sudo systemctl start redis-7002.service
sudo systemctl start redis-7003.service

systemctl stop redis-server.service
systemctl disable redis-server.service

sleep 10

sudo /usr/bin/redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 --cluster-replicas 0 -a test01 --cluster-yes

sudo -i -u vagrant bash << EOF

whoami
NODENAME=$(hostname -s)

EOF
