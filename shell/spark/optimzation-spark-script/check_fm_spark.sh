#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
checkStatus(){
count=0

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
            echo 1
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
lena=${#Apps[@]}
let lena1=$len-1
key1="Running Drivers"
key2="row-fluid"
ids=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>driver-[0-9]{14}-[0-9]{3,}" | awk '{print $1}' | awk 
-F'>' '{print $2}'))
drivers=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>com[a-z.]{19,}" | awk '{print $1}' | awk -F'[<>]' '{print $3}' ))
len=${#drivers[@]}
let len1=$len-1

if [ "$len" -ge 3 ]; then
	echo "FM Spark Driver is running"
	exit 0
else
	for ai in $(seq 0 ${lena1})
	do
		cct=0
		for di in $(seq 0 ${len1})
		do
			if [ "${drivers[$di]}" == "${Apps[$lena1]}" ]; then
				break
			else
				let cct++
			fi
		done
		if [ "$cct" -eq "${len}" ]; then
			echo "Something error in driver $ai"
		fi
	done
fi


