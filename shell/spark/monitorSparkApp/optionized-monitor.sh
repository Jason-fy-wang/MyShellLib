#!/bin/bash
. /etc/profile
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
count=0

checkMaster(){
for tmp in ${HOSTS}
do
    if [ -n $tmp ]; then
        result=($(curl -s http://${tmp}:8080 | grep Status: | grep ALIVE ))
        if [ ${#result[@]} -ge 1 ]; then
            echo "the Active Master is: " ${tmp}
            MASTER=${tmp}
            break
        else
            let count++
        fi
        if [ $count -eq ${Nhosts} ];then
            echo "Exception: No Active Master running now."
            echo 1
            exit 1
        fi
    fi
done
}
checkMaster
FMStandard="com.ericsson.fcaps.fm.stream.AlarmStandard"
FMAMS="com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation"
FMADC="com.ericsson.fcaps.fm.stream.AlarmDerivationCorrelation"
Apps=($FMStandard $FMAMS $FMADC)
lena=${#Apps[@]}
let lena1=$len-1
key1="Running Drivers"
key2="row-fluid"
# 从html中获取存在driver的类型
ids=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>driver-[0-9]{14}-[0-9]{3,}" | awk '{print $1}' | awk 
-F'>' '{print $2}'))
# 从html中获取存在的driver对应的 id
drivers=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>com[a-z.]{19,}" | awk '{print $1}' | awk -F'[<>]' '{print $3}' ))
lend=${#drivers[@]}
let lend1=$len-1

# 所有的driver都在运行
if [ "${#drivers[@]}" -eq "${lena}" ]; then
    echo 0
    exit
elif [ "${#drivers[@]}" -eq 0 ];then   # 所有的driver都停止了. 则启动全部
    echo "start all"
    echo 1
else        # 某一个停止了,单独拉起
    echo 1
    for ai in $(seq 0 ${lena1})     # Apps中程序在运行的drivers中没有,则拉起
    do
        count=0
        for dp in $(seq 0 ${lend1})
        do
            if [ "${drivers[$dp]}" == "${Apps[$ai]}" ]; then
                break
            else
                let count++
            fi
        done
        if [ "$count" -eq "${#drivers[@]}" ]; then
            echo "start ${Apps[$ai]}"
        fi
    done
fi
