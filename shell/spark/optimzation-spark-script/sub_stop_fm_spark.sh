#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')

usage(){
    echo  "1--> AlarmStandard  2-->AlarmMasterSlaveCorrelation 3-->AlarmDerivationCorrelation"
    echo "$0  1 | 2 | 3 | all"
}

if [ $# -ne 1 ];then
    usage
    exit 1
fi

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
key1="Running Drivers"
key2="row-fluid"
ids=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>driver-[0-9]{14}-[0-9]{3,}" | awk '{print $1}' | awk 
-F'>' '{print $2}'))
drivers=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>com[a-z.]{19,}" | awk '{print $1}' | awk -F'[<>]' '{print $3}' ))
len=${#drivers[@]}
let len1=$len-1

stopId(){
    id=$1
    ${CMD} ${ClassName} kill spark://${MASTER}:7077 $id  >>${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log 2>&1
}

stopDriver(){
    for id in ${drivers}
    do
        promptMsg="Stopping $id"
        echo ${promptMsg}
        echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
        stopId $id
    done
}

stopAS(){
    dnm=$1
logMsg s "$dnm"
    for i in $(seq 0 $len1)
    do
        if [ "${#drivers[$i]}" == "$dnm" ]; then
            echo "ids=${ids[$i]}"
            break
        fi
    done
logMsg e "AlarmStandard"
}

logMsg(){
    if [ "$1" == "s" ]; then
    promptMsg="Begin to stop FM Spark $2 applications."
    echo ${promptMsg}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    else
    promptMsg="FM Spark $2 applications have been stopped."
    echo ${promptMsg}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    fi
}


case $1 in
1|com.*.AlarmStandard)
    stopAS  $FMStandard
;;
2|com.*.AlarmMasterSlaveCorrelation)
;;
stopAS $FMAMS
3|com.*.AlarmDerivationCorrelation)
;;
stopAS $FMADC
all)
stopDriver
;;
*)
usage
exit 1
;;
esac