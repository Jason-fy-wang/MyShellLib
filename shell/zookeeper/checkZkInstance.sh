#!/bin/bash
BASE=$(cd $(dirname $0);pwd)

zkCLi=/opt/zookeeper-3.4.14/bin/zkServer.sh
checkInstance(){
   id=($(ps -ef | grep -v "grep" | grep 'QuorumPeerMain' | awk '{print $2}'))
   if [ "${id[@]}" -le 0 ];then
        echo "1"
        exit 1
   fi

}

checkStatus(){
    $(${zkCLi}  status 2>/dev/null | grep -E "leader|follower") >/dev/null 2>&1
    if [ "$?" -gt 0 ]; then
        echo "1"
        exit 1
    fi
}

main(){
checkInstance
checkStatus
echo "0"
}

main