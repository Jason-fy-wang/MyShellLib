#!/bin/bash

ClientPath=/opt/redis-5.0.0/
Port=6379
Client=${ClientPath}${Port}/redis-cli

forget(){
    id=$1
    ips=($(ps -ef | grep -v grep | grep redis-server | awk '{print $9}'))
    echo "len=${#ips[@]}"
    ip=$(echo ${ips[0]} | cut -d: -f1)
    port=$(echo ${ips[0]} | cut -d: -f2)
    allnodes=($(${Client} -h ${ip} -p ${port} cluster nodes | grep -v  "${id}"  | awk '{print $2}' | cut -d@ -f1))
    for i in ${allnodes[@]}
    do
        echo $i
        ip=$(echo ${i} | cut -d: -f1)
        port=$(echo ${i} | cut -d: -f2)
        $(${Client} -h ${ip} -p ${port} cluster forget $id > /dev/null 2>&1)  
    done
}

forget $1

# sh foret.sh b29f9a84ac158136633933d7a470288d50ba6c51