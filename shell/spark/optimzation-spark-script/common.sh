#!/bin/bash
. /etc/profile
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')

usage(){
    echo -e  " 1--> AlarmStandard \n 2-->AlarmMasterSlaveCorrelation \n 3-->AlarmDerivationCorrelation\n"
    echo "$0  1 | 2 | 3 | all"
}



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
ids=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>driver-[0-9]{14}-[0-9]{3,}" | awk '{print $1}' | awk -F'>' '{print $2}'))
lenid=${#ids[@]}
let lenids=$lenid-1
drivers=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>com[a-z.]{19,}" | awk '{print $1}' | awk -F'[<>]' '{print $3}' ))
len=${#drivers[@]}
let len1=$len-1

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