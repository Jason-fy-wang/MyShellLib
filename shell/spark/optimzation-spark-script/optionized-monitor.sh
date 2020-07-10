#!/bin/bash
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

FMStandard="com.ericsson.fcaps.fm.stream.AlarmStandard"
FMAMS="com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation"
FMADC="com.ericsson.fcaps.fm.stream.AlarmDerivationCorrelation"
Apps=($FMStandard $FMAMS $FMADC)
key1="Running Drivers"
key2="row-fluid"
# 从html中获取存在driver的类型
drivers=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>driver-[0-9]{14}-[0-9]{3,}" | awk '{print $1}' | awk 
-F'>' '{print $2}'))
# 从html中获取存在的driver对应的 id
ids=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>com[a-z.]{19,}" | awk '{print $1}' | awk -F'[<>]' '{print $3}' ))

if [ "${#drivers[@]}" -eq 3 ]; then
    echo 0
    exit
elif [ "${#drivers[@]}" -eq 0 ]
    echo "start all"
    echo 1
else 
    echo 1
    for al in ${Apps[@]}
    do
    count=0
        for dp in ${drivers[@]}
        do
            if [ "$al" == "$dp" ];then
                break
            else
                let count++
            fi
        done
        if [ "$count" -eq "${#drivers[@]}" ];then
            echo "start $al"
        if 
    done
fi
