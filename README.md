# Task-12-Redis-cluster-setup

1. Setup redis in cluster configuration with 3 nodes on single VM.
Don't forget to set redis client password.
1. Investigate what sentinel cluster is and what is the difference between
cluster and sentinel setup.

## Check:

```
root@node01:~# systemctl | grep redis
  redis-7001.service                  loaded active running   Redis Server 7001
  redis-7002.service                  loaded active running   Redis Server 7002
  redis-7003.service                  loaded active running   Redis Server 7003
  redis-7004.service                  loaded active running   Redis Server 7004
  redis-7005.service                  loaded active running   Redis Server 7005
  redis-7006.service                  loaded active running   Redis Server 7006
root@node01:~# redis-cli -c -p 7001 -a test01
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:7001> 
127.0.0.1:7001> cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:114
cluster_stats_messages_pong_sent:109
cluster_stats_messages_sent:223
cluster_stats_messages_ping_received:104
cluster_stats_messages_pong_received:114
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:223
total_cluster_links_buffer_limit_exceeded:0
127.0.0.1:7001> 
127.0.0.1:7001> cluster nodes
33d0a78b4152ef8dad67d5443fb69a1bbd9a6070 127.0.0.1:7006@17006 slave 4d14586774b96aa6313307ef41fbc47de3733384 0 1789500053000 2 connected
2984111f17dfecded56e9ff0a632d979df95244f 127.0.0.1:7004@17004 slave b875801d2e3c602757975460ed1a56a4ed524ca1 0 1789500054519 3 connected
b875801d2e3c602757975460ed1a56a4ed524ca1 127.0.0.1:7003@17003 master - 0 1789500053504 3 connected 10923-16383
4d14586774b96aa6313307ef41fbc47de3733384 127.0.0.1:7002@17002 master - 0 1789500054519 2 connected 5461-10922
6b1a616e9e5c565e63ae410ac3a6ad1b53b9af26 127.0.0.1:7005@17005 slave 62b4b7b16fa937b695bc6b2b40c6c380c83467e3 0 1789500054519 1 connected
62b4b7b16fa937b695bc6b2b40c6c380c83467e3 127.0.0.1:7001@17001 myself,master - 0 1789500053000 1 connected 0-5460
127.0.0.1:7001> 
127.0.0.1:7001> 
127.0.0.1:7001> SET mykey "Hello Redis"
-> Redirected to slot [14687] located at 127.0.0.1:7003
OK
127.0.0.1:7003> 
127.0.0.1:7003> GET mykey
"Hello Redis"
127.0.0.1:7003> 
127.0.0.1:7003> DEL mykey
(integer) 1
127.0.0.1:7003> 
127.0.0.1:7003> GET mykey
(nil)
127.0.0.1:7003> exit
root@node01:~# 
```
