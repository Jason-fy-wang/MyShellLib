#!/bin/bash
BASE=$(cd $(dirname $0);pwd)
SERVER=${BASE}/9001/redis-server
CLIENT=${BASE}/9001/redis-cli
CONF=redis.conf

function startInstance(){
    for i in {9001..9002}
    do  
        echo "$SERVER $BASE/$i/$CONF"
        $SERVER $BASE/$i/$CONF 2>/dev/null 1>&2
    done
}

stopInstance(){
    echo "stopping instance"
    ps -ef | grep -v grep | grep 'redis-server' | awk '{print $2}' | xargs kill
}

usage(){
        echo "usage: $0 [start | stop | status]"
}

InstanceStatus(){
    ps -ef | grep -v grep | grep 'redis-server'
}

main(){

    if [ $# != 1 ];then
        usage
        exit 2
    fi  

    case $1 in
    'start')
        startInstance
        ;;  
    'stop')
        stopInstance
        ;;
    'status')
        InstanceStatus
        ;;
    *)
    usage
    ;;
    esac
}

main $@