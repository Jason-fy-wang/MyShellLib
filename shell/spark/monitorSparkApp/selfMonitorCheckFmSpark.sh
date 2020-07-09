#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat /opt/ericsson/nfvo/fcaps/config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
#HOSTS=$(cat ${BASE}/hosts | sed ':lab;N;s#\n# #g; t lab' 2>/dev/null)
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
checkStatus(){
count=0
for tmp in ${HOSTS}
do
        if [ -n $tmp ]; then
		drivers=$(curl -s http://${tmp}:8080 | grep 'Running Drivers' | awk -F[\(\)] '{print $2}' 2>/dev/null)
                if [[ -n ${drivers} &&  ${drivers} -ge 3 ]];then
                        echo "0"
                        break
                else
                        let count++
                fi
        fi
        if [ $count -eq ${Nhosts} ];then
                echo "1"
        fi
done
}

checkStatus

