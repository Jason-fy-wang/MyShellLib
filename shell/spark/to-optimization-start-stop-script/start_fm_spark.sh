#!/bin/bash
source /etc/profile

BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark

if [ "$(whoami)" != "fcaps" ]; then
    echo "using the account:fcaps to execute."
    su - fcaps -c ${BASE}/sub_start_fm_spark.sh
    echo "Complete the execution."
else
    ${BASE}/sub_start_fm_spark.sh
fi
