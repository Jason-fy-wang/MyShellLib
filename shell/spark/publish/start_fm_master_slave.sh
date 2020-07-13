#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh
logCom "s" "${FMAMS}"
ckAMS=$(checkIfSubmit "${FMAMS}")
if [ "$ckAMS" -eq "0" ]; then
com="nohup \
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
  >> ${BASE}/../../runtime_log/fm_spark/start.log  2>&1 &"
  run_command $com
else
  echo "$FMAMS is running.."
fi
  logCom "e" "${FMAMS}"