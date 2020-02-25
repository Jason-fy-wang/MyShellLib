#!/bin/bash
# chkconfig:2345 80 90
# description start service
ZKPath=/opt/zookeeper-3.4.14/bin/zkServer.sh

## 加上用户判断，不然fcaps用户执行会让输入密码
SUDO_fcaps=""
if [ "$(whoami)" != "fcaps" ]; then
    SUDO_fcaps="su - fcaps -c"
fi

## 当前用户如果不是fcaps，则使用fcaps用户执行命令，如果是fcaps用户，则直接执行命令
executeCMD(){
    if [ "${SUDO_fcaps}" != "" ];then
        ${SUDO_fcaps} "$1" 2>/dev/null
    else
        $1 2>/dev/null
    fi  
}

startZk(){
 executeCMD "${ZKPath} $1 2>/dev/null"
}

statusZk(){
 executeCMD "${ZKPath} status"
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