#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
STATEPATH="/opt/ericsson/nfvo/fcaps/config/common/nfvo-state"
CLIPATH="/opt/kafka-2.11/bin/kafka-consumer-groups.sh"
Logpath="/opt/ericsson/nfvo/fcaps/work/sm/"
FlagPath="/opt/ericsson/nfvo/fcaps/runtime_log/sm/"

# check if master
checkIfMaster(){
    local con=$(cat ${STATEPATH})
    if [ "${con}" != "MASTER" ];then
        logRecord "Not Master , exist."
        exit 1
    else
        logRecord "Master."
    fi
}

# recordLog
logRecord(){
    echo "$1" >> ${Logpath}/$0-$(date +"%F").log
}

# get ossids
getOssids(){
    echo "JTOSS GDOSS"
}

# if check
# 0 check, other no check
ifCheck(){
    local hh=$(hostname)
    local len=${#hh}
    local ff=${hh:${len}-1:1}
    local mm=$(date +"%M")
    let fres=${ff}%3
    let mres=${mm}%3
    if [ "${fres}" == "${mres}" ];then
        logRecord "hostname mod 3 = curMinute mod 3"
        echo "0"
    else
        logRecord "hostname mod 3 != curMinute mod 3"
        echo "1"
    fi
}

checkLag(){
    echo "1 = $1"
    echo "2 = $2"
    echo "3 = $3"
    thres=$3
    ids=($(getOssids))
    logRecord "ids length: ${#ids[@]}"
    if [ "$(ifCheck)" -eq 0 -a  ${#ids[@]} -gt 0]; then
        for id in ${ids[@]}
        do
            echo $id
            lagsum=$(${CLIPATH} --bootstrap-server 10.163.249.146:9092  --describe --group "alarm_consumer_${id}" | awk '{print $5}' | grep -v 'LAG' | awk '{sum += $1} END {print sum}')
            echo "lagsum: $lagsum"
            if [ "$lagsum" > $thres ];then
                sendSelfAlarm $id
            else
                sendSelfClearAlarm $id
            fi
        done
    else
        logRecord "Do not need to check."
    fi
}

sendSelfAlarm(){
    id=$1
    if [ "$(checkIfAlreadySend $id)" -gt 0 ]; then
        logRecord "begin to send alarm."
        alarm=$(genAlarm $id)
        logRecord "send alarm: $alarm"
        if [ ! -d ${FlagPath} ];then
            `mkdir -p ${FlagPath}`
        fi
        $(touch ${FlagPath}${id}_pileup)
    else
        logRecord "Already send alarm."
    fi
}

sendSelfClearAlarm(){
    id=$1
    if [ "$(checkIfNeedClear $id)" -eq 0 ];then
        logRecord "begin to send clear alarm."
        clear=$(genClear $id)
        logRecord "send clear: $clear"
        $(rm -f ${FlagPath}${id}_pileup)
    else
        logRecord "Needn't to send clear."
    fi
}

# check if send alarm already
# 0 没有发送过, 1 发送过, 参数为ossid
checkIfAlreadySend(){
    if [ -e "${FlagPath}${1}_pileup" ];then
        echo "0"
    else
        echo "1"
    fi
}

# check: need send clear alarm
# 0 需要发送
checkIfNeedClear(){
    if [ -e "${FlagPath}$1_pileup" ];then
        echo "0"
    else
        echo "1"
    fi
}

# generate alarm
genAlarm(){
    echo "{\"key\":\"NFVO_OSSmsgPileup\",\"level\":\"L1\",\"object\":\"$1\",\"content\":\"kafka topic:alarm_consumer_$1，超过积压阈值:3000\",\"hostname\":\"$(hostname)\", \"eventTime\":\"$(date +'%F %T')\"}"
}

# generate clean alarm
genClear(){
echo "{\"key\":\"NFVO_OSSmsgPileup\",\"object\":\"$1\",\"hostname\":\"$(hostname)\", \"eventTime\":\"$(date +'%F %T')\", \"cleared\":true}"
}

# usage
usage(){
    echo "usage: $0 ossgwIp smIp threshold"
    exit
}

main(){
    if [ $# -le 0 ];then
        usage
        exit
    fi
    checkLag $@
}

main $@

