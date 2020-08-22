#!/bin/bash
BASE=$(cd $(dirname $0);pwd)
ClientPath=/opt/redis-5.0.0/6379
Client=${ClientPath}/redis-cli
Ip=$(cat ${ClientPath}/redis.conf | grep -v '^#' | grep bind | awk '{print $2}'|sed 's#\r\|\n\|\r\n##g')
Port=6379


checkCount(){
    ct=$($Client --cluster check ${Ip}:${Port} 2>/dev/null | grep -E 'M|S' | wc -l )
    if [ "$ct" -ne 6 ];then
        echo "1"
        exit 1
    fi
}


checkMaster(){
    checkCount
    flag=$(${Client} --cluster check ${Ip}:${Port} 2>/dev/null | grep -E 'M|S' | grep ${Ip}:${Port} | awk -F: '{print $1}')
    if [[ "${flag}" =~ "M" ]]; then
        echo "0"
    else
        echo "1"
    fi
}

main(){
    checkMaster
}

main
