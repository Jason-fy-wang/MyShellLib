#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh
logCom "s" "${FMStandard}"
ckAS=$(checkIfSubmit "${FMStandard}")
if [ "$ckAS" -eq "0" ]; then
com="nohup \
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
  >> ${BASE}/../../runtime_log/fm_spark/start.log 2>&1 &"
run_command $com
else
  echo "$FMStandard is running.."
fi
logCom "e" "${FMStandard}"