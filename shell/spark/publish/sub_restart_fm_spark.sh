#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh > /dev/null 2>&1

if [ $# -ne 1 ];then
    usage
    exit 1
fi

case $1 in
1)
${CBASE}/sub_stop_fm_spark.sh 1
sleep 2
${CBASE}/sub_start_fm_spark.sh 1
;;
2)
${CBASE}/sub_stop_fm_spark.sh 2
sleep 2
${CBASE}/sub_start_fm_spark.sh 2
;;
3)
${CBASE}/sub_stop_fm_spark.sh 3
sleep 2
${CBASE}/sub_start_fm_spark.sh 3
;;
all)
${CBASE}/sub_stop_fm_spark.sh all
sleep 2
${CBASE}/sub_start_fm_spark.sh all
;;
*)
usage
exit 1
;;
esac