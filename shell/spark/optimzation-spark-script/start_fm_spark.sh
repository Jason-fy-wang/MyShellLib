#!/bin/bash
. /etc/profile
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark

run_comand(){
com=$1
if [ "$(whoami)" != "fcaps" ]; then
    echo "using the account:fcaps to execute."
    su - fcaps -c $com
    echo "Complete the execution."
else
    ${BASE}/sub_start_fm_spark.sh $com
fi
}
usage(){
  echo  "1--> AlarmStandard  2-->AlarmMasterSlaveCorrelation 3-->AlarmDerivationCorrelation"
  echo "$0  1 | 2 | 3 | all"
}

if [ $# -ne 1 ];then
usage
exit 1
fi

run_comand $1