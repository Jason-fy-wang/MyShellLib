#!/bin/bash
# chkconfig 2345 80 90
# description start service
Path=/opt/kafka_2.11
KafkaPath=${Path}/bin/kafka-server-start.sh
KafkaConfig=${Path}/config/server.properties

## 把此脚本放入到/etc/init.d目录下，就可以使用service命令来管理kafka服务了。
## 此操作相当于把kafka注册为系统服务了。
startKafka(){
 su - fcaps -c "nohup ${KafkaPath} -daemon ${KafkaConfig} >/dev/null 2>&1 &"
}

stopKafka(){
    pid=($(ps -ef | grep -Ev 'grep|root' | grep 'kafka' | awk '{print $2}'))
    if [ "${#pid[@]}" -le 0 ];then
        echo "no kafka running"
        exit 0
    else
        for pp in ${pid[@]}
        do
            echo "stopping $pp"
            #kill $pp
        done

    fi
}

statusKafka(){
    vv=($(ps -ef | grep -Ev 'grep|root' | grep 'kafka' | awk '{print $2}'))
    echo "kafka $vv running"
}

main(){

    if [ $# -ne 1 ]; then
        echo "usage: $0 [start | stop | restart | status]"
        exit 0
    fi
    case $1 in
    start)
        startKafka
    ;;
    stop)
        stopKafka
    ;;
    restart)
        stopKafka
        sleep 2
        startKafka
    ;;
    status)
        statusKafka
    ;;
    *)
        echo "usage: $0 [start | stop | restart | status]"
    ;;
    esac
}

main $1