#!/bin/bash
BASE=$(cd $(dirname $0); pwd)

checkInstance(){
 slave=$(ps -ef |grep -v grep  |grep 'org.apache.spark.deploy.worker.Worker' | wc -l)

 master=$(ps -ef |grep -v grep  |grep 'org.apache.spark.deploy.master.Master' | wc -l)
 if [ $slave -eq 1 -a $master -eq 1 ];then
   echo 0
 else
   echo 1
 fi

}

main(){
checkInstance
}

main
