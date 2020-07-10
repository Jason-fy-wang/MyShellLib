#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
count=0

checkMaster(){
for tmp in ${HOSTS}
do
        if [ -n $tmp ]; then
                        result=$(echo $(curl -s http://${tmp}:8080 | grep Status: | grep ALIVE ))
                        if [ ${#result} -ge 1 ]; then
                                echo "the Active Master is: " ${tmp}
				break
			else
				let count++
                        fi
			if [ $count -eq ${Nhosts} ];then
                		echo "Exception: No Active Master running now."
        		fi
        fi
done
}

checkMaster
