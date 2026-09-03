
require "yaml"
vagrant_root = File.dirname(File.expand_path(__FILE__))
settings = YAML.load_file "#{vagrant_root}/settings.yaml"

IP_SECTIONS = settings["network"]["control_ip"].match(/^([0-9.]+\.)([^.]+)$/)
# First 3 octets including the trailing dot:
IP_NW = IP_SECTIONS.captures[0]
# Last octet excluding all dots:
IP_START = Integer(IP_SECTIONS.captures[1])
NUM_WORKER_NODES = settings["nodes"]["workers"]["count"]

Vagrant.configure("2") do |config|
  config.vm.box_architecture = "amd64"
  config.vm.provision "shell", env: { "IP_NW" => IP_NW, "IP_START" => IP_START, "NUM_WORKER_NODES" => NUM_WORKER_NODES }, inline: <<-SHELL
  apt-get update -y
  apt install redis -y
  for i in `seq 1 ${NUM_WORKER_NODES}`; do
    echo "$IP_NW$((IP_START+i)) node0${i}" >> /etc/hosts
  done
  mkdir -p ~/redis-cluster/{7001,7002,7003,7004,7005,7006}

for PORT in 7001 7002 7003 7004 7005 7006; do
  mkdir -p ~/redis-cluster/${PORT}
  cat <<EOF > ~/redis-cluster/${PORT}/redis.conf
port ${PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
dir /root/redis-cluster/${PORT}
loglevel notice
logfile /var/log/redis/redis-${PORT}.log
requirepass test01
masterauth test01
EOF

  cat <<EOF > /etc/systemd/system/redis-${PORT}.service
[Unit]
Description=Redis Server ${PORT}
After=network.target

[Service]
User=root
Group=root
ExecStart=/usr/bin/redis-server /root/redis-cluster/${PORT}/redis.conf
ExecStop=/usr/bin/redis-cli -p ${PORT} shutdown
Restart=always

ReadWritePaths=-/var/lib/redis
ReadWritePaths=-/var/log/redis
ReadWritePaths=-/var/run/redis

[Install]
WantedBy=multi-user.target
EOF
done

SHELL

  config.vm.box = settings["software"]["box"]

  config.vm.box_check_update = true

  (1..NUM_WORKER_NODES).each do |i|

    config.vm.define "node0#{i}" do |node|
      node.vm.hostname = "node0#{i}"
      node.vm.network "private_network", ip: IP_NW + "#{IP_START + i}"
      if settings["shared_folders"]
        settings["shared_folders"].each do |shared_folder|
          node.vm.synced_folder shared_folder["host_path"], shared_folder["vm_path"]
        end
      end
      node.vm.provider "vmware_fusion" do |vb|
          vb.cpus = settings["nodes"]["workers"]["cpu"]
          vb.memory = settings["nodes"]["workers"]["memory"]
      end
      node.vm.provision "shell", path: "scripts/node.sh"

    end

  end
end 
