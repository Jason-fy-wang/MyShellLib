#!/bin/bash
source /etc/profile

BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')

stopDriver(){
for hst in ${HOSTS}
do
    echo $hst
    if [ -n $hst ]; then
        DRIVER_ID=$(curl -s http://${hst}:8080 | grep 'value="driver' | grep -oP "driver-[\d-]+")
        if [ ${#DRIVER_ID[$@]} -gt 0 ];then
            for id in ${DRIVER_ID[$@]}
            do
                promptMsg="Stopping $id"
                echo ${promptMsg}
                echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
                
                ${CMD} ${ClassName}  kill spark://${hst}:7077 $id  >>${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log 2>&1
            done
            break 2

        fi
    fi
done

}

promptMsg="Begin to stop FM Spark applications."
echo ${promptMsg}
echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log

stopDriver

promptMsg="FM Spark applications have been stopped."
echo ${promptMsg}
echo "$(date "+%y/%m/%d %H:%M:%S") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log

