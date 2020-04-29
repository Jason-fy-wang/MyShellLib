#!/bin/sh

if [ $# -ne 3 ]; then
  echo "usage: $0 src-ip dest-ip timestamp"
  #f.g. ./inc_sync_am.sh 10.163.119.68 10.163.119.68 "2020-04-17 00:00:00"
  exit
fi
Schema=fcaps_am
SrcIp=$1
SrcPort=5432
SrcDb=fcapsdb
SrcPasswd=fcaps_am
DestIp=$2
DestPort=5432
DestDb=fcapsdb
DestPasswd=fcaps_am
SrcConn="host=$SrcIp port=$SrcPort user=$Schema password=$SrcPasswd dbname=$SrcDb"
DestConn="host=$DestIp port=$DestPort user=$Schema password=$DestPasswd dbname=$DestDb"
Timestamp=$3

echo "Source connection: $SrcConn"
echo "Destination connection: $DestConn"
echo "Timestamp: $Timestamp"

tables=(
  vim_alarm
  pim_alarm
  ems_alarm
)

tables2=(
  vim_alarm
  pim_alarm
  ems_alarm
  am_collector_host_info
  am_collection_task
  am_supplement_task
  am_collection_source_monitor
  alarm_supplement_monitor
  alarm_sequence_analyze
  ems_pm_files
)
tables3=(
  am_collection_task
  am_supplement_task
  am_collection_source_monitor
  alarm_supplement_monitor
  alarm_sequence_analyze
  ems_pm_files
)

release_res(){
    dbinfo=$1
    for i in ${tables2[@]}; do
        Table=$i
        echo "Incremental synchronization for $Table"
        
        Sql="drop table IF EXISTS tmp_inc_$Table"
        echo "$Sql"
        psql --command "$Sql;" "$dbinfo"
    done
}

#export
for i in ${tables[@]}; do
  Table=$i
  echo "Incremental synchronization for $Table"
  
  Sql="drop table IF EXISTS tmp_inc_$Table"
  echo "$Sql"
  psql --command "$Sql;" "$SrcConn"
  
  Sql="create table tmp_inc_$Table as select * from $Table where collect_timestamp>='$Timestamp'"
  echo "$Sql"
  psql --command "$Sql;" "$SrcConn"
done

Table=am_collector_host_info
Sql="drop table IF EXISTS tmp_inc_$Table"
echo "$Sql"
psql --command "$Sql;" "$SrcConn" 
Sql="create table tmp_inc_$Table as select * from $Table"
echo "$Sql"
psql --command "$Sql;" "$SrcConn"

for i in ${tables3[@]}; do
  Table=$i
  echo "Incremental synchronization for $Table"
  
  Sql="drop table IF EXISTS tmp_inc_$Table"
  echo "$Sql"
  psql --command "$Sql;" "$SrcConn"
  
  Sql="create table tmp_inc_$Table as select * from $Table where update_time>='$Timestamp'"
  echo "$Sql"
  psql --command "$Sql;" "$SrcConn"
done

pg_dump -t 'tmp_inc_*' -Ft "$SrcConn" >inc_dump_$Schema.tar
echo "Dumped into inc_dump_$Schema.tar"

release_res "$SrcConn"


#import
for i in ${tables2[@]}; do
  Table=$i

  Sql="drop table IF EXISTS tmp_inc_$Table"
  echo "$Sql"
  psql --command "$Sql;" "$DestConn"
done

pg_restore -d "$DestConn" -Ft inc_dump_$Schema.tar
echo "Data restored into $Schema"

for i in ${tables[@]}; do
  Table=$i

  Sql="insert into $Table(uuid,alarm_id,new_alarm_id,alarm_status,alarm_seq,collect_timestamp,vendor_id,source_id,alarm_content) select uuid,alarm_id,new_alarm_id,alarm_status,alarm_seq,collect_timestamp,vendor_id,source_id,alarm_content from tmp_inc_$Table on conflict(uuid) do nothing"
  echo "$Sql"
  psql --command "$Sql;" "$DestConn"
done

psql --command "insert into am_collector_host_info(collector_id, collector_name,collector_inner_ip, collector_external_ip, state, heartbeat_time, lost_heartbeat_num, process_capacity, node_state) select collector_id, collector_name,collector_inner_ip, collector_external_ip, state, heartbeat_time, lost_heartbeat_num, process_capacity, node_state  from tmp_inc_am_collector_host_info on conflict(collector_id) do update set collector_name=excluded.collector_name,collector_inner_ip=excluded.collector_inner_ip, collector_external_ip=excluded.collector_external_ip, state=excluded.state, heartbeat_time=excluded.heartbeat_time, lost_heartbeat_num=excluded.lost_heartbeat_num, process_capacity=excluded.process_capacity, node_state=excluded.node_state ;" "$DestConn"

psql --command "insert into am_collection_task(task_id, task_template_id,source_id, collector_id, source_type, data_type, pm_period, protocol_type, task_type, api_interface,crontab, ftp_path, status, update_time) select task_id, task_template_id,source_id, collector_id, source_type, data_type, pm_period, protocol_type, task_type, api_interface,crontab, ftp_path, status, update_time from tmp_inc_am_collection_task on conflict(task_id) do update set  task_template_id=excluded.task_template_id,source_id=excluded.source_id, collector_id=excluded.collector_id, source_type=excluded.source_type, data_type=excluded.data_type, pm_period=excluded.pm_period, protocol_type=excluded.protocol_type, task_type=excluded.task_type, api_interface=excluded.api_interface,crontab=excluded.crontab, ftp_path=excluded.ftp_path, status=excluded.status, update_time=excluded.update_time ;"; "$DestConn"

psql --command "insert into am_supplement_task(task_id,source_id, collector_id, source_type,data_type,pm_period, protocol_type, ftp_path,api_interface,start_time, end_time, start_seq, end_seq, status, update_time) select task_id,source_id, collector_id, source_type,data_type,pm_period, protocol_type, ftp_path,api_interface,start_time, end_time, start_seq, end_seq, status, update_time from tmp_inc_am_supplement_task on conflict(task_id) do update set source_id=excluded.source_id, collector_id=excluded.collector_id, source_type=excluded.source_type,data_type=excluded.data_type,pm_period=excluded.pm_period, protocol_type=excluded.protocol_type, ftp_path=excluded.ftp_path,api_interface=excluded.api_interface,start_time=excluded.start_time, end_time=excluded.end_time, start_seq=excluded.start_seq, end_seq=excluded.end_seq, status=excluded.status, update_time=excluded.update_time ;" "$DestConn"

psql --command "insert into am_collection_source_monitor(source_id, info_type, alarm_seq, check_point, heartbeat_time, fm_last_submit_time,send_active_alarm_time,send_clear_alarm_time, if_uncleared_disconnect_alarm, if_uncleared_idle_alarm, current_idle_alarm_duration,update_time) select source_id, info_type, alarm_seq, check_point, heartbeat_time, fm_last_submit_time,send_active_alarm_time,send_clear_alarm_time, if_uncleared_disconnect_alarm, if_uncleared_idle_alarm, current_idle_alarm_duration,update_time from tmp_inc_am_collection_source_monitor on conflict(source_id, info_type) do update set alarm_seq=excluded.alarm_seq, check_point=excluded.check_point, heartbeat_time=excluded.heartbeat_time, fm_last_submit_time=excluded.fm_last_submit_time,send_active_alarm_time=excluded.send_active_alarm_time,send_clear_alarm_time=excluded.send_clear_alarm_time, if_uncleared_disconnect_alarm=excluded.if_uncleared_disconnect_alarm, if_uncleared_idle_alarm=excluded.if_uncleared_idle_alarm, current_idle_alarm_duration=excluded.current_idle_alarm_duration,update_time=excluded.update_time ;" "$DestConn"

psql --command "insert into alarm_supplement_monitor(auto_id, source_id, start_seq, end_seq, start_time, end_time, state, error_code, error_message, update_time) select auto_id, source_id, start_seq, end_seq, start_time, end_time, state, error_code, error_message, update_time from tmp_inc_alarm_supplement_monitor on conflict(auto_id) do update set source_id=excluded.source_id, start_seq=excluded.start_seq, end_seq=excluded.end_seq, start_time=excluded.start_time, end_time=excluded.end_time, state=excluded.state, error_code=excluded.error_code, error_message=excluded.error_message, update_time=excluded.update_time ;" "$DestConn"
  
  
psql --command "insert into alarm_sequence_analyze(auto_id, source_id, alarm_seq, event_time, if_complete_analysis, update_time) select auto_id, source_id, alarm_seq, event_time, if_complete_analysis, update_time from tmp_inc_alarm_sequence_analyze on conflict(auto_id) do update set source_id=excluded.source_id, alarm_seq=excluded.alarm_seq, event_time=excluded.event_time, if_complete_analysis=excluded.if_complete_analysis, update_time=excluded.update_time;" "$DestConn"

psql --command "insert into ems_pm_files(source_id, file_name, update_time) select source_id, file_name, update_time from tmp_inc_ems_pm_files on conflict(source_id) do update set file_name=excluded.file_name, update_time=excluded.update_time;" "$DestConn"


release_res $DestConn
rm -f inc_dump_$Schema.tar