# Task-12-Redis-cluster-setup

1. Setup redis in cluster configuration with 3 nodes on single VM.
Don't forget to set redis client password.
1. Investigate what sentinel cluster is and what is the difference between
cluster and sentinel setup.

## Check:

```
root@node01:~# systemctl | grep redis
  redis-7001.service                 loaded active     running   Redis Server 7001
  redis-7002.service                 loaded active     running   Redis Server 7002
  redis-7003.service                 loaded active     running   Redis Server 7003
root@node01:~# 
root@node01:~# redis-cli -c -p 7001 -a test01
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:7001> 
127.0.0.1:7001> cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:3
cluster_size:3
cluster_current_epoch:3
cluster_my_epoch:1
cluster_stats_messages_ping_sent:50
cluster_stats_messages_pong_sent:56
cluster_stats_messages_sent:106
cluster_stats_messages_ping_received:54
cluster_stats_messages_pong_received:50
cluster_stats_messages_meet_received:2
cluster_stats_messages_received:106
127.0.0.1:7001> 
127.0.0.1:7001> cluster nodes
84decdf27faeec435b12ca85d71133b6a71d3df4 127.0.0.1:7003@17003 master - 0 1737654436250 3 connected 10923-16383
f29e43fdd6050863c12600b094fddd4ab7c584b9 127.0.0.1:7002@17002 master - 0 1737654437266 2 connected 5461-10922
40c09ab2a74c2e2d539ef133d2e8a79439fdc2cb 127.0.0.1:7001@17001 myself,master - 0 1737654435000 1 connected 0-5460
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
