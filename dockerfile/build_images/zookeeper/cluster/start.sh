#!/usr/bin/env bash

# myid
echo "${ZOO_MY_ID}" > /opt/zookeeper/myid
# output cluster config
echo "${ZOO_SERVERS}" | awk -F' ' 'BEGIN{OFS="\n"}{print $1,$2,$3}' >> /opt/zookeeper/conf/zoo.cfg

/opt/zookeeper/bin/zkServer.sh start-foreground


