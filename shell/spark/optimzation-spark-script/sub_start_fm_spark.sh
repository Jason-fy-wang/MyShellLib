#!/bin/bash
CBase=$(cd $(dirname $0); pwd)
. ${CBase}/common.sh


checkIfSubmit(){
  iv=$1
  ccs=0
  if [ "$len" -gt "0" ]; then
    for ii in $(seq 0 ${len1})
    do
      if [ "$iv" == "${drivers[$ii]}" ];then
        echo 1
        break
      else
        let ccs++
      fi
    done
    if [ "$ccs" -eq "${#drivers[@]}" ]; then
      echo 0
    fi
  else
    echo 0
  fi
}

startAS(){
logCom "s" "${FMStandard}"
ckAS=$(checkIfSubmit "${FMStandard}")
if [ "$ckAS" -eq "0" ]; then
nohup \
  /opt/spark-2.4.3/bin/spark-submit \
  --class com.ericsson.fcaps.fm.stream.AlarmStandard \
  --master spark://${sparkMaster} \
  --deploy-mode cluster \
  --executor-memory ${executorMemory1} \
  --total-executor-cores ${totalExecutorCores1} \
  --name fm-standard \
  --supervise \
  --conf spark.driver.port=${driverPort1} \
  --conf spark.blockManager.port=${blockManagerPort1} \
  --jars ${BASE}/../../lib/fm_spark/fcaps-fm-spark-with-dependencies.jar \
  ${BASE}/../../lib/fm_spark/fcaps.fm.spark-IR1.0.4.jar \
  ${BASE}/../../config/fm_spark/app.properties \
  >> ${BASE}/../../runtime_log/fm_spark/start.log 2>&1 &
else
  echo "$FMStandard is running.."
fi
logCom "e" "${FMStandard}"
}



startAMS(){
logCom "s" "${FMAMS}"
ckAMS=$(checkIfSubmit "${FMAMS}")
if [ "$ckAMS" -eq "0" ]; then
nohup \
  /opt/spark-2.4.3/bin/spark-submit \
  --class com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation \
  --master spark://${sparkMaster} \
  --deploy-mode cluster \
  --executor-memory ${executorMemory2} \
  --total-executor-cores ${totalExecutorCores2} \
  --name fm-masterSlaveCorrelation \
  --supervise \
  --conf spark.driver.port=${driverPort2} \
  --conf spark.blockManager.port=${blockManagerPort2} \
  --jars ${BASE}/../../lib/fm_spark/fcaps-fm-spark-with-dependencies.jar \
  ${BASE}/../../lib/fm_spark/fcaps.fm.spark-IR1.0.4.jar \
  ${BASE}/../../config/fm_spark/app.properties \
  >> ${BASE}/../../runtime_log/fm_spark/start.log  2>&1 &
else
  echo "$FMAMS is running.."
fi
  logCom "e" "${FMAMS}"
}

startADC(){
logCom "s" "${FMADC}"
ckADC=$(checkIfSubmit "${FMADC}")
if [ "$ckADC" -eq "0" ]; then
nohup \
  /opt/spark-2.4.3/bin/spark-submit \
  --class com.ericsson.fcaps.fm.stream.AlarmDerivationCorrelation \
  --master spark://${sparkMaster} \
  --deploy-mode cluster \
  --executor-memory ${executorMemory3} \
  --total-executor-cores ${totalExecutorCores3} \
  --name fm-derivationCorrelation \
  --supervise \
  --conf spark.driver.port=${driverPort3} \
  --conf spark.blockManager.port=${blockManagerPort3} \
  --jars ${BASE}/../../lib/fm_spark/fcaps-fm-spark-with-dependencies.jar \
  ${BASE}/../../lib/fm_spark/fcaps.fm.spark-IR1.0.4.jar \
  ${BASE}/../../config/fm_spark/app.properties \
  >> ${BASE}/../../runtime_log/fm_spark/start.log  2>&1 &
else
  echo "$FMADC is running.."
fi
  logCom "e" "${FMADC}"
}


logCom(){
  if [ "$1" == "s" ]; then
  promptMsg="Starting FM $1 Application."
  echo ${promptMsg}
  echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
  elif [ "$1" == "e" ]; then
  promptMsg="Complete $1 Applications startup."
  echo ${promptMsg}
  echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
  else
    echo ${2}
    echo "$(date "+%y/%m/%d %H:%M:%S") ${2}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
  fi
}

if [ $# -ne 1 ]; then
  usage 
  exit 1
fi

ival=$1
case $ival in
1|com.*.AlarmStandard)
  startAS
;;
2|com.*.AlarmMasterSlaveCorrelation)
startAMS
;;
3|com.*.AlarmDerivationCorrelation)
startADC
;;
all)
startAS
startAMS
startADC
;;
*)
usage
exit 1
;;
esac





