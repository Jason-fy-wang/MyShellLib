#!/bin/bash
#chkconfig:2345 80 90
#description start service
REDIS=/opt/redis-cluster/9001
SERVER=$REDIS/redis-server
Client=$REDIS/redis-cli
CONF=redis.conf

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

## 把此脚本放入到 /etc/init.d中就相当与把redis注册为系统服务，可以使用service管理
startInstance(){
    for i in {9001..9002}
    do
        echo "$SERVER $BASE/$i/$CONF"
        executeCMD "$SERVER $REDIS/$i/$CONF"
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
            executeCMD  "$Client -h $h -p $p shutdown"
        done
    fi
}

statusInstance(){
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

# 查看集群的节点信息
nodesinfo(){
    ips=($(ps -ef| grep -v grep| grep "redis-server" | awk '{print $9}'))
    if [ "${#ips[@]}" -le 0 ]; then
        echo "no redis running"
        exit 0
    else
        local hh=$(echo ${ips[1]} | awk -F: '{print $1}')
        local pp=$(echo ${ips[1]} | awk -F: '{print $2}')
        if [ -n "${hh}" -a -n "${pp}" ];then
            executeCMD "$Client -h $hh -p $pp cluster nodes"
        fi  
    fi  
}
#  对某个节点进行晋升
failover(){
    local tt=$1
    local pt=${tt:=6379}
    
    ips=($(ps -ef| grep -v grep| grep "redis-server" | awk '{print $9}'))
    if [ "${#ips[@]}" -le 0 ]; then
        echo "no redis running"
        exit 0
    else
        local hh=$(echo ${ips[1]} | awk -F: '{print $1}')
        if [ -n "${hh}" ];then
            if [ "${SUDO_fcaps}" != "" ];then
                ${SUDO_fcaps}  "$Client -h $hh -p $pt cluster failover"
            else
                $Client -h $hh -p $pt cluster failover
            fi  
            echo 'su - ${USER} -c "$Client -h $hh -p $pt cluster failover"'
        fi  
    fi  

}


main(){
    if [ $# != 1 ]; then
        echo "usage: $0 [start | stop | restart | status | nodesinfo | failover [port]]"
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
    nodesinfo)
        nodesinfo
    ;;
    failover)
        failover $2
    status) 
        statusInstance  
    ;;                          
    *)                              
        echo "usage: $0 [start | stop | restart | status | nodesinfo | failover [port]]"
    ;;                                                  
    esac                                                                
}                                                                               
                                                                                    
main $@