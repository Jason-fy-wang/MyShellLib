#!/bin/bash
BASE=$(cd $(dirname $0);pwd)

stop(){
PID=($(ps -ef | grep -v grep | grep redis-server | awk '{print $2}'))   # 注意这里准换为数组，这样下面才好直接使用数组
if [ ${#PID[@]} -gt 1 ];then
  for pid in ${PID[@]}
  do
    echo "stop redis  $pid"
    kill -9 $pid
  done

else
  echo "no redis is running"
fi

}

stop
~        