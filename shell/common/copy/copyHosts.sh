#!/bin/bash
hosts=(10.163.103.30 10.163.103.29 10.163.103.28)
for h in ${hosts[@]}
do
scp fcaps.fm.spark-IR1.0.8.jar root@${h}:/opt/ericsson/nfvo/fcaps/lib/fm_spark/
done
if [ $? == '0' ];  then
    rm -f fcaps.fm.spark-IR1.0.8.jar
fi