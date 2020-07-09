#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark

sh ${BASE}/stop_fm_spark.sh
sleep 1
sh ${BASE}/start_fm_spark.sh
