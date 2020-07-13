#!/bin/bash
source /etc/profile
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
if [ "$(whoami)" != "fcaps" ]; then
    echo "using the account:fcaps to execute."
    su - fcaps -c "${BASE}/stop_fm_spark.sh all"
    sleep 2
    su - fcaps -c "${BASE}/start_fm_spark.sh all"
    echo "Complete the execution."
else
    ${BASE}/stop_fm_spark.sh "all"
    sleep 2
    ${BASE}/start_fm_spark.sh "all"
fi
