#!/bin/bash

KAFKA_HOME=/opt/kafka-2.11
ZK_ADDR=$1

rm -f /tmp/kafka-topic-partitions
## 获取所有的topic 以及 partitions 并放入到 kafka-topic-partitions文件中
$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper $ZK_ADDR|grep -v __|while read line
do
     $KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper $ZK_ADDR --topic $line >>/tmp/kafka-topic-partitions 2>/dev/null
done
cat /tmp/kafka-topic-partitions|grep "Topic:"|grep "Partition:"|awk -F " " '{print $2 " " $4}' >/tmp/kafka-topic-partitions1

# 获取topic的总数
PN=`wc -l /tmp/kafka-topic-partitions1|awk -F " " '{print $1}'`
echo "Total partitions: $PN"

# 生成json文件的头部
echo "{" >"result.json"
echo '    "version": 1,' >>result.json
echo '    "partitions": [' >>result.json

# 遍历生成每个topic以及其partition的文件
((ii=0))
cat /tmp/kafka-topic-partitions1|while read line
do
   TP=`echo $line|awk -F " " '{print $1}'`
   PI=`echo $line|awk -F " " '{print $2}'`

   ((ii = ii+1))
   #echo "ii: $ii  PN: $PN"
   if [ "$PN" = "$ii" ]; then
       echo "        { \"topic\": \"$TP\", \"partition\": $PI, \"replicas\": [1,2,3] }" >>result.json
   else   
       echo "        { \"topic\": \"$TP\", \"partition\": $PI, \"replicas\": [1,2,3] }," >>result.json
   fi
done

# json文件的尾部
echo '    ]' >>result.json
echo '}' >>result.json

# 执行json文件，然后进行副本数的增加操作
$KAFKA_HOME/bin/kafka-reassign-partitions.sh --zookeeper  $ZK_ADDR --reassignment-json-file result.json --execute
$KAFKA_HOME/bin/kafka-reassign-partitions.sh --zookeeper  $ZK_ADDR --reassignment-json-file result.json --verify

rm result.json
rm /tmp/kafka-topic-partitions1
rm /tmp/kafka-topic-partitions
