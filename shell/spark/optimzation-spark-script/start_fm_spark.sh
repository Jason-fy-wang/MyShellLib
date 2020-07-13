#!/bin/bash
CBase=$(cd $(dirname $0); pwd)
. ${CBase}/common.sh

run_command(){
com=$1
if [ "$(whoami)" != "fcaps" ]; then
    echo "using the account:fcaps to execute."
    su - fcaps -c "${BASE}/sub_start_fm_spark.sh $com"
    echo "Complete the execution."
else
    ${BASE}/sub_start_fm_spark.sh $com
fi
}

if [ $# -ne 1 ];then
usage
exit 1
fi

run_comand $1