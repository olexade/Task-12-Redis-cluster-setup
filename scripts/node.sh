#!/bin/bash
#
# Setup for Node servers

set -euxo pipefail

config_path="/vagrant/configs"

PORTS="7001 7002 7003 7004 7005 7006"

for PORT in ${PORTS}; do
  sudo systemctl enable redis-${PORT}.service
done

for PORT in ${PORTS}; do
  sudo systemctl start redis-${PORT}.service
done

systemctl stop redis-server.service
systemctl disable redis-server.service

sleep 10

NODES=""
for PORT in ${PORTS}; do
  NODES="${NODES} 127.0.0.1:${PORT}"
done

# First 3 nodes become masters, remaining 3 become their replicas
sudo /usr/bin/redis-cli --cluster create ${NODES} --cluster-replicas 1 -a test01 --cluster-yes

sudo -i -u vagrant bash << EOF

whoami
NODENAME=$(hostname -s)

EOF
