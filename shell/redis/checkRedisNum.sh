#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
Port=6379
ClientPath=/opt/redis-5.0.0/
Client=${ClientPath}${Port}/redis-cli
Server=${ClientPath}${Port}/redis-server
conf=redis.conf
Ip=$(cat ${ClientPath}${Port}/${conf} | grep -v '^#' | grep bind | awk '{print $2}'|sed 's#\r\|\n\|\r\n##g')

runcmd(){
    cc=$@
    if [ "$(whoami)" != "fcaps" ]; then
        su - fcaps -c "$cc"
    else
        $(${cc})
    fi
}

usage(){
    echo "$0  num(redis num in this server)"
}

promote(){
    flag=$(${Client} --cluster check ${Ip}:${Port} 2>/dev/null | grep -E 'M|S' | grep ${Ip}:${Port} | awk -F: '{print $1}')
    if [[ "${flag}" =~ 'M' ]];then
        echo "0"
    else
        $(${Client} -h $Ip -p $Port cluster failover force) > /dev/null 2>&1
        sleep 4

        flag=$(${Client} --cluster check ${Ip}:${Port} 2>/dev/null | grep -E 'M|S' | grep ${Ip}:${Port} | awk -F: '{print $1}')
        if [[ "${flag}" =~ 'M' ]];then
            echo "0"
        else
            echo "1"
        fi
    fi     
}

startInstance(){
    pp=(6379 6389)
    for i in ${pp[@]}
    do
        $( ps -ef | grep -v grep| grep 'redis-server' | awk '{print $9}' | awk -F: '{print $2}' | grep "$i" >/dev/null 2>&1)
        if [ "$?" -ne "0" ]; then
            runcmd ${Server}  ${ClientPath}${i}/${conf}
        fi
    done
}

checkNum(){
    count=$(ps -ef | grep -v grep | grep redis-server | wc -l)
    if [ "$1" -ne "$count" ];then
        echo "1"
        startInstance
    else
        promote
    fi
}


main(){
 if [ -z "$1" ];then
  checkNum 2
 else
 checkNum $1
 fi
}

main $*
