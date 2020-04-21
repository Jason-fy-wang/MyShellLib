#!/bin/sh

# 此inc_sync_{am,fm}的脚本用于对两个数据库之前的数据增量同步
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

pg_dump -t 'tmp_inc_*' -F "$SrcConn" >inc_dump_$Schema.tar
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

  Sql="insert into $Table select * from tmp_inc_$Table"
  echo "$Sql"
  psql --command "$Sql;" "$DestConn"
done
