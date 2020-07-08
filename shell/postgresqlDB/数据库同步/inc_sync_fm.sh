#!/bin/sh

if [ $# -ne 3 ]; then
  echo "usage: $0 src-ip dest-ip timestamp"
  #f.g. ./inc_sync_fm.sh 10.163.119.68 10.163.119.68 "2020-04-17 00:00:00"
  exit
fi
Schema=fcaps_fm
SrcIp=$1
SrcPort=5432
SrcDb=fcapsdb
SrcPasswd=fcaps_fm
DestIp=$2
DestPort=5432
DestDb=fcapsdb
DestPasswd=fcaps_fm
SrcConn="host=$SrcIp port=$SrcPort user=$Schema password=$SrcPasswd dbname=$SrcDb"
DestConn="host=$DestIp port=$DestPort user=$Schema password=$DestPasswd dbname=$DestDb"
Timestamp=$3

echo "Source connection: $SrcConn"
echo "Destination connection: $DestConn"
echo "Timestamp: $Timestamp"

tables=(
  standard_alarm
)

#export
for i in ${tables[@]}; do
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

#import
for i in ${tables[@]}; do
  Table=$i

  Sql="drop table IF EXISTS tmp_inc_$Table"
  echo "$Sql"
  psql --command "$Sql;" "$DestConn"
done

pg_restore -d "$DestConn" -Ft inc_dump_$Schema.tar
echo "Data restored into $Schema"

for i in ${tables[@]}; do
  Table=$i

  Sql="delete from $Table a \
    where (update_time>(now()-interval'7 days')) \
	and (update_time<=(select max(update_time) from tmp_inc_$Table)) \
	and exists (select alarm_id from tmp_inc_$Table b where b.alarm_id=a.alarm_id and b.alarm_status=a.alarm_status)"
  echo "$Sql"
  psql --command "$Sql;" "$DestConn"

  Sql="insert into $Table \
    select * from tmp_inc_$Table \
	on conflict (alarm_id, alarm_status) do update set alarm_id=EXCLUDED.alarm_id"
  echo "$Sql"
  psql --command "$Sql;" "$DestConn"
done
