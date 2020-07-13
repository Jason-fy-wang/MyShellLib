#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
sparkMaster=`cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
driverPort1=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.driver.port1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
driverPort2=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.driver.port2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
driverPort3=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.driver.port3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
blockManagerPort1=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.blockManager.port1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
blockManagerPort2=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.blockManager.port2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
blockManagerPort3=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.blockManager.port3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
executorMemory1=`cat ${BASE}/../../config/fm_spark/app.properties | grep executor-memory1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
executorMemory2=`cat ${BASE}/../../config/fm_spark/app.properties | grep executor-memory2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
executorMemory3=`cat ${BASE}/../../config/fm_spark/app.properties | grep executor-memory3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
totalExecutorCores1=`cat ${BASE}/../../config/fm_spark/app.properties | grep total-executor-cores1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
totalExecutorCores2=`cat ${BASE}/../../config/fm_spark/app.properties | grep total-executor-cores2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
totalExecutorCores3=`cat ${BASE}/../../config/fm_spark/app.properties | grep total-executor-cores3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`

. ${BASE}/check_fm_spark.sh | grep 'running' > /dev/null 2>&1
if [ $? -eq 0 ];then
    echo "Already running"
    exit 3
fi


startAS(){
promptMsg="Starting FM AlarmStandard Application."
echo ${promptMsg}
echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
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
logCom "AlarmStandard"
}



startAMS(){
promptMsg="Starting FM AlarmMasterSlaveCorrelation Application."
echo ${promptMsg}
echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
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
  
  logCom "AlarmMasterSlaveCorrelation"
}

startADC(){
promptMsg="Starting FM AlarmDerivationCorrelation Application."
echo ${promptMsg}
echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
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

logCom "AlarmDerivationCorrelation"
}

logCom(){
promptMsg="Complete $1 Applications startup."
echo ${promptMsg}
echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
}
usage(){
  echo  "1--> AlarmStandard  2-->AlarmMasterSlaveCorrelation 3-->AlarmDerivationCorrelation"
  echo "$0  1 | 2 | 3 | all"
}
if [ $# -ne 1 ]; then
  usage 
fi

case $1 in
1|com.*.AlarmStandard)
  startAS
;;
2|com.*.AlarmMasterSlaveCorrelation)
;;
startAMS
3|com.*.AlarmDerivationCorrelation)
;;
startADC
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





