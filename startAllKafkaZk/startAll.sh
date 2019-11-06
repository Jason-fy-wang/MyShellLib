#!/bin/bash
Base=$(cd $(dirname $0); pwd)
Hosts=($(awk '{print $0}' ${Base}/hosts))
ZkScript=startZk.sh
KafkaScript=startKafka.sh

startZk(){
for i in ${Hosts[@]}
do
        echo "$1 $i zk"
        ssh root@${i} "source /etc/profile; sh /mnt/${ZkScript} $1"
done
}


StartKafka(){
for i in ${Hosts[@]}
do
        echo "$1 $i kafka"
        ssh root@${i} "source /etc/profile;sh /mnt/${KafkaScript} $1"
done
}


main(){

case $1 in
startZk)
startZk start
;;

stopZk)
startZk stop
;;

statusZk)
startZk status
;;

startKafka)
StartKafka start
;;

stopKafka)
StartKafka stop
;;

statusKafka)
StartKafka status
;;

*)
 echo "$0 startZk | startKafka | stopZk | stopKafka | statusZk | statusKafka"
;;

esac

}

main $1
