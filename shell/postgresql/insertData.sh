#!/bin/bash
#[root@dpa-00 fm_app]# dd=$(expr $(date +%s -d "2020-10-21 00:00:00") + 70)
#[root@dpa-00 fm_app]# date -d"1970-01-01 UTC $dd seconds" +"%Y-%m-%d %H:%M:%S"
#2020-10-21 00:01:10

gg="2020-10-21 00:00:00"
# final=2020-10-21 02:46:40
insert(){
    begin=$1
    stop=$2
    echo "begin=$begin,end=$end,pid=[$$]"
    SrcConn="host=10.163.119.68 port=5432 user=fcaps_fm password=fcaps_fm dbname=fcapsdb"
    for i in $(seq $begin $stop)
    do
    v="$(date -d"1970-01-01 UTC $(expr $(date +%s -d "2020-10-21 00:00:00") + $i) seconds" +"%Y-%m-%d %H:%M:%S")"
    sql="insert into standard_alarm (alarm_id,clear_operate_user, alarm_status, alarm_seq, clear_flag, collection_time, event_time, alarm_content, if_confirm, if_comment, clear_time, \"latest_arrive_time\",if_master, if_slave, update_time) values (322633289,'admin',1,$i,'f','2020-08-21 15:45:39','"
    sql+="$v',"
    sql+="'{\"pFlag\": \"Yes\", \"PVFlag\": \"vim\", \"fmTime\": \"2020-08-21 16:48:51\", \"addInfo\": \"probable_cause:165;Project:null;vimvendor:Ericsson\", \"alarmId\": 322633269, \"alarmSeq\": "
    sql+="$i, \"province\": \"BJ;TJ;HE;SX;NM;LN;JL;HL;JS;SD;SH;AH;ZJ;FJ;JX;HA;HB;HN;GD;GX;HI;SC;GZ;YN;XZ;SN;GS;QH;NX;XJ;CQ\", \"sourceID\": \"pim001\", \"vendorId\": \"ER\", \"vmIdList\": \"vmids\", \"alarmType\": \"Server\", \"eventTime\": \"2020-08-21 15:45:39\", \"objectUID\": \"210200A00QH185003078\", \"specialty\": \"NFV-vIMS\", \"alarmTitle\": \"ACPI is in the soft-off state\", \"dataSource\": \"PIM\", \"domainType\": \"CT\", \"hostIdList\": \"hostids\", \"objectName\": \"Server\", \"objectType\": \"server\", \"regionPath\": \"/\", \"todoNotify\": true, \"vendorName\": \"爱立信\", \"alarmStatus\": 1, \"isDuplicate\": false, \"todoPushGui\": true, \"locationInfo\": \"locationInfo\", \"origSeverity\": 1, \"standardFlag\": false, \"subObjectUID\": \"NFV-PIM-01-1/Server_02A3FQH182000293\", \"subObjectName\": \"Server\", \"subObjectType\": \"server\", \"todoReportOss\": true, \"collectionTime\": \"2020-08-21 15:45:39\", \"operateDataType\": \"alarm\", \"specificProblem\": \"27001\", \"todoCorrelation\": true, \"specificProblemID\": \"27001\",\"localProducer\":true,\"localOwner\":true,\"initialAlarmId\":123456, \"netManagerAlarmId\":1098,\"businessType\":\"businessType\",\"clearOperateUser\":\"clearOperateUser\",\"isFilter\":true,\"snssaiList\":\"snssaiList\",\"nssiList\":\"nssiList\",\"nssiNameList\":\"nssiNameList\",\"netManagerAlarmSeverity\":\"123\"}','f','f','2020-08-21 15:45:39','2020-08-21 15:45:39','f','f' ,'2020-08-21 16:37:56');"
        res=$(psql "${SrcConn}" -c "${sql}")
        if [ "$i" -eq 10000 ]; then
            echo "final = $v"
        fi
    done
}

# 多进程处理
ffile=/tmp/$.fifo
mkfifo $ffile

exec 6<>$ffile
rm $ffile

for ((idx=0;idx<10;idx++));
do
    echo 
done >&6

num=10
for ((idx=1;idx<=$num;idx++));
do
    if [ "$idx" -eq 1 ]; then
        start=$idx
        #end=$(expr $idx \* 1000)
        end=$(($idx * 1000))
    else
        start=$(expr $end + 1)
        #end=$(expr $idx \* 1000)
        end=$(($idx * 1000))
    fi
    echo "start=$start,end=$end"

    read -u6 {
        insert $start $end && {
            echo "sub process is finished"
        }||{
            echo "sub error."
        }
        echo >&6
    } &

done
wait
exec 6>&-