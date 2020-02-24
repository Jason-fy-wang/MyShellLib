#!/bin/bash
#chkconfig:2345 80 90
#description: spark service
# 此脚本用于spark的日常运维操作，并使用指定用户启停服务
ss=$(which bash 2>/dev/null)
run=${ss:=/bin/bash}
Hosts=(name1 node1 node2)
Port=8081
ServerPort=7077
Path=/root/spark-2.4.3-bin-hadoop2.7/sbin
SMaster=${Path}/start-master.sh
SSlave=${Path}/start-slave.sh
PMaster=${Path}/stop-master.sh
PSlave=${Path}/stop-slave.sh
USER=fcaps

# 获取master的IP和端口，格式: ip:port
getMaster(){
    local cc=0
    for hh in ${Hosts[@]}
    do  
        tt=$(curl -X GET http://${hh}:${Port} 2>/dev/null | grep "Status" | grep "ALIVE")
        if [ "$?" -eq 0 ];then
            iph=$(curl -X get http://${hh}:${Port} 2>/dev/null | grep "URL" | awk -F'//' '{print $2}' | awk -F'<' '{print $1}')
            echo $iph
        else
            let cc+=1
        fi  
        if [ "$cc" -ge "${#Hosts[@]}" ];then
            echo "No Master running"
            exit 1
        fi  
    done
}

# 使用fcaps用户启动本机上的master
startMaster(){
    ck=$(ps -ef | grep -v grep |  grep 'org.apache.spark.deploy.master.Master' | awk '{print $2}')
    if [ -z "$ck" ];then        # master没有启动则启动
        echo "starting Master..."
        su - ${USER} -c "$run  $SMaster >/dev/null 2>&1"
    else                    # master已经启动，则不进行启动操作
        echo "Master $ck is running"
        exit 0
    fi  
}

# 使用fcaps用户关闭本机上的master操作
stopMaster(){
    ck=($(ps -ef | grep -v grep |  grep 'org.apache.spark.deploy.master.Master' | awk '{print $2}'))
    if [ "${#ck[@]}" -le 0 ];then   # 没有启动master，则不进行操作
        echo "No Master running"
        exit 1
    else        # 启动了master  则进行停止操作
        echo "stopping master  $ck"
        su - ${USER} -c "$run $PMaster >/dev/null 2>&1"
    fi
}

restartMaster(){
    stopMaster
    sleep 3
    startMaster
}
startSlave(){
    ck=$(ps -ef | grep -v grep |  grep 'org.apache.spark.deploy.worker.Worker' | awk '{print $2}')
    if [ -z "$ck" ];then
        ipm=$(getMaster)
        if [ -n "$ipm" ]; then
            echo "starting slave..."
            su - ${USER} -c "$run $SSlave $ipm >/dev/null 2>&1"
        else
            echo "No Master running"
        fi
    else
        echo "Slave $ck is running"
        exit 0
    fi
}

stopSlave(){
    ck=$(ps -ef | grep -v grep |  grep 'org.apache.spark.deploy.worker.Worker' | awk '{print $2}')
    if [ -n "$ck" ]; then
        echo "stopping slave  $ck"
        su -${USER} -c "$run $PSlave >/dev/null 2>&1"
    else
        echo "No Slave Running"
        exit 1
    fi
}

restartSlave(){
    stopSlave
    sleep 3
    startSlave
}

startAll(){
    startMaster
    sleep 3
    startSlave
}

stopAll(){
    stopSlave
    stopMaster
}

restartAll(){
    restartMaster
    restartSlave
}
statusAll(){
    ck=$(ps -ef | grep -v grep |  grep 'org.apache.spark.deploy.worker.Worker' | awk '{print $2}')
    ck1=($(ps -ef | grep -v grep |  grep 'org.apache.spark.deploy.master.Master' | awk '{print $2}'))
    if [ -n "$ck" ]; then
        echo "Slave $ck Running"
    fi

    if [ -n "$ck1" ]; then
        echo "Master $ck1 Running"
    fi
}
main(){
    if [ "$#" -ne 1 ];then
        echo "usage:$0 [start| stop |restart | status | startMaster | stopMaster | restartMaster | startSlave | stopSlave | restartSlave]"
        exit 0
    fi
    case $1 in
    start)
        startAll
    ;;
    stop)
        stopAll
        ;;
    restart)
        restartAll
        ;;
    status)
        statusAll
        ;;
    startMaster)
        startMaster
        ;;
    stopMaster)
        stopMaster
        ;;
    restartMaster)
        restartMaster
        ;;
    startSlave)
        startSlave
        ;;
    stopSlave)
        stopSlave
        ;;
    restartSlave)
        restartSlave
        ;;
    *)
        echo "usage:$0 [start| stop |restart | status | startMaster | stopMaster | restartMaster | startSlave | stopSlave | restartSlave]"
         ;;
    esac
}

main $1