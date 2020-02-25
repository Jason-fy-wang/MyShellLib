#!/bin/bash
#chkconfig:2345 80 90
#description start service
REDIS=/opt/redis-5.0.0/6379
SERVER=$REDIS/redis-server
Client=$REDIS/redis-cli
CONF=redis.conf

## 把此脚本放入到 /etc/init.d中就相当与把redis注册为系统服务，可以使用service管理
startInstance(){
    for i in {6379, 6389}
    do
        echo "$SERVER $BASE/$i/$CONF"
        su - fcaps  -c "$SERVER $REDIS/$i/$CONF " > /dev/null 2>&1
    done
}

stopInstance(){
    ips=($(ps -ef| grep -v grep| grep "redis-server" | awk '{print $9}'))
    if [ "${#ips[@]}" -le 0 ]; then
        echo "no redis running"
        exit 0
    else
        for vv in ${ips[@]}
        do
            h=$(echo $vv | awk -F: '{print $1}')
            p=$(echo $vv | awk -F: '{print $2}')
            su - fcaps -c "$Client -h $h -p $p shutdown" >/dev/null 2>&1
        done
    fi
}statusInstance(){
    ips=($(ps -ef| grep -v grep| grep "redis-server" | awk '{print $9}'))
    if [ "${#ips[@]}" -le 0 ]; then
        echo "no redis running"
        exit 0
    else
        for vv in ${ips[@]}
        do
            echo "$vv is running"
        done
    fi
}


main(){
    if [ $# != 1 ]; then
        echo "usage: $0 [start | stop | restart | status]"
        exit 0
    fi
    case $1 in
    start)
     startInstance
    ;;
    stop)
     stopInstance
    ;;
    restart)
     stopInstance
    ;;
    restart)
     stopInstance
     sleep 2
     startInstance
    ;;  
    status) 
        statusInstance  
    ;;                          
    *)                              
        echo "usage: $0 [start | stop | restart | status]"
    ;;                                                  
    esac                                                                
}                                                                               
                                                                                    
main $1