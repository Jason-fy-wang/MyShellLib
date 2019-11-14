#!/bin/bash
ZKPath=/mnt/zookeeper-3.4.5-cdh5.12.0/bin/zkServer.sh

startZk(){
 ${ZKPath} $1
}

usage(){
  echo "$0 start|stop|restart|status"
}

main(){

case $1 in

start)
startZk $1
;;

stop)
startZk $1
;;

restart)
startZk $1
;;

status)
startZk $1
;;

*)
usage
;;
esac


}

main $1
