#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh
logCom "s" "${FMADC}"
ckADC=$(checkIfSubmit "${FMADC}")
if [ "$ckADC" -eq "0" ]; then
com="nohup \
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
  >> ${BASE}/../../runtime_log/fm_spark/start.log  2>&1 &"
  run_command $com
else
  echo "$FMADC is running.."
fi
  logCom "e" "${FMADC}"