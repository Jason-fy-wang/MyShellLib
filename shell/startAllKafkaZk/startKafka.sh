#!/bin/bash
KafkaPath=/mnt/kafka_2.11-2.2.0/bin/kafka-server-start.sh
KafkaConfig=/mnt/kafka_2.11-2.2.0/config/server.properties


startK(){
 nohup ${KafkaPath} -daemon ${KafkaConfig} &
 exit
}


stopK(){
 pid=($(jps -l | grep -v geep | grep 'kafka' | awk '{print $1}'))

 if [ ${#pid[@]} -gt 0 ];then

    for id in ${pid[@]}
    do
        echo "stop $id"
        kill -9 $id
    done

 fi

}

restartK(){
stopK
sleep 2
startK
}

statusKafka(){
   pids=($(jps -l | grep -v grep | grep kafka | awk '{print $1}'))
   if [ ${#pids[@]} -eq 1 ];then
        echo "${pids[0]} running ... "
   fi
}

main(){
case $1 in

start)
startK
;;
stop)
stopK
;;
restart)
restartK
;;

status)
statusKafka
;;

*)
echo "$0 start | stop | restart | status" 
;;

esac
}

main $1
