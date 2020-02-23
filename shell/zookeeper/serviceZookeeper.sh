#!/bin/bash
# chkconfig 2345 80 90
# description start service
ZKPath=/root/zookeeper-3.4.14/bin/zkServer.sh

startZk(){
 ${ZKPath} $1 2>/dev/null 
}

statusZk(){
 ${ZKPath} status
}

main(){
    if [ $# -ne 1 ]; then
        echo "usage: $0 [start | stop | restart | status]"
        exit 0
    fi  
    case $1 in
    start)
     startZk $1
    ;;  
    stop)
     startZk $1
    ;;  
    restart)
      startZk stop
      sleep 2
      startZk start
    ;;  
    status)
      statusZk
    ;;  
    *)  
        echo "usage: $0 [start | stop | restart | status]"
    ;;
    esac
}

main $1