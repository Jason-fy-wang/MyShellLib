#!/bin/bash
BASE=$(cd $(dirname $0); pwd)

checkInstance(){
 slave=$(ps -ef |grep -v grep  |grep 'org.apache.spark.deploy.worker.Worker' | wc -l)

 master=$(ps -ef |grep -v grep  |grep 'org.apache.spark.deploy.master.Master' | wc -l)
 
 if [ ${master} -le 0 ];then
    $(service spark startMaster) >/dev/null 1>&2
    echo 1
    exit 1
else
    echo 0
 fi
 
 if [ ${master} -le 0 ];then
    $(service spark startSlave) >/dev/null 1>&2
    echo 1
    exit 1
else 
    echo 0
 fi
}

main(){
checkInstance
}

main
