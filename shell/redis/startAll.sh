#!/bin/bash
BASE=$(cd $(dirname $0);pwd)

startCluster(){

for i in `seq 9001 9006`
do
	echo "Starting $i"
	${BASE}/${i}/redis-server ${BASE}/${i}/redis.conf &
done

}

startCluster
