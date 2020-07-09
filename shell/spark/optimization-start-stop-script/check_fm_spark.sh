#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
checkStatus(){
count=0
for tmp in ${HOSTS}
do
        if [ -n $tmp ]; then
                #drivers=$(echo $(curl -s http://${tmp}:8080 | grep 'value="driver' | grep -oP "driver-[\d-]+") | awk -F=  '{lens=split($1,res," ");print length(res)}')
		drivers=$(curl -s http://${tmp}:8080 | grep 'Running Drivers' | awk -F[\(\)] '{print $2}')
                if [[ -n ${drivers} &&  ${drivers} -ge 3 ]];then
                        echo "FM Spark Driver is running"
                        break
                else
                        let count++
                fi
        fi
        if [ $count -eq ${Nhosts} ];then
                echo "FM Spark Driver is something error"
        fi
done
}

checkStatus

