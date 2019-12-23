#!/bin/bash
BASE=$(cd $(dirname $0); pwd)

usage(){
    echo "$0  num(redis num in this server)"
}

checkNum(){
    count=$(ps -ef | grep -v grep | grep redis | wc -l)
    if [ $1 -gt $count ];then
        echo "1"
    else
        echo "0"
    fi
}


main(){
 if [ $# -lt 1 -o $# -ge 2 ];then
    usage
    exit 1
 fi
 checkNum $1
}

main $*