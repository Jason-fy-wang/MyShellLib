#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
# 一条命令获取某个 group的 lag总数
# ./kafka-consumer-groups.sh --bootstrap-server 10.163.249.148:9092 --describe --group fm-app-group | awk '{print $5}' | sed ':lab;N;s/\n/ /;b lab' | awk 'BEGIN{ct=0}{split($0,arr," "); for(i=2;i<=length(arr);i++){print arr[i]; ct+=arr[i]}} END{print ct}


usage(){
 echo "$0  ip(kafka ip) count(default 10000)  cmd(kafka-consumer-groups.sh full path)  port(kafka listening port) group(group name)"
}

getTotalag(){
    ip=$1
    count=$2
    cmd=$3
    port=$4
    group=$5
    echo "cmd $cmd, group: $group, ip: $ip, port: ${port}"
    fcmd="${cmd:=/opt/kafka-2.11/bin/kafka-consumer-groups.sh}  --bootstrap-server  ${ip:=10.163.249.148}:${port:=9092}  --describe --group ${group:=fm-app-group} | awk '{print $5}' | sed ':lab;N;s/\n/ /;b lab'"
    dd=$(${cmd:=/opt/kafka-2.11/bin/kafka-consumer-groups.sh}  --bootstrap-server  ${ip:=10.163.249.148}:${port:=9092}  --describe --group ${group:=fm-app-group} | awk '{print $5}' | sed ':lab;N;s/\n/ /;b lab')
    
    echo $dd | grep 'LAG' 1>/dev/null 2>&1
    last=0
    if [ $? -eq 0 ];then
        for i in $dd
        do
            if [[ $i == 'LAG' ]];then
                continue
            else
                let last+=$i
            fi
        done
    else
        echo 1
    fi
    echo $last
    if [[ ${last} <=  ${count:=1} ]];then
        echo 0
    else
        echo 1
    fi
    
}

main(){
    case $1 in
    'usage')
        usage
        ;;
    *)
      getTotalag $*
      ;;
    esac
}

main $*