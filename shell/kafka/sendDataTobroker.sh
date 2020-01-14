#!/bin/bash
BASE=$(cd $(dirname $0); pwd)

send(){
until [ "$start" -ge "$end" ]
do
    echo '{"locationInfo":"36.0Snapshots Availability is 36.0Snapshots Availability is -ProbableCause(OSS)= (Linux) bjenmms01 -  (Snapshots Status) Snapshots Status - -EventType(OSS)=bjenmms01 - Snapshots Status - Snapshots Availability","specialty":"NFV","collectionTime":"2020-01-03 23:00:22","domainType":"CT","vendorId":"HW","pVFlag":"pim","objectType":"switch","province":"HE","alarmId":"761b53169a0e2dde6139d7f20f0f31eb","eventTime":"2020-01-03 20:30:40","alarmTitle":"PIM告警标题1server Controller 0 Failed!","sourceID":"pim001","specificProblemID":"3712.31","regionPath":"/0HB/0HE/2pim010","origSeverity":3,"objectUID":"2d66a1eed9d14524afa8eRhbbTRhbbfT","subObjectUID":"4350","addInfo":"Project:null;DeviceName:Compute1;DeviceId:026XZY82","vendorName":"华为","uUID":"51337bff6af7468d8e6d921a88161e67","alarmStatus":1,"alarmType":"1","initialAlarmId":"1","specificProblem":"Hardware Error","subObjectName":"Controller-0","subObjectType":"Controller","objectName":"Switch1","alarmSeq":25,"dataSource":"PIM"}' | sed 's#"alarmSeq":[0-9]*#"alarmSeq":'$start'#' | /opt/kafka-2.11/bin/kafka-console-producer.sh  --broker-list  10.163.249.146:9092,10.163.249.147:9092,10.163.249.148:9092  -sync --topic test | > /dev/null

    start=$(($start+1))
done
}

usage(){
echo "$0 start count"

}

main(){

if [ $# -lt 2 ];then
usage
exit 1
fi

send $*
}


main $*
