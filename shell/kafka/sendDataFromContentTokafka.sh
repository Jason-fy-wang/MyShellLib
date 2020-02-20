#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
CMD=/opt/kafka-2.11/bin/kafka-console-producer.sh
IP=$(cat /opt/kafka-2.11/config/server.properties  | grep 'advertised.listeners'  | awk -F'//' '{print $2}')


readContent(){

   if [ "$#" -ne 1 ]; then
        echo "usage: $0  pathfile"
        exit 1
   fi

    cat $1 | while read line        # 一行一行读取文件内容，然后把内容发送到kakfa
        do
                echo $line | $CMD --broker-list $IP -sync -topic test | >/dev/null
        done
}

readContent $@
