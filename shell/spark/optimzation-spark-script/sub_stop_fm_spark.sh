#!/bin/bash
CBase=$(cd $(dirname $0); pwd)
. ${CBase}/common.sh

if [ $# -ne 1 ];then
    usage
    exit 1
fi

stopId(){
    id=$1
    promptMsg="Stopping $id"
    echo ${promptMsg}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    ${CMD} ${ClassName} kill spark://${MASTER}:7077 $id  >>${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log 2>&1
}

stopDriver(){
    for id in $(seq 0 ${lenids})
    do
        stopId ${ids[$id]}
    done
}

stopAS(){
    dnm=$1
    logMsg s "$dnm"
    cfg=0
    for i in $(seq 0 $len1)
    do
        if [ "${drivers[$i]}" == "$dnm" ]; then
            echo "ids=${ids[$i]}"
            let cfg++
            stopId ${ids[$i]}
            break
        fi
    done
    if [ "$cfg" -eq "0" ]; then
        logMsg o "$dnm not running.."
    fi
    logMsg e "$dnm"
}

logMsg(){
    if [ "$1" == "s" ]; then
    promptMsg="Begin to stop FM Spark $2 applications."
    echo ${promptMsg}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    elif [ "$1" == "e" ]; then
    promptMsg="FM Spark $2 applications have been stopped."
    echo ${promptMsg}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    else 
    echo ${2}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${2}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    fi
}


case $1 in
1|com.*.AlarmStandard)
    stopAS  $FMStandard
;;
2|com.*.AlarmMasterSlaveCorrelation)
    stopAS $FMAMS
;;
3|com.*.AlarmDerivationCorrelation)
    stopAS $FMADC
;;
all)
    stopDriver
;;
*)
usage
exit 1
;;
esac