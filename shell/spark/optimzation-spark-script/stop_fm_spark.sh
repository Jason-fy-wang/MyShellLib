#!/bin/bash
CBase=$(cd $(dirname $0); pwd)
. ${CBase}/common.sh

run_command(){
    cmd=$1
if [ "$(whoami)" != "fcaps" ]; then
    echo "using the account:fcaps to execute."
    su - fcaps -c "${BASE}/sub_stop_fm_spark.sh $cmd"
    echo "Complete the execution."
else
    ${BASE}/sub_stop_fm_spark.sh $cmd
fi
}

if [ $# -ne 1 ]; then
usage
exit 1
fi

run_command $1