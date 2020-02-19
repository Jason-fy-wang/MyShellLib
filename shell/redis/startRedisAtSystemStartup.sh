#!/bin/bash
#chkconfig:2345 80 90
#description start service

KafkaPath=/opt/kafka_2.11-2.2.0/bin/kafka-server-start.sh
KafkaConfig=/opt/kafka_2.11-2.2.0/config/server.properties
ZKPath=/opt/zookeeper-3.4.14/bin/zkServer.sh
REDIS=/opt/redis-cluster
SERVER=$REDIS/9001/redis-server
CONF=redis.conf

## 此脚本用于开机使用fcaps用户启动redis  kakfa  zookeeper 中间件
## 把此脚本放到 /etc/rc.d/init.d/ 目录中，使用 chkconfig --add custom.sh  加入开机启动
startInstance(){
    for i in {9001..9002}
    do  
        echo "$SERVER $BASE/$i/$CONF"
        su - fcaps  -c "$SERVER $REDIS/$i/$CONF " > /dev/null 2>&1 
    done
}

startK(){
 su -  fcaps  -c "nohup ${KafkaPath} -daemon ${KafkaConfig} &"  >/dev/null 2>&1
}

startZk(){
 su -  fcaps -c "${ZKPath} start " >/dev/null 1>&2 
}

main(){
startZk
startInstance
startK
}

main